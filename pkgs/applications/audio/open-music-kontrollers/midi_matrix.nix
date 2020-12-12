{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "midi_matrix";
  version = "0.26.0";

  sha256 = "16fr31g0xmnl2n6k7j82f984iggb0rszyr0ip6r0zsiqrdhial36";

  description = "An LV2 MIDI channel matrix patcher";
})
