{
  alsa-lib,
  cmake,
  curl,
  expat,
  libepoxy,
  fetchFromGitHub,
  fetchurl,
  freetype,
  fontconfig,
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
let
  
  # Required version, base URL and expected location specified in cmake/CPM.cmake
  cpmDownloadVersion = "0.40.2";
  cpmSrc = fetchurl {
    url = "https://github.com/cpm-cmake/CPM.cmake/releases/download/v${cpmDownloadVersion}/CPM.cmake";
    hash = "sha256-yM3DLAOBZTjOInge1ylk3IZLKjSjENO3EEgSpcotg10=";
  };
  # cpmSourceCache = runCommand "cpm-source-cache" { } ''
  # mkdir -p $out/cpm
  # ln -s ${cpmSrc} $out/cpm/CPM_${cpmDownloadVersion}.cmake
  # '';
in

stdenv.mkDerivation (finalAttrs: {
  pname = "resonarium";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "gabrielsoule";
    repo = "resonarium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/ezkq1er/OteoLrqXe60/QmC5BOqoRcoGvtr93wBioE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];
  buildInputs = [
    alsa-lib
    curl
    expat
    libepoxy
    freetype
    fontconfig
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
    # We are in the source directory when this runs; create the expected directory and symlink.
    mkdir -p modules/melatonin_perfetto/cmake
    # ln -s ${cpmSrc} modules/melatonin_perfetto/cmake/CPM.cmake

    # Some modules (or CMake expects a versioned filename). Add that as well just in case:
    # ln -s ${cpmSrc} modules/melatonin_perfetto/cmake/CPM_${cpmDownloadVersion}.cmake || true
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
    homepage = "https://github.com/gabrielsoule/resonarium";
    description = "Expressive, semi-modular, and comprehensive physical modeling/waveguide synthesizer";
    license = [ lib.licenses.gpl3Plus ];
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "resonarium";
  };
})
