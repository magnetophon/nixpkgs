{
  alsa-lib,
  cmake,
  curl,
  libepoxy,
  fetchFromGitHub,
  freetype,
  juce,
  lib,
  libGL,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,
  libjack2,
  libxkbcommon,
  lv2,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hamburger";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "Davit-G";
    repo = "Hamburger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U/xy+uYTtDnBEHuZmVQkjTxy191oyLRs+ofnE/sHMPA=";
    fetchSubmodules = true;
  };

  clap-juce-extensions = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap-juce-extensions";
    rev = "4d454e5125da75a0e75d95615cbec26d2a09e2bf";  # You'll need to find the specific commit they use
    hash = "sha256-kn1377T4uDrZsu5k4uMqDAY10Ep+J3c1BQpcu+LD4wM=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    alsa-lib
    curl
    libepoxy
    freetype
    juce
    libGL
    libXcursor
    libXext
    libXinerama
    libXrandr
    libjack2
    libxkbcommon
    lv2
  ];

  postPatch = ''
    # Remove FetchContent_Declare block and replace FetchContent_MakeAvailable with find_package
    sed -i '/FetchContent_Declare(/,/^)/d' CMakeLists.txt
    substituteInPlace CMakeLists.txt \
        
    # Remove FetchContent for clap-juce-extensions and use local copy
    sed -i '/FetchContent_Declare (clap-juce-extensions/,/^FetchContent_MakeAvailable/d' CMakeLists.txt
    substituteInPlace CMakeLists.txt \
      --replace-fail 'FetchContent_MakeAvailable (clap-juce-extensions)' 'add_subdirectory(''${CMAKE_CURRENT_SOURCE_DIR}/clap-juce-extensions)'
    
    # Copy clap-juce-extensions into the source tree
    cp -r ${finalAttrs.clap-juce-extensions} clap-juce-extensions
    chmod -R u+w clap-juce-extensions
  '';

  # cmakeFlags = [
  # "-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
  # "-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
  # ];

  # postPatch = ''
  # substituteInPlace modules/chowdsp_wdf/CMakeLists.txt --replace-fail \
  # 'cmake_minimum_required(VERSION 3.1)' \
  # 'cmake_minimum_required(VERSION 4.0)'
  # '';

  # installPhase = ''
  # mkdir -p $out/lib/lv2 $out/lib/vst3 $out/bin
  # cp -r ChowKick_artefacts/Release/LV2/ChowKick.lv2 $out/lib/lv2
  # cp -r ChowKick_artefacts/Release/VST3/ChowKick.vst3 $out/lib/vst3
  # cp ChowKick_artefacts/Release/Standalone/ChowKick  $out/bin
  # '';

  meta = {
    homepage = "https://aviaryaudio.com/plugins/hamburgerv2";
    description = "Distortion plugin with inbuilt dynamics controls and equalisation";
    license = [ lib.licenses.agpl3Only ];
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.all;
    mainProgram = "Hamburger";
  };
})
