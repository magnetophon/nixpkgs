{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "vm";
  version = "0.10.0";

  src = fetchurl {
    url = "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-${version}.tar.xz";
    sha256 = "0cm42vb0c37w42a9id75h7dzg580fbxj950wdh51n5f8pfdrvka7";
  };

  description = "A programmable virtual machine LV2 plugin";
})
