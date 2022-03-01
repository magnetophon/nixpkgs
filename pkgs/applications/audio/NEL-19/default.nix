{ lib, stdenv, fetchFromGitHub, libGL, libX11, libXext, libXrandr, libXinerama, libXcursor, freetype, alsa-lib, cmake, pkg-config, gcc-unwrapped }:
let
  juce = rec {
    version = "6.1.5";
    src = fetchFromGitHub {
      owner = "juce-framework";
      repo = "JUCE";
      rev = version;
      sha256 = "sha256-Rz0QXi2mK2lpUJ/F6d89GG8JBcTfyDMhQPGyWR0PSEI=";
    };
  };
in

stdenv.mkDerivation rec {
  pname = "NEL-19";
  version = "unstable-27-02-2022";

  src = fetchFromGitHub {
    owner = "Mrugalla";
    repo = pname;
    rev = "74e3fa1c414b5a683bf3f54fb04c0e8c72da4cae";
    sha256 = "sha256-034LEu3teXnaoKCp8gfqmHcu1kXuFRTle7OY9bIttZ0=";
    # fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libGL libX11 libXext libXrandr libXinerama libXcursor freetype alsa-lib
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
  prePatch = ''
    rm -rf CMakeFiles
    cp -R --no-preserve=mode,ownership ${juce.src} JUCE
    sed -i 's@add_subdirectory ("G:/PluginDevelopment/JUCE" "JUCE")@add_subdirectory(JUCE)@' CMakeLists.txt
'';

  installPhase = ''
  mkdir -p $out/lib/vst3 $out/bin
  cd NEL_artefacts/Release
  cp -r VST3/NEL.vst3 $out/lib/vst3
  cp -r Standalone/NEL $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/Mrugalla/NEL-19";
    description = "A visual, musical editor for delay effects";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
