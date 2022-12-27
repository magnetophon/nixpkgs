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
    version = "unstable-2021-12-11";

    # https://github.com/lv2-porting-project/JUCE/tree/6.1.5-lv2
    src = fetchFromGitHub {
      owner = "lv2-porting-project";
      repo = "JUCE";
      rev = "a59c238919dab18e28d97a98d8c0f737a058d15a";
      sha256 = "sha256-SMsTBgg/OHPb2z5fvpDZIJeev1axc2gLYf9VVF8IXfk=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      cp -r . $out
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "surge-XT";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    rev = "release_xt_${version}";
    fetchSubmodules = true;
    sha256 = "sha256-rgTasYdNd0vz4JIGU8lDijVXRWFK6g6R+pJ7VFoWWgg=";
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

  cmakeFlags = [
    "-DJUCE_SUPPORTS_LV2=ON"
    "-DSURGE_JUCE_PATH=${juce-lv2}"
  ];

  # JUCE dlopen's these at runtime, crashes without them
  NIX_LDFLAGS = (toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
  ]);

  # see https://github.com/NixOS/nixpkgs/pull/149487#issuecomment-991747333
  postPatch = ''
    export XDG_DOCUMENTS_DIR=$(mktemp -d)
  '';

  meta = with lib; {
    description = "LV2 & VST3 synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon orivej ];
  };
}
