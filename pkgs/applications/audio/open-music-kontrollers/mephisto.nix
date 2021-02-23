{ callPackage, faust, fontconfig, cmake, libvterm-neovim, libevdev, libglvnd, fira, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "mephisto";
  version = "0.14.0";
  sha256 = "1wcn31016dj6q90zk3wjv1x4v3gbrj7ywz14yw4f194505y9hkp1";


  additionalBuildInputs = [ faust fontconfig cmake libvterm-neovim libevdev libglvnd fira ];

  description = "A Just-in-time FAUST embedded in an LV2 plugin";
  broken = true;
})
