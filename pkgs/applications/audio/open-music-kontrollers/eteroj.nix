{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "eteroj";
  version = "0.6.0";

  sha256 = "0p8sdb3jb6rh2vanxpwr8hgmaqz90ambr3l5shfb5vp02q9d2lgm";

  description = "OSC injection/ejection from/to UDP/TCP/Serial for LV2";
})
