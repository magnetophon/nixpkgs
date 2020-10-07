{ stdenv
, callPackage
, makeRustPlatform
, fetchFromGitHub
, IOKit ? null
, makeWrapper
, glib
, gst_all_1
, libsixel
}:

assert stdenv.isDarwin -> IOKit != null;

let
  date = "2020-05-22";
  mozillaOverlay = fetchFromGitHub {
    owner = "mozilla";
    repo = "nixpkgs-mozilla";
    rev = "e912ed483e980dfb4666ae0ed17845c4220e5e7c";
    sha256 = "08fvzb8w80bkkabc1iyhzd15f4sm7ra10jn32kfch5klgl0gj3j3";
  };
  mozilla = callPackage "${mozillaOverlay.out}/package-set.nix" {};
  rustNightly = (mozilla.rustChannelOf { inherit date; channel = "nightly"; }).rust;
  rustPlatform = makeRustPlatform {
    cargo = rustNightly;
    rustc = rustNightly;
  };
in
rustPlatform.buildRustPackage rec {
  pname = "hunter";
  # version = "1.3.5";
  version = "unstable-2020-05-25";

  src = fetchFromGitHub {
    owner = "rabite0";
    repo = "hunter";
    # rev = "v${version}";
    # sha256 = "0z28ymz0kr726zjsrksipy7jz7y1kmqlxigyqkh3pyh154b38cis";
    rev = "355d9a3101f6d8dc375807de79e368602f1cb87d";
    sha256 = "0d6gdzc5cc235zvk1zw3m7kgaq78raqpjrcpvbbzw50vdy80sv27";
  };

  RUSTC_BOOTSTRAP=1;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-bad
    libsixel
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  postInstall = ''
    wrapProgram $out/bin/hunter --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  # cargoSha256 = "18ycj1f310s74gkjz2hh4dqzjb3bnxm683968l1cbxs7gq20jzx6";
  cargoSha256 = "1fq66rxsqg8q0q16myr2c8pv0xakxjm177zig5kza1yvpggrn67d";

  meta = with stdenv.lib; {
    description = "The fastest file manager in the galaxy!";
    homepage = https://github.com/rabite0/hunter;
    license = licenses.wtfpl;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
