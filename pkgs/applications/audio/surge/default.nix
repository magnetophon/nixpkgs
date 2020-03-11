{ stdenv, fetchgit, premake5, pkgconfig, cmake
,cairo, libxkbcommon, libxcb, xcb-util-cursor, xcbutilkeysyms, ncurses, which, getopt
,python, gnome3, lato }:

stdenv.mkDerivation rec {
  pname = "surge";
  version = "1.6.6";

  src = fetchgit {
    url = "https://github.com/surge-synthesizer/surge";
    rev = "release_${version}";
    sha256 = "16mkapds0vbl83z6ch044gm0kbdvfqg9brbj3bd4a6yifl8kch7g";
    deepClone = true;
    };

  nativeBuildInputs = [ premake5 pkgconfig cmake ];

  buildInputs = [  cairo libxkbcommon libxcb xcb-util-cursor xcbutilkeysyms ncurses which getopt python gnome3.zenity lato ];

  patchPhase = ''
    patchShebangs build-linux.sh
    substituteInPlace src/common/SurgeStorage.cpp --replace "/usr/share/Surge" "$out/share/surge"
    cat src/common/SurgeStorage.cpp
  '';

  buildPhase = ''
      ./build-linux.sh build
    '';

  installPhase = ''
    mkdir -p $out/bin
    cp target/headless/Release/Surge/Surge-Headless $out/bin/
    mkdir -p $out/lib/lv2
    cp -r target/lv2/Release/Surge.lv2/ $out/lib/lv2
    mkdir -p $out/lib/vst
    cp target/vst3/Release/Surge.so $out/lib/vst
    mkdir -p $out/share/surge
    cp -r resources/data/* $out/share/surge/
  '';

  meta = with stdenv.lib; {
    description = "Synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = https://surge-synthesizer.github.io;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ magnetophon ];
  };
}
