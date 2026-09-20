{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchgit,
  fetchzip,

  cmake,
  pkg-config,

  alsa-lib,
  curl,
  fontconfig,
  freetype,
  libGL,
  libX11,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,
  libjack2,
  libpulseaudio,
  libxkbcommon,
  mesa,
  wayland,
}:

let
  version = "0.12";

  juce = fetchgit {
    url = "https://github.com/juce-framework/JUCE.git";
    rev = "69795dc";
    hash = "sha256-NRF9oSE04hk6KVSxuUBpP+z+DKRyb6pzBXtz/pLz0/0=";
  };

  foleysGuiMagic = fetchgit {
    url = "https://github.com/ffAudio/foleys_gui_magic.git";
    rev = "795f879";
    hash = "sha256-fClheBQsa+eInIaLL+54x2QKxgV9IxEpysAHn9pv2Ik=";
  };

  libtorch = fetchzip {
    url =
      "https://download.pytorch.org/libtorch/cpu/"
      + "libtorch-cxx11-abi-shared-with-deps-2.0.0%2Bcpu.zip";
    hash = "sha256-BoZQ2MC1CDVVGfX3SHC3mEpLGWO8XK7AcLcHJXDsXuc=";
    stripRoot = true;
  };
in

stdenv.mkDerivation {
  pname = "bessels-trick";
  inherit version;

  src = fetchFromGitHub {
    owner = "fcaspe";
    repo = "BesselsTrick";
    tag = "v${version}";
    hash = "sha256-QbSBYNW+cQaf82wMkYiz8FVItzLT4w617k9nkA1s5r4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    curl
    fontconfig
    freetype
    libGL
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
    libjack2
    libpulseaudio
    libxkbcommon
    mesa
    wayland
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'juce_enable_copy_plugin_step(BesselsTrick)' \
        '# disabled for Nix' \
      --replace-fail \
        'add_subdirectory(''${foleys_gui_magic_SOURCE_DIR}/modules)' \
        'add_subdirectory(''${foleys_gui_magic_SOURCE_DIR}/modules ''${CMAKE_BINARY_DIR}/foleys_gui_magic_modules)'
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_PREFIX_PATH=${libtorch}"
    "-DFETCHCONTENT_SOURCE_DIR_JUCE=${juce}"
    "-DFETCHCONTENT_SOURCE_DIR_FOLEYS_GUI_MAGIC=${foleysGuiMagic}"
    "-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
  ];

  preConfigure = ''
    test -f "${libtorch}/share/cmake/Torch/TorchConfig.cmake"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/vst3"

    plugin="$PWD/BesselsTrick_artefacts/Release/VST3/BesselsTrick.vst3"

    if [ ! -d "$plugin" ]; then
      echo "error: VST3 bundle was not produced"
      find . -type d -name '*.vst3' -print
      exit 1
    fi

    cp -R "$plugin" "$out/lib/vst3/"

    runHook postInstall
  '';

  postFixup = ''
    plugin="$out/lib/vst3/BesselsTrick.vst3/Contents/x86_64-linux/BesselsTrick.so"

    if [ ! -f "$plugin" ]; then
      echo "error: expected plugin binary not found:"
      echo "  $plugin"
      find "$out" -type f -name 'BesselsTrick.so' -print
      exit 1
    fi

    patchelf \
      --add-rpath "${
        lib.makeLibraryPath [
          stdenv.cc.cc
          alsa-lib
          curl
          fontconfig
          freetype
          libGL
          libX11
          libXcursor
          libXext
          libXinerama
          libXrandr
          libjack2
          libpulseaudio
          libxkbcommon
          mesa
          wayland
        ]
      }" \
      "$plugin"
  '';

  meta = {
    description = "Real-time FM tone-transfer VST3 plugin";
    homepage = "https://github.com/fcaspe/BesselsTrick";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ magnetophon ];
    platforms = [ "x86_64-linux" ];
  };
}
