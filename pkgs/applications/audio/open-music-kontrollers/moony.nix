{ callPackage, cairo, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "moony";
  version = "0.34.0";

  sha256 = "17nnmkphdmx3g0zkkxmqjbq63dw32dm6zmmbpyx55m8gsng9nv4x";

  additionalBuildInputs = [ cairo ];

  description = "Realtime Lua as programmable glue in LV2";

})
