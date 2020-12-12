{ callPackage, lilv, libjack2, alsaLib, zita-alsa-pcmi, libxcb, xcbutilxrm, sratom, gtk2, gtk3, qt4, qt5, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "synthpod";
  version = "unstable-2020-12-04";

  url = "https://git.open-music-kontrollers.ch/lv2/synthpod/snapshot/synthpod-333829737728b7883aae72928c4b7d3505075a6e.tar.xz";
  sha256 = "0csa025aix7ii0l7l5pq91r4ds50z3pc4dma399bmqgj6i82q7hs";

  additionalBuildInputs = [ lilv libjack2 alsaLib zita-alsa-pcmi libxcb xcbutilxrm sratom gtk2 gtk3 qt4 qt5.qtbase ];

  description = "Lightweight Nonlinear LV2 Plugin Container";
})
