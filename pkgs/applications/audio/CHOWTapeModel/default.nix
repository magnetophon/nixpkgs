{ alsa-lib
, at-spi2-core
, cmake
, curl
, dbus
, epoxy
, fetchFromGitHub
, freeglut
, freetype
, gtk3
, lib
, libGL
, libXcursor
, libXdmcp
, libXext
, libXinerama
, libXrandr
, libXtst
, libdatrie
, libjack2
, libpsl
, libselinux
, libsepol
, libsysprof-capture
, libthai
, libxkbcommon
, pcre
, pkg-config
, python3
, sqlite
, stdenv
, util-linuxMinimal
, webkitgtk
, gcc-unwrapped
}:

stdenv.mkDerivation rec {
  pname = "CHOWTapeModel";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "jatinchowdhury18";
    repo = "AnalogTapeModel";
    rev = "v${version}";
    sha256 = "0rl04hr6gpqdkjvvvxqv4qiqrwjd0gmc9nlpqmdjdlbgm195jmzv";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    curl
    dbus
    epoxy
    freeglut
    freetype
    gtk3
    libGL
    libXcursor
    libXdmcp
    libXext
    libXinerama
    libXrandr
    libXtst
    libdatrie
    libjack2
    libpsl
    libselinux
    libsepol
    libsysprof-capture
    libthai
    libxkbcommon
    pcre
    python3
    sqlite
    # util-linuxMinimal
    # webkitgtk
    gcc-unwrapped
  ];

  cmakeFlags = [ "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
                 "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
                 "-DCMAKE_NM=${gcc-unwrapped}/bin/gcc-nm" ];

  postPatch = "cd Plugin";

  # buildPhase = ''
  #   cmake -Bbuild
  #   cmake --build build/ --config Release
  # '';

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/lib/vst3 $out/bin $out/share/doc/CHOWTapeModel/
    cd CHOWTapeModel_artefacts/Release
    cp libCHOWTapeModel_SharedCode.a  $out/lib
    cp -r LV2/CHOWTapeModel.lv2 $out/lib/lv2
    cp -r VST3/CHOWTapeModel.vst3 $out/lib/vst3
    cp Standalone/CHOWTapeModel  $out/bin
    cp ../../../../Manual/ChowTapeManual.pdf $out/share/doc/CHOWTapeModel/
  '';

  meta = with lib; {
    homepage = "https://github.com/jatinchowdhury18/AnalogTapeModel";
    description = "Physical modelling signal processing for analog tape recording. LV2, VST3 and standalone";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
