# validate-plugin.nix
#
# A passthru.tests builder for audio plugins. callPackage it once:
#
#   validatePlugin = pkgs.callPackage ./validate-plugin.nix { };
#
# then in each plugin's package.nix:
#
#   passthru.tests = validatePlugin {
#     plugin = finalAttrs.finalPackage;   # the fully-overridden package
#   };
#
# Formats are auto-detected from the built bundle: each validator runs if its
# format is present ($out/lib/vst3 for pluginval, $out/lib/lv2 for lv2lint /
# plugin-torture) and cleanly skips otherwise. No per-format booleans needed —
# eval-time output inspection would require IFD, which nixpkgs forbids, so the
# detection happens at build time instead.
#
# ofborg only builds a package's passthru.tests when your commits touch that
# package, so this validates exactly the plugin you added/updated — there is no
# "validate everything" job.
{
  lib,
  runCommand,
  lilv, # provides lv2ls, used to enumerate the bundle's URIs
  lv2, # the LV2 spec ontologies; needed on LV2_PATH for lv2lint's spec lookups
  lv2lint,
  plugin-torture,
  pluginval,
  xvfb-run, # only used when guiTests = true
}:

{
  plugin, # built plugin derivation; pass finalAttrs.finalPackage
  strictness ? "normal", # "normal" | "strict" | "pedantic"; scales every validator
  guiTests ? false, # test the UI: pluginval editor tests + lv2lint UI checks.
  # Default false because GL UIs can't instantiate in a GPU-less sandbox. When
  # false, pluginval gets --skip-gui-tests and lv2lint runs with no display, so
  # its X11 UI-instantiation tests self-skip (its X11 path is `if(!DISPLAY) return`).
  lv2lintFlags ? [ ], # extra lv2lint args, e.g. [ "-s" "lv2_generate_ttl" ] to whitelist
  torture ? true, # set false for plugins plugin-torture can't instantiate (e.g. DPF)
  pluginvalTests ? true, # set false to skip pluginval (VST3) — e.g. when it crashes
  # on a plugin and only the lv2lint axis is wanted. No effect on LV2-only plugins.
}:
let
  name = plugin.pname or (lib.getName plugin);

  # Three strictness levels, each translated into every validator's native
  # dialect. The axes are NOT commensurable: pluginval fuzzes processing/state
  # harder (1..10), lv2lint escalates warnings/notes to hard errors, plugin-
  # torture enables more test categories. A level bundles one choice per tool.
  levels = {
    normal = {
      pluginval = [ "--strictness-level" "5" ];
      lv2lint = [ ];
      torture = [ ];
    };
    strict = {
      pluginval = [ "--strictness-level" "8" ];
      lv2lint = [ "-E" "warn" ];
      torture = [ "-e" ]; # particularly evil tests
    };
    pedantic = {
      pluginval = [ "--strictness-level" "10" ];
      lv2lint = [ "-E" "warn" "-E" "note" ];
      torture = [ "-e" "-d" "-a" ]; # evil tests + trap/abort on denormals
    };
  };
  level =
    levels.${strictness} or (throw
      "validatePlugin: strictness must be one of ${lib.concatStringsSep ", " (lib.attrNames levels)}, got ${toString strictness}"
    );
  pluginvalStrict = level.pluginval;
  lv2lintStrict = level.lv2lint;
  tortureStrict = level.torture;

  # lv2lint's X11 UI tests run only when a display is present: its X11 path opens
  # with `if(!DISPLAY) return;`. So "don't test the UI" (guiTests = false) is best
  # done by running with NO display — lv2lint then skips the WHOLE UI battery
  # (Instantiation, Widget, Hints, Toolkit, Idle/Show/Resize, Symbols, Fork, …).
  # This is lv2lint's designed opt-out. (Whitelisting test names by hand was both
  # incomplete — it named 2 of a dozen — and the reason headless builds failed.)
  # guiTests = true supplies a virtual display via xvfb and lets those tests run.
  lv2lintRunner = lib.optionalString guiTests "xvfb-run -a ";

  # A test is a derivation that builds iff the script exits 0.
  mkTest =
    suffix: nativeBuildInputs: script:
    runCommand "${name}-${suffix}" { inherit nativeBuildInputs; } ''
      ${script}
      touch "$out"
    '';

  # LV2 detection shared by lv2lint and plugin-torture. URI *enumeration* stays
  # scoped to this plugin's bundle, but LV2_PATH (used for *resolution*) also
  # includes the lv2 spec ontologies — lv2lint's "Plugin LV2_PATH" check looks up
  # spec classes (ui:X11UI, core:InstrumentPlugin) and FAILs if they're absent.
  # Skips (falls through to mkTest's trailing `touch $out`) when no LV2 present.
  lv2Setup = ''
    plugin_lv2="${plugin}/lib/lv2"
    have_lv2=0
    if [ -d "$plugin_lv2" ]; then
      mapfile -t uris < <(LV2_PATH="$plugin_lv2" lv2ls)
      if [ "''${#uris[@]}" -gt 0 ]; then
        have_lv2=1
      else
        echo "LV2 bundle present but lv2ls found no URIs — skipping"
      fi
    else
      echo "no LV2 under $plugin_lv2 — skipping"
    fi
    export LV2_PATH="$plugin_lv2:${lv2}/lib/lv2"
  '';

  lv2Tests =
    {
      # lv2lint takes plugin URIs (resolved via LV2_PATH). With guiTests = false
      # we run with DISPLAY unset so lv2lint skips its compiled-in X11 UI tests
      # (see lv2lintRunner); with guiTests = true it runs under xvfb. lv2lintFlags
      # passes extra args, e.g. [ "-s" "lv2_generate_ttl" ] to whitelist a symbol.
      lv2lint = mkTest "lv2lint" ([ lilv lv2lint ] ++ lib.optional guiTests xvfb-run) ''
        ${lib.optionalString (!guiTests) "unset DISPLAY"}
        ${lv2Setup}
        if [ "$have_lv2" = 1 ]; then
          for uri in "''${uris[@]}"; do
            echo "== lv2lint $uri =="
            ${lv2lintRunner}lv2lint ${lib.escapeShellArgs (lv2lintStrict ++ lv2lintFlags)} "$uri"
          done
        fi
      '';
    }
    # plugin-torture takes the data .ttl path (-l for LV2, -p for the file), on
    # LV2_PATH. It predates the LV2 Options feature and doesn't advertise it, so
    # plugins that require Options (all DPF plugins) abort on instantiate; set
    # torture = false for those. The durable fix is upstream in plugin-torture.
    // lib.optionalAttrs torture {
      plugin-torture = mkTest "torture" [ lilv plugin-torture ] ''
        ${lv2Setup}
        if [ "$have_lv2" = 1 ]; then
          shopt -s nullglob
          for ttl in "${plugin}"/lib/lv2/*.lv2/*.ttl; do
            [ "$(basename "$ttl")" = manifest.ttl ] && continue
            echo "== plugin-torture $ttl =="
            plugin-torture ${lib.escapeShellArgs tortureStrict} -l -p "$ttl"
          done
        fi
      '';
    };

  # The build sandbox has no X display, so pluginval's editor/GUI test
  # segfaults unless we either skip it or supply a virtual display.
  vstTests =
    let
      runner = lib.optionalString guiTests "xvfb-run -a ";
      guiFlag = lib.optionalString (!guiTests) "--skip-gui-tests ";
    in
    {
      pluginval = mkTest "pluginval" ([ pluginval ] ++ lib.optional guiTests xvfb-run) ''
        shopt -s nullglob
        found=0
        for f in "${plugin}"/lib/vst3/*.vst3; do
          found=1
          echo "== pluginval $f =="
          ${runner}pluginval ${lib.escapeShellArgs pluginvalStrict} \
            ${guiFlag}--validate-in-process "$f"
        done
        [ "$found" = 1 ] || echo "no VST3 under ${plugin}/lib/vst3 — skipping"
      '';
    };
in
lv2Tests // lib.optionalAttrs pluginvalTests vstTests
