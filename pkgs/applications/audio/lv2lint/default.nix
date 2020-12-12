{ stdenv, fetchurl, pkg-config, meson, ninja, lv2, lilv, curl, libelf }:

stdenv.mkDerivation rec {
  pname = "lv2lint";
  version = "0.8.0";

  src = fetchurl {
    url = "https://git.open-music-kontrollers.ch/lv2/${pname}/snapshot/${pname}-${version}.tar.xz";
    sha256 = "0h8ay8vr29kixjk3dmghqxrs1mmh2kvyhvs3fddyhrk02lp50piz";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ lv2 lilv curl libelf ];

  meta = with stdenv.lib; {
    homepage    = "https://open-music-kontrollers.ch/lv2/${pname}:";
    license     = licenses.artistic2;
    maintainers = [ maintainers.magnetophon ];
    platforms = with platforms; all;
  };
}
