{
  alsa-lib,
  clangStdenv,
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
  ninja,
  pkg-config,
  writableTmpDirAsHomeHook,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "zlsplitter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ZL-Audio";
    repo = "ZLSplitter";
    tag = "${finalAttrs.version}";
    hash = "sha256-8a/t1yJG5CUr4udnKIy80exQejDy0HzOi7uMjelPldg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    alsa-lib
    curl
    expat
    fontconfig
    freetype
    libGL
    libXcursor
    libXext
    libXinerama
    libXrandr
    libepoxy
    libjack2
    libxkbcommon
    lv2
  ];

  # LTO needs special setup on Linux
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'juce::juce_recommended_lto_flags' '# Not forcing LTO'
  '';

  cmakeFlags = [
    (lib.cmakeFeature "KFR_ARCHS" (if clangStdenv.isAarch64 then "neon64" else "sse2;avx;avx2"))
    (lib.cmakeFeature "ZL_JUCE_COPY_PLUGIN" "FALSE")
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/{lv2,vst3}
    mkdir -p $out/bin/

    cp -r "ZLSplitter_artefacts/Release/LV2/ZL Splitter.lv2" $out/lib/lv2/
    cp -r "ZLSplitter_artefacts/Release/VST3/ZL Splitter.vst3" $out/lib/vst3/
    install -Dm755 "ZLSplitter_artefacts/Release/Standalone/ZL Splitter" $out/bin/

    runHook postInstall
  '';

  meta = {
    homepage = "https://zl-audio.github.io/plugins/zlsplitter/";
    description = "versatile splitter plugin for VST3, LV2 and standalone";
    license = [ lib.licenses.agpl3Plus ];
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})
