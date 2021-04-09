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
    rev = "b6f405e495006e0918bae0c4b35871e4def9a79";
    sha256 = "0vgacj14bf0fb5kyh47lyhw3n1mkpcd6372xcf7ydci9rwlz8sw5";
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
