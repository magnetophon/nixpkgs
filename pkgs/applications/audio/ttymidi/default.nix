{ stdenv, fetchurl, alsaLib, glibc, libpthreadstubs }:

stdenv.mkDerivation rec {
  pname = "ttymidi";
  version = "unstable";

  src = fetchurl {
    url = "http://www.varal.org/ttymidi/ttymidi.tar.gz";
    sha256 = "0xl48pl2bhqizf9ihikarzv8jbmm4k991mrxiq1wvkj3s774z1lp";
  };

  # nativeBuildInputs = [ pkgconfig wafHook python3 ];
  buildInputs = [ alsaLib glibc libpthreadstubs ];

  meta = with stdenv.lib; {
    # homepage = "http://drobilla.net/software/sratom";
    # description = "A library for serialising LV2 atoms to/from RDF";
    # license = licenses.mit;
    # maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
