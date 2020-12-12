{ callPackage, sratom, flex, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "sherlock";
  version = "0.24.0";

  sha256 = "08gjfx7vrsx9zvj04j8cr3vscxmq6jr2hbdi6dfgp1l1dnnpxsgq";

  additionalBuildInputs = [ sratom flex ];

  description = "Plugins for visualizing LV2 atom, MIDI and OSC events";
})
