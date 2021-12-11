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
    version = "unstable-2021-10-21";

    # lv2 branch
    src = fetchFromGitHub {
      owner = "lv2-porting-project";
      repo = "JUCE";
      rev = "f7eb3b4681c1fb4735bcd388d7a5ed10ccd24aba";
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
  pname = "surge-XT";
  version = "unstable-2021-12-07";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    rev = "c61ae7f2e1e8ecfc646030618bd3c4439d3ddf79";
    fetchSubmodules = true;
    sha256 = "sha256-R8qGDxJffYddeDjEtoIe0gB+WMwCEyvoAAhaxPyM/SA=";
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

  meta = with lib; {
    description = "LV2 & VST3 synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon orivej ];
  };
}
