{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, cairo, libxkbcommon, xcbutilcursor, xcbutilkeysyms, xcbutil, libXrandr, libXinerama, libXcursor, alsa-lib, libjack2 ,lv2, gcc-unwrapped
}:

stdenv.mkDerivation rec {
  pname = "BYOD";
  version = "unstable-2021-09-21";

  src = fetchFromGitHub {
    owner = "Chowdhury-DSP";
    repo = pname;
    rev = "ed65d3e0a4f311a67161852b20adc6e8e39ac1f7";
    sha256 = "0cdfy453dgxsb3d7pxxdppm0g62bpb5g9nh5fj5q7zymiyd3r5vi";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ cairo libxkbcommon xcbutilcursor xcbutilkeysyms xcbutil libXrandr libXinerama libXcursor alsa-lib libjack2 lv2 ];

  cmakeFlags = [ "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
                 "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
                 "-DCMAKE_NM=${gcc-unwrapped}/bin/gcc-nm" ];


  installPhase = ''
    mkdir -p $out/lib/lv2 $out/lib/vst3 $out/bin $out/lib
    cd BYOD_artefacts/Release
    cp -r LV2/BYOD.lv2 $out/lib/lv2
    cp -r VST3/BYOD.vst3 $out/lib/vst3
    cp Standalone/BYOD  $out/bin
    cp libBYOD_SharedCode.a  $out/lib
  '';

  doInstallCheck = false;

  meta = with lib; {
    description = "Build-your-own guitar distortion!";
    homepage = "https://github.com/Chowdhury-DSP/BYOD";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon ];
  };
}
