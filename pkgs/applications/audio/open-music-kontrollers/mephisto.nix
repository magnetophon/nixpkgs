{ callPackage, faust, fontconfig, cmake, libvterm-neovim, libevdev, libglvnd, fira-code, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "mephisto";
  version = "0.12.0";

  sha256 = "1k9l6n4r45qrigkwqr06jzq42w3dz7j20vhs5pbl6v1nahc8jayz";

  additionalBuildInputs = [ faust fontconfig cmake libvterm-neovim libevdev libglvnd fira-code ];

  description = "A Just-in-time FAUST embedded in an LV2 plugin";
  broken = true;
})
