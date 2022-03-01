{ lib, stdenv, fetchFromGitHub, libGL, libX11, libXext, libXrender, libXrandr, libXinerama, libXcursor, freetype, alsa-lib, libjack2, curl, lv2, python, cmake, pkg-config, gcc-unwrapped }:
let
  readerwriterqueue = rec {
    version = "1.0.6";
    src = fetchFromGitHub {
      owner = "cameron314";
      repo = "readerwriterqueue";
      rev = "v${version}";
      sha256 = "sha256-g7NX7Ucl5GWw3u6TiUOITjhv7492ByTzACtWR0Ph2Jc=";
    };
  };
  Catch2 = rec {
    version = "2.13.7";
    src = fetchFromGitHub {
      owner = "catchorg";
      repo = "Catch2";
      rev = "v${version}";
      sha256 = "sha256-NhZ8Hh7dka7KggEKKZyEbIZahuuTYeCT7cYYSUvkPzI=";
    };
  };

in

stdenv.mkDerivation rec {
  pname = "Fire";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "jerryuhoo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7I7dezN2gR4rF+Qr6ULHsv2wRlJ/tMrzz0Z/jIm8bTg=";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libGL libX11 libXext libXrender libXrandr libXinerama libXcursor freetype alsa-lib libjack2 curl lv2 python
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
    "-DCMAKE_NM=${gcc-unwrapped}/bin/gcc-nm"
  ];

  # JUCE dlopen's these at runtime, crashes without them
  NIX_LDFLAGS = (toString [
    "-lXext"
    "-lX11"
    "-lXcursor"
    "-lXinerama"
    "-lXrender"
    "-lXrandr"
  ]);

  postPatch = ''
      cp -R --no-preserve=mode,ownership ${readerwriterqueue.src} readerwriterqueue
      cp -R --no-preserve=mode,ownership ${Catch2.src} Catch2
      sed -i '176, 181d' CMakeLists.txt
      sed -i '33, 46d' CMakeLists.txt
      sed -i '32 i add_subdirectory(JUCE)' CMakeLists.txt
      sed -i '32 i add_subdirectory(readerwriterqueue)' CMakeLists.txt
      sed -i '32 i add_subdirectory(Catch2)' CMakeLists.txt
      sed -i 's/COPY_PLUGIN_AFTER_BUILD TRUE/COPY_PLUGIN_AFTER_BUILD FALSE/' CMakeLists.txt # attempts to write to /homeless-shelter
      patchShebangs .
  '';

  installPhase = ''
    mkdir -p $out/lib/vst3 $out/bin
    cd Fire_artefacts/Release
    cp -r VST3/Fire.vst3 $out/lib/vst3
  '';

  meta = with lib; {
    homepage = "https://github.com/jerryuhoo/Fire";
    description = "This is a distortion plugin developed by Wings!";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.agpl3;
  };
}
