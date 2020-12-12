{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "router";
  version = "unstable-2020-10-12";

  url = "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-f24208da1e202010fb56224b14a2af101b5e70a2.tar.xz";
  sha256 = "1h976dwvyly1x2ia22yzx5fzdfi9yhi0075ha6d5mjzxdlsbc4ip";

  description = "An atom/audio/CV router LV2 plugin bundle";
})
