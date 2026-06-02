{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  xorgproto,
  cairo,
  lv2,
  pkg-config,
  validatePlugin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "GxPlugins.lv2";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "GxPlugins.lv2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NvmFoOAQtAnKrZgzG1Shy1HuJEWgjJloQEx6jw59hag=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    xorgproto
    cairo
    lv2
  ];

  installFlags = [ "INSTALL_DIR=$(out)/lib/lv2" ];

  configurePhase = ''
    runHook preConfigure

    for i in GxBoobTube GxValveCaster; do
      substituteInPlace $i.lv2/Makefile --replace "\$(shell which echo) -e" "echo -e"
    done

    runHook postConfigure
  '';

  passthru.tests = validatePlugin {
    plugin = finalAttrs.finalPackage;
    # Each plugin in this bundle ships its own UI binary statically linked
    # against guitarix's GUI helpers + cairo + libpng, so a lot of unrelated
    # symbols end up exposed. Each pattern below whitelists one such family.
    lv2lintFlags = [
      # C++ symbols (Itanium ABI name mangling: _ZN..., _ZSt..., etc.)
      "-s"
      "_Z*"
      # Resources embedded by `ld -r -b binary` / `objcopy -O binary` (PNGs,
      # shaders): produces _binary_<name>_start / _end / _size symbols.
      "-s"
      "_binary_*"
      # cairo graphics library re-exports from the bundled-in cairo bits.
      "-s"
      "cairo_*"
      # guitarix's shared GUI helper layer (knobs, switches, drawing helpers).
      "-s"
      "gx_gui_*"
      # Per-widget X11/Pugl event-callback exports (foo_event, bar_event, …).
      "-s"
      "*_event"
      # X11/cairo expose-event handlers (controller_expose, widget_expose, …).
      "-s"
      "*_expose"
      "-s"
      "_expose"
      # Top-level event-dispatch entry point in several gxplugin UIs.
      "-s"
      "event_handler"
      # libpng re-exports (UIs load PNG resources directly).
      "-s"
      "png_*"
      # Generic getters/setters exported from various gxplugin UIs
      # (get_active_ctl_num, set_key_value, set_*_controller_active, …).
      "-s"
      "get_*"
      "-s"
      "set_*"
      # Globals named `aligned` in some UI plugins (e.g. gx_bottlerocket_gui).
      "-s"
      "aligned"
    ];
  };

  meta = {
    homepage = "https://github.com/brummer10/GxPlugins.lv2";
    description = "Set of extra lv2 plugins from the guitarix project";
    maintainers = [ lib.maintainers.magnetophon ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
