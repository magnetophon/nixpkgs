{ callPackage, fetchurl, cairo, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "moony";
  version = "0.34.0";

  src = fetchurl {
    url = "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-${version}.tar.xz";
    sha256 = "17nnmkphdmx3g0zkkxmqjbq63dw32dm6zmmbpyx55m8gsng9nv4x";
  };

  additionalBuildInputs = [ cairo];

  description = "Realtime Lua as programmable glue in LV2";

})
