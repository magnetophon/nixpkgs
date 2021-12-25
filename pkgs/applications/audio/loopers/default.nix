{ rustPlatform, fetchFromGitHub, fetchgit, runCommand, lib, libjack2, mesa, SDL2, python2, ninja, gn, llvmPackages }:

rustPlatform.buildRustPackage rec {
  pname = "loopers";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mwylde";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-K3G56aa5Piac+wv9dEOPPMGJ0U1E8mbgDr30/GAO+j0=";
    fetchSubmodules = true;
  };

  cargoSha256 = "sha256-OlIgibT18DEGYrVtX3fPlzd00bkC0qjji9FgdxHmjto=";

  SKIA_SOURCE_DIR =
    let
      repo = fetchFromGitHub {
        owner = "rust-skia";
        repo = "skia";
        # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
        rev = "m91-0.39.4";
        sha256 = "sha256-ovlR1vEZaQqawwth/UYVUSjFu+kTsywRpRClBaE1CEA=";
      };
      # The externals for skia are taken from skia/DEPS
      externals = lib.mapAttrs (n: v: fetchgit v) (lib.importJSON ./skia-externals.json);
    in
      runCommand "source" {} (
        ''
          cp -R ${repo} $out
          chmod -R +w $out

          mkdir -p $out/third_party/externals
          cd $out/third_party/externals
        '' + (builtins.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "cp -ra ${value} ${name}") externals))
      );

  # SKIA_SOURCE_DIR =
  #   let
  #     repo = fetchFromGitHub {
  #       owner = "rust-skia";
  #       repo = "skia";
  #       # see rust-skia:skia-bindings/Cargo.toml#package.metadata skia
  #       rev = "m98-0.46.1";
  #       sha256 = "sha256-bk4ax7iikdxtoLhpNPRImLLZ4JxymJmrpYiVqG3azDQ=";
  #     };
  #     # The externals for skia are taken from skia/DEPS
  #     externals = lib.mapAttrs (n: v: fetchgit v) (lib.importJSON ./skia-externals.json);
  #   in
  #     runCommand "source" {} (
  #       ''
  #         cp -R ${repo} $out
  #         chmod -R +w $out

  #         mkdir -p $out/third_party/externals
  #         cd $out/third_party/externals
  #       '' + (builtins.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "cp -ra ${value} ${name}") externals))
  #     );

  SKIA_NINJA_COMMAND = "${ninja}/bin/ninja";
  SKIA_GN_COMMAND = "${gn}/bin/gn";
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";


  preConfigure = ''
    unset CC CXX
  '';

  nativeBuildInputs = [ python2 ];
  buildInputs = [ libjack2 mesa SDL2 ];

  meta = with lib; {
    description = "A graphical live looper, written in Rust, designed for ease of use and rock-solid stability";
    homepage = "https://github.com/mwylde/loopers";
    license = licenses.mit;
    maintainers = with maintainers; [ magnetophon ];
  };
}
