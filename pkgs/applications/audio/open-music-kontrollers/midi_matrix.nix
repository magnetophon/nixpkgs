{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "midi_matrix";
  version = "0.26.0";

  src = fetchurl {
    url = "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-${version}.tar.xz";
    sha256 = "16fr31g0xmnl2n6k7j82f984iggb0rszyr0ip6r0zsiqrdhial36";
  };

  description = "An LV2 MIDI channel matrix patcher";
})
