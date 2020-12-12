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
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "magnetophon";
    # owner = "jatinchowdhury18";
    repo = "AnalogTapeModel";
    rev = "51442a61e70f85f07643ee1485581fcc63236ffd";
    # rev = "v${version}";
    sha256 = "1cdmzz8y3lfx8813mbi7gq366xckra2j0nzwdz7qg566g5gylj0v";
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

  prePatch = ''
    substituteInPlace Plugin/build_linux.sh --replace "CONFIG=Release make" "CONFIG=Release make LV2 VST3 Standalone"
  '';

  buildPhase = ''
    cd Plugin/
    chmod +x build_linux.sh
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
