{ stdenv, fetchFromGitHub, boost, gtkmm3, lv2, pkgconfig, python, wafHook }:

stdenv.mkDerivation rec {
  pname = "lvtk-cyclopsian-unstable";
  version = "2019-02-13";

  src = fetchFromGitHub {
    owner = "cyclopsian";
    repo = pname;
    rev = "558a163e21e86b6ada1118baef799929b16def0d";
    sha256 = "05pjr1nmw3vq4z40pfc3ing8dj8bfbza64l8ycv3y6imwwpzbiv6";
  };

  nativeBuildInputs = [ pkgconfig python wafHook ];
  buildInputs = [ boost gtkmm3 lv2 ];

  enableParallelBuilding = true;

  # Fix including the boost libraries during linking
  postPatch = ''
  # sed -i '/target[ ]*= "ttl2c"/ ilib=["boost_system"],' tools/wscript_build
ls tools
  '';

  wafConfigureFlags = [
    # "--boost-includes=${boost.dev}/include"
    # "--boost-libs=${boost.out}/lib"
  ];

  meta = with stdenv.lib; {
    description = "an updated version of lvtk that supports GTK3";
    homepage = https://github.com/cyclopsian/lvtk;
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
