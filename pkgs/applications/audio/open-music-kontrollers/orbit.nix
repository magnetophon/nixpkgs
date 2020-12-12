{ callPackage, zlib, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "orbit";
  version = "unstable-2020-10-12";

  url = "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-0bfb00b00823454f28e9156a29cbe0fc11578c5b.tar.xz";
  sha256 = "0p2wr3yh4bffbr0inzzdw7sqdcvzid6n3lcwmwhpz6a8vq7hiyz5";

  additionalBuildInputs = [ zlib ];

  description = "An LV2 time event manipulation plugin bundle";
})
