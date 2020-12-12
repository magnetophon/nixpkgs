{ callPackage, fetchurl, lilv, libjack2, alsaLib, zita-alsa-pcmi, libxcb, xcbutilxrm, sratom, gtk2, gtk3, qt4, qt5, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "synthpod";
  version = "unstable-2020-12-04";

  src = fetchurl {
    url = "https://git.open-music-kontrollers.ch/lv2/synthpod/snapshot/synthpod-cb0d700d2911cdebf3f555ce88dcd18f850d8bb6.tar.xz";
    sha256 = "1rpdbydwlxd2hapny0cqx90iszjxk778jjgp1wccz19jd4chkikm";
  };

  additionalBuildInputs = [ lilv libjack2 alsaLib zita-alsa-pcmi libxcb xcbutilxrm sratom gtk2 gtk3 qt4 qt5.qtbase ];

  # postPatch = ''
  # substituteInPlace app/synthpod_app_private.h --replace "sratom/sratom.h" "/nix/store/zr9v1sm6z77q83hgdw4jbi28vhyqsfhp-sratom-0.6.4/include/sratom-0/sratom/sratom.h"
  # substituteInPlace app/synthpod_app_private.h --replace "serd/serd.h" "/nix/store/86s9335g2mfgkx0wba59wx0g0l83l3cp-serd-0.30.4/include/serd-0/serd"
  # '';

  description = "Lightweight Nonlinear LV2 Plugin Container";
})
