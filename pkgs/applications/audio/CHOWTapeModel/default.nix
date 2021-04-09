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
, gtk2-x11
, webkitgtk
, cmake
, pcre
}:

stdenv.mkDerivation rec {
  pname = "CHOWTapeModel";
  version = "unstable-2021-03-30";

  src = fetchFromGitHub {
    owner = "jatinchowdhury18";
    repo = "AnalogTapeModel";
    rev = "e5826b9a055ca5f87b614f3ab28e11240eadb8ea";
    sha256 = "06k8ndpajbdbha63j5ds9glr31rxn1hl1hzbiixc2yai4cadrhxd";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkgconfig
    cmake
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
    gtk2-x11
    webkitgtk
    pcre
  ];

  postPatch = "    cd Plugin/";
  # buildPhase = ''
  # cd Plugin/
  # chmod +x build_linux.sh
  # ./build_linux.sh
  # '';

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
