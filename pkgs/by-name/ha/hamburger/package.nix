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
    # Remove all FetchContent declarations and calls
    sed -i '/FetchContent_Declare/,/^)/d' CMakeLists.txt
    sed -i '/FetchContent_MakeAvailable/d' CMakeLists.txt
    
    # Add JUCE as a subdirectory (assuming juce package provides source)
    sed -i '/^project(/a add_subdirectory(${juce.src} juce-build EXCLUDE_FROM_ALL)' CMakeLists.txt
  '';

  meta = {
    homepage = "https://aviaryaudio.com/plugins/hamburgerv2";
    description = "Distortion plugin with inbuilt dynamics controls and equalisation";
    license = [ lib.licenses.agpl3Only ];
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = lib.platforms.all;
    mainProgram = "Hamburger";
  };
})
