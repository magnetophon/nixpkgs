{
  alsa-lib,
  cmake,
  curl,
  expat,
  fontconfig,
  libepoxy,
  fetchFromGitHub,
  freetype,
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
  };

  juce-src = fetchFromGitHub {
    owner = "juce-framework";
    repo = "JUCE";
    rev = "8.0.4";
    hash = "sha256-iAueT+yHwUUHOzqfK5zXEZQ0GgOKJ9q9TyRrVfWdewc="; # Run to get hash
  };

  clap-juce-extensions-src = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap-juce-extensions";
    rev = "4d454e5125da75a0e75d95615cbec26d2a09e2bf";
    hash = "sha256-+i4w6NOImWkxNIOEKFN5houclbOmtgH6FNvGz+LHw9M="; # Run to get hash
    fetchSubmodules = true; # This one likely has submodules
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    alsa-lib
    curl
    expat
    fontconfig
    libepoxy
    freetype
    libGL
    libXcursor
    libXext
    libXinerama
    libXrandr
    libjack2
    libxkbcommon
    lv2
  ];


  postUnpack = ''
    mkdir -p source/modules
    cp -r ${finalAttrs.juce-src} source/modules/JUCE
    cp -r ${finalAttrs.clap-juce-extensions-src} source/modules/clap-juce-extensions
    chmod -R u+w source/modules
  '';

  postPatch = ''
    # Remove all FetchContent lines
    sed -i '/FetchContent_Declare/,/^)/d' CMakeLists.txt
    sed -i '/FetchContent_MakeAvailable/d' CMakeLists.txt
    
    # Add subdirectories after the project() declaration
    sed -i '/^project(/a \
    add_subdirectory(modules/JUCE)\
    add_subdirectory(modules/clap-juce-extensions)' CMakeLists.txt
    
    # Add proper include path configuration
    cat <<EOF >> CMakeLists.txt
    target_include_directories(Hamburger PUBLIC 
      \$\{CMAKE_CURRENT_SOURCE_DIR}/modules/JUCE
      \$\{CMAKE_CURRENT_SOURCE_DIR}/modules/clap-juce-extensions
      \$\{CMAKE_CURRENT_SOURCE_DIR}/dsp
    )
    EOF
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
