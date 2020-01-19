{ stdenv, fetchFromGitHub , cmake, libjack2, libsndfile }:

stdenv.mkDerivation rec {
  pname = "sfizz";
  version = "unstable-2020-01-19";

  src = fetchFromGitHub {
    owner = "sfztools";
    repo = pname;
    rev = "53b702d07e2009437ce705dc1df5954d1b8a4ea4";
    sha256 = "0bfg39m5g5hjhp611zjcp0bvzm1k2zqvw3qqk8nq6j3yb32i4gq9";
    fetchSubmodules = true;
  };

  buildInputs = [ cmake libjack2 libsndfile ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DSFIZZ_TESTS=ON"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/sfztools/sfizz;
    description = "SFZ jack client and LV2 plugin";
    license = licenses.bsd2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.all;
  };
}
