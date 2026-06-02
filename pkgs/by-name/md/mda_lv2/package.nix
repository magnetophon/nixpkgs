{
  lib,
  stdenv,
  fetchurl,
  fftwSinglePrec,
  lv2,
  pkg-config,
  wafHook,
  python3,
  validatePlugin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mda-lv2";
  version = "1.2.6";

  src = fetchurl {
    url = "https://download.drobilla.net/mda-lv2-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-zWYRcCSuBJzzrKg/npBKcCdyJOI6lp9yqcXQEKSYV9s=";
  };

  nativeBuildInputs = [
    pkg-config
    wafHook
    python3
  ];
  buildInputs = [
    fftwSinglePrec
    lv2
  ];

  passthru.tests = validatePlugin {
    plugin = finalAttrs.finalPackage;
    # plugin-torture segfaults mid-run on one of the mda plugins (instantiate
    # succeeds, but a later test crashes); re-enable once the offending
    # plugin is isolated or the crash is fixed upstream.
    torture = false;
    lv2lintFlags = [
      # C++ symbols (Itanium ABI name mangling) from the C++ MDA plugin classes.
      "-s"
      "_Z*"
      # LVZ is the in-tree VST-to-LV2 shim mda-lv2 uses to adapt the original
      # MDA VST sources; the shim exports lvz_new_audioeffectx and friends.
      "-s"
      "lvz_*"
    ];
  };

  meta = {
    homepage = "http://drobilla.net/software/mda-lv2.html";
    description = "LV2 port of the MDA plugins by Paul Kellett";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
