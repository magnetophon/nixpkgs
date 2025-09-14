{
  lib,
  stdenv,
  alsa-lib,
  fetchFromGitHub,
  fftwFloat,
  freetype,
  libGL,
  libX11,
  libXcursor,
  libXext,
  libXrender,
  meson,
  ninja,
  pkg-config,

  # empty means build all available plugins
  plugins ? [ ],
}:

let
  rpathLibs = [
    fftwFloat
  ];
in
stdenv.mkDerivation {
  pname = "distrho-ports";
  version = "unstable-2025-04-24";

  src = fetchFromGitHub {
    owner = "DISTRHO";
    repo = "DISTRHO-Ports";
    rev = "43330739392197cd1b3b0df23b194879ddf68f23";
    hash= "sha256-r/hhk/WmREtUSlWhQeJbWWlefJKX3ji6S25LI8heT6Q=";
    # rev = "43330739392197cd1b3b0df23b194879ddf68f23";
    # hash= "sha256-r/hhk/WmREtUSlWhQeJbWWlefJKX3ji6S25LI8heT6Q=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = rpathLibs ++ [
    alsa-lib
    freetype
    libGL
    libX11
    libXcursor
    libXext
    libXrender
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-fpermissive" ];

  postFixup = lib.optionalString (lib.any (x: x == "vitalium") plugins || plugins == [ ]) ''
    for file in \
      $out/lib/lv2/vitalium.lv2/vitalium.so \
      $out/lib/vst/vitalium.so \
      $out/lib/vst3/vitalium.vst3/Contents/x86_64-linux/vitalium.so
    do
      patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}:$(patchelf --print-rpath $file)" $file
    done
  '';

  mesonFlags = lib.optional (plugins != [ ]) (
    lib.mesonOption "plugins" "[${lib.concatMapStringsSep "," (x: "\"${x}\"") plugins}]"
  );

  meta = {
    homepage = "http://distrho.sourceforge.net/ports";
    description = "Linux audio plugins and LV2 ports";
    longDescription = ''
      You can override this package to only include some plugins like so:

      ```nix
      distrho-ports.override {
        plugins = [ "vitalium" "swankyamp" ];
      }
      ```

      Available plugins:
      - arctican-function
      - arctican-pilgrim
      - dexed
      - drowaudio-distortion
      - drowaudio-distortionshaper
      - drowaudio-flanger
      - drowaudio-reverb
      - drowaudio-tremolo
      - drumsynth
      - easySSP
      - eqinox
      - HiReSam
      - juce-opl
      - klangfalter
      - LUFSMeter
      - LUFSMeter-Multi
      - luftikus
      - obxd
      - pitchedDelay
      - refine
      - stereosourceseparation
      - swankyamp
      - tal-dub-3
      - tal-filter
      - tal-filter-2
      - tal-noisemaker
      - tal-reverb
      - tal-reverb-2
      - tal-reverb-3
      - tal-vocoder-2
      - temper
      - vex
      - vitalium
      - wolpertinger
    '';
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
      gpl2Plus
      lgpl2Plus
      lgpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [ bandithedoge ];
    platforms = lib.systems.inspect.patternLogicalAnd lib.systems.inspect.patterns.isLinux lib.systems.inspect.patterns.isx86;
  };
}
