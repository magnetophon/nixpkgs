{ stdenv, fetchurl, pkgconfig, python3, wafHook }:

stdenv.mkDerivation rec {
  pname = "serd";
  version = "0.30.8";

  src = fetchurl {
    url = "https://download.drobilla.net/${pname}-${version}.tar.bz2";
    sha256 = "11zs53yx40mv62vxsl15mvdh7s17y5v6lgcgahdvzxgnan7w8bk7";
  };

  nativeBuildInputs = [ pkgconfig python3 wafHook ];

  meta = with stdenv.lib; {
    homepage = "http://drobilla.net/software/serd";
    description = "A lightweight C library for RDF syntax which supports reading and writing Turtle and NTriples";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
