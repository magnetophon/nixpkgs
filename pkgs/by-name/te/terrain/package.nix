{
  alsa-lib,
  cmake,
  curl,
  expat,
  fetchFromGitHub,
  fontconfig,
  freetype,
  lib,
  libGL,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,
  libepoxy,
  libjack2,
  libxkbcommon,
  lv2,
  pkg-config,
  stdenv,
  gtk3,
  webkitgtk_4_1,
  libX11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "terrain";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "aaronaanderson";
    repo = "Terrain";
    tag = "${finalAttrs.version}";
    hash = "sha256-1KlM2zTWSWpFqS/bZyW10OZgPkKiRu8UbX8pZ9Eyx7U=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    alsa-lib curl expat fontconfig freetype
    libGL libXcursor libXext libXinerama libXrandr
    libepoxy libjack2 libxkbcommon lv2
    gtk3 webkitgtk_4_1 libX11
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DJUCE_BUILD_EXAMPLES=OFF"
    "-DJUCE_BUILD_SHARED_LIBS=OFF"
    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
    "-DCMAKE_CXX_STANDARD=17"
  ];

  # Disable "warnings as errors" that break build in Nix
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "COMPILE_WARNING_AS_ERROR ON" "COMPILE_WARNING_AS_ERROR OFF"

    # Explicitly add JUCE modules to fix undefined reference errors
    echo '
juce_add_module(juce_audio_basics)
juce_add_module(juce_audio_utils)
juce_add_module(juce_dsp)
juce_add_module(juce_opengl)
juce_add_module(juce_gui_basics)
juce_add_module(juce_gui_extra)

target_link_libraries(WaveTerrainSynth
    PRIVATE
        juce_audio_basics
        juce_audio_utils
        juce_dsp
        juce_opengl
        juce_gui_basics
        juce_gui_extra
)
' >> CMakeLists.txt
  '';

  meta = {
    homepage = "https://github.com/aaronaanderson/Terrain";
    description = "Wave Terrain Synthesis instrument plugin";
    license = [ lib.licenses.gpl3Plus ];
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "Terrain";
  };
})
