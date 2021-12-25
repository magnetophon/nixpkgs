{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, alsa-lib
, freetype
, libjack2
, lv2
, libX11
, libXcursor
, libXext
, libXinerama
, libXrandr
}:

let
  juce-lv2 = stdenv.mkDerivation {
    pname = "juce-lv2";
    version = "unstable-2021-12-22";

    # lv2 branch
    src = fetchFromGitHub {
      owner = "lv2-porting-project";
      repo = "JUCE";
      # see https://github.com/lv2-porting-project/JUCE/issues/18
      rev = "c5174d84fdb12e2233ec3c502fb6a9c54ed87a9f";
      sha256 = "sha256-jwWDB0XXaKkHJDNOSnhV4tDd+2lt61Qp8gFwXDuY63c=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      cp -r . $out
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "imogen";
  version = "unstable-2021-11-07";

  src = fetchFromGitHub {
    owner = "benthevining";
    repo = "imogen";
    rev = "c33d080ab58da04f5cb9143bf6db75b53853bf4f";
    fetchSubmodules = true;
    sha256 = "sha256-IiSegYIsEuXgrB+9i/rl6edFWqE15qjszPdNpcPgJOM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    freetype
    libjack2
    lv2
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
  ];

  # cmakeFlags = [
  # "-DJUCE_SUPPORTS_LV2=ON"
  # "-DSURGE_JUCE_PATH=${juce-lv2}"
  # ];

  # JUCE dlopen's these at runtime, crashes without them
  NIX_LDFLAGS = (toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
    "-ljack -L${libjack2}"
  ]);

  #   patchPhase = ''
  #     substituteInPlace CMakeLists.txt \
  #       --replace "# Banner {{{" \
  #                 "# Banner {{{
  # add_compile_options(
  #       -fvisibility=hidden
  #       -fvisibility-inlines-hidden
  #        )"
  #   '';

  # preConfigure = ''
  # cmakeFlagsArray+=(-DCMAKE_EXE_LINKER_FLAGS="-no-pie")
  # '' ;

  # see https://github.com/NixOS/nixpkgs/pull/149487#issuecomment-991747333
  # postPatch = ''
  # export XDG_DOCUMENTS_DIR=$(mktemp -d)
  # '';

  meta = with lib; {
    description = "ultimate vocal harmonizer";
    homepage = "http://benthevining.github.io/imogen/";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon ];
  };
}
