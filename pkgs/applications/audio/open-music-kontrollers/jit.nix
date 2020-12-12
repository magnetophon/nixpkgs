{ callPackage, lv2, fontconfig, libvterm-neovim, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "jit";
  version = "unstable-2020-10-12";

  url = "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-0f3c5dc64af4f730816097b3246ea93af1f93b49.tar.xz";
  sha256 = "0xymw6cmcndny20ryg579zgwrwsqkslnv456wcyv7k39zkf5vvxv";

  additionalBuildInputs = [ lv2 fontconfig libvterm-neovim ];

  description = "A Just-in-Time C/Rust compiler embedded in an LV2 plugin";
  broken = true;
})
