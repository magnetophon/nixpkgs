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
  pname = "zlcompressor";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ZL-Audio";
    repo = "ZLCompressor";
    tag = "${finalAttrs.version}";
    hash = "sha256-0Z29+jLtAtThFaVVqvuqUJkj1VRI69WOvIbEfE45db4=";
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

    cp -r "ZLCompressor_artefacts/Release/LV2/ZL Compressor.lv2" $out/lib/lv2/
    cp -r "ZLCompressor_artefacts/Release/VST3/ZL Compressor.vst3" $out/lib/vst3/
    install -Dm755 "ZLCompressor_artefacts/Release/Standalone/ZL Compressor" $out/bin/

    runHook postInstall
  '';

  meta = {
    homepage = "https://zl-audio.github.io/plugins/zlcompressor/";
    description = "versatile compressor plugin for VST3, LV2 and standalone";
    license = [ lib.licenses.agpl3Plus ];
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})
