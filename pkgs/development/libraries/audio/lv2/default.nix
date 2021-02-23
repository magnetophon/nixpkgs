{ stdenv, fetchurl, gtk2, libsndfile, pkgconfig, python3, wafHook }:

stdenv.mkDerivation rec {
  pname = "lv2";
  version = "1.18.2";

  src = fetchurl {
    url = "https://lv2plug.in/spec/${pname}-${version}.tar.bz2";
    sha256 = "0pp0n9x1rg8d4fw853z9cvfifjdi4bl85yjxxddqa1acfjy1z2af";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ gtk2 libsndfile python3 ];

  wafConfigureFlags = stdenv.lib.optionals stdenv.isDarwin [ "--lv2dir=${placeholder "out"}/lib/lv2" ];

  meta = with stdenv.lib; {
    homepage = "https://lv2plug.in";
    description = "A plugin standard for audio systems";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.unix;
  };
}
