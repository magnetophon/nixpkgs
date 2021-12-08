{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, cairo, libxkbcommon
, xcbutilcursor, xcbutilkeysyms, xcbutil, libXrandr, libXinerama, libXcursor
, alsa-lib, libjack2, lv2 }:

let
  juce-lv2 = stdenv.mkDerivation rec {
    name = "JUCE-lv2";

    src = fetchFromGitHub {
      owner = "lv2-porting-project";
      repo = "JUCE";
      rev = "f7eb3b4681c1fb4735bcd388d7a5ed10ccd24aba";
      sha256 = "sha256-jwWDB0XXaKkHJDNOSnhV4tDd+2lt61Qp8gFwXDuY63c=";
    };
    installPhase = ''
      cp -r . $out
    '';
  };

in stdenv.mkDerivation rec {
  pname = "surge-XT";
  version = "unstable-2021-12-07";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    rev = "c61ae7f2e1e8ecfc646030618bd3c4439d3ddf79";
    sha256 = "sha256-R8qGDxJffYddeDjEtoIe0gB+WMwCEyvoAAhaxPyM/SA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    cairo
    libxkbcommon
    xcbutilcursor
    xcbutilkeysyms
    xcbutil
    libXrandr
    libXinerama
    libXcursor
    alsa-lib
    libjack2
    lv2
  ];

  cmakeFlags = [
    "-Bbuild"
    "-DJUCE_SUPPORTS_LV2=True"
    "-DSURGE_JUCE_PATH=${juce-lv2}"
  ];

  enableParallelBuilding = true;

  buildPhase = ''
    cmake --build build --target surge-xt_LV2 surge-fx_LV2 surge-xt_Packaged surge-fx_Packaged --parallel
  '';

  installPhase = ''
    cmake --install build
  '';

  doInstallCheck = false;

  meta = with lib; {
    description =
      "LV2 & VST3 synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon orivej ];
  };
}
