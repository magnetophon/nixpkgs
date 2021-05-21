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
, util-linuxMinimal
, libselinux
, libsepol
, libthai
, libdatrie
, libXdmcp
, libxkbcommon
, epoxy
, dbus
, at-spi2-core
, libXtst
, libsysprof-capture
, sqlite
, libpsl
, brotli
, lv2
}:

stdenv.mkDerivation rec {
  pname = "ChowKick";
  version = "unstable-2021-05-17";

  src = fetchFromGitHub {
    owner = "Chowdhury-DSP";
    repo = pname;
    rev = "1efcc67d4fafc6293fd766bfd8beaef8f3cf8e8b";
    sha256 = "1njsmz93wk0j60dxhpr33wk6jvnhjaz3m1qxhmmbsfq4gc77r9q2";
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
    util-linuxMinimal
    libselinux
    libsepol
    libthai
    libdatrie
    libXdmcp
    libxkbcommon
    epoxy
    dbus
    at-spi2-core
    libXtst
    libsysprof-capture
    sqlite
    libpsl
    brotli
    lv2
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
  ];

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/lib/vst3 $out/bin
    cp -r ChowKick_artefacts/Release/LV2//${pname}.lv2 $out/lib/lv2
    cp -r ChowKick_artefacts/Release/VST3/${pname}.vst3 $out/lib/vst3
    cp ChowKick_artefacts/Release/Standalone/${pname}  $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/Chowdhury-DSP/ChowKick";
    description = "Kick synthesizer based on old-school drum machine circuits";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ magnetophon ];
    platforms = with platforms; all;
  };
}
