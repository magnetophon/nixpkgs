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
  version = "unstable-2021-11-30";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    rev = "d04ac3d3a2233e5532e9e46c4d614d6da6084035";
    sha256 = "sha256-aqC+bpzv2HJI/GjmKMrOcofg4/z4X1Oie4jX3O537iM=";
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
    "-Bbuild_lv2"
    "-DJUCE_SUPPORTS_LV2=True"
    "-DSURGE_JUCE_PATH=${juce-lv2}"
  ];

  enableParallelBuilding = true;

  buildPhase = ''
    cmake --build build_lv2 --config Release --target surge-xt_LV2
    cmake --build build_lv2 --config Release --target surge-fx_LV2
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/lib/vst3 $out/share/Surge\ XT
    cp -r build_lv2/src/surge-xt/surge-xt_artefacts/Release/LV2/Surge\ XT.lv2 $out/lib/lv2
    cp -r build_lv2/src/surge-xt/surge-xt_artefacts/Release/VST3/Surge\ XT.vst3 $out/lib/vst3
    cp -r build_lv2/src/surge-fx/surge-fx_artefacts/Release/VST3/Surge\ XT\ Effects.vst3 $out/lib/vst3
    cp -r build_lv2/src/surge-fx/surge-fx_artefacts/Release/LV2/Surge\ XT\ Effects.lv2 $out/lib/lv2
    cp -r ../resources/data/* $out/share/Surge\ XT/
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
