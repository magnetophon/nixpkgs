{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, alsa-lib
, freetype
, libjack2
, lv2
, libX11
, libXcursor
, libXext
, libXinerama
, libXrandr
}:

stdenv.mkDerivation rec {
  pname = "monique-monosynth";
  version = "unstable-2021-12-24";
  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "monique-monosynth";
    rev = "8b38ba2159ef6cc789f1e4225395a8d4bb2d2e9f";
    sha256 = "sha256-ba3CqRdn2qxAJBODj5mkF5iP3/jRv7EMVxw/cVWcSq4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    freetype
    libjack2
    lv2
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
  ];

  # JUCE dlopen's these at runtime, crashes without them
  NIX_LDFLAGS = (toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
    "-ljack -L${libjack2}"
  ]);

  patchPhase = ''
    substituteInPlace CMakeLists.txt \
      --replace "juce::juce_recommended_config_flags" "" \
      --replace "juce::juce_recommended_lto_flags" "" \
      --replace "# cmake options" "add_compile_options(
        -fvisibility=hidden
        -fvisibility-inlines-hidden
       )"
  '';

  preConfigure = ''
    cmakeFlagsArray+=(-DCMAKE_EXE_LINKER_FLAGS="-no-pie")
  '' ;

  installPhase = ''
    mkdir -p $out/lib/vst3 $out/bin
    cp -r MoniqueMonosynth_artefacts/Release/VST3/MoniqueMonosynth.vst3 $out/lib/vst3
    cp -r MoniqueMonosynth_artefacts/Release/Standalone/MoniqueMonosynth $out/bin/
  '';

  meta = {
    description = "A monophonic synth plugin";
    homepage = "https://github.com/surge-synthesizer//monique";

    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
