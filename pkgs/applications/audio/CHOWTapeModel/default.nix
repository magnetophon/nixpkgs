{ alsaLib
, curl
, fetchFromGitHub
, freeglut
, freetype
, libGL
, libXcursor
, libXext
, libXinerama
, libXrandr
, libjack2
, pkgconfig
, python3
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "CHOWTapeModel";
  version = "unstable-2020-12-12";

  src = fetchFromGitHub {
    owner = "jatinchowdhury18";
    repo = "AnalogTapeModel";
    rev = "a7cf10c3f790d306ce5743bb731e4bc2c1230d70";
    sha256 = "09nq8x2dwabncbp039dqm1brzcz55zg9kpxd4p5348xlaz5m4661";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkgconfig
  ];
  buildInputs = [
    alsaLib
    curl
    freeglut
    freetype
    libGL
    libXcursor
    libXext
    libXinerama
    libXrandr
    libjack2
    python3
  ];

  buildPhase = ''
    cd Plugin/
    ./build_linux.sh
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/lib/vst3 $out/bin $out/share/doc/${pname}/
    cd Builds/LinuxMakefile/build/
    cp ${pname}.a  $out/lib
    cp -r ${pname}.lv2 $out/lib/lv2
    cp -r ${pname}.vst3 $out/lib/vst3
    cp ${pname}  $out/bin
    cp ../../../../Manual/ChowTapeManual.pdf $out/share/doc/${pname}/
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/jatinchowdhury18/AnalogTapeModel";
    description = "Physical modelling signal processing for analog tape recording. LV2, VST3 and standalone";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ magnetophon ];
    platforms = with platforms; linux;
  };
}
