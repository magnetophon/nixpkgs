{ callPackage, fetchurl, libjack2, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "patchmatrix";
  version = "0.20.0";

  src = fetchurl {
    url = "https://git.open-music-kontrollers.ch/lad/${pname}/snapshot/${pname}-${version}.tar.xz";
    sha256 = "166dmdd3cpwlnf2i0l1f884i8y07xbq83120rmxbi84pvfp9ls04";
  };

  additionalBuildInputs = [ libjack2 ];

  description = "A JACK patchbay in flow matrix style";
})
