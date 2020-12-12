{ callPackage, fetchurl, sratom, flex, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "sherlock";
  version = "0.24.0";

  src = fetchurl {
    url = "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-${version}.tar.xz";
    sha256 = "08gjfx7vrsx9zvj04j8cr3vscxmq6jr2hbdi6dfgp1l1dnnpxsgq";
  };

  additionalBuildInputs = [ sratom flex ];

  description = "Plugins for visualizing LV2 atom, MIDI and OSC events";
})
