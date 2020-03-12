{ stdenv, fetchFromGitLab, cmake, cairo }:

stdenv.mkDerivation rec {
  pname = "redkite";
  version = "0.6.3";

  src = fetchFromGitLab {
    owner = "geontime";
    repo = pname;
    rev = "v${version}";
    sha256 = "1azzwcwghyb5i689g9cz9402vfcpk1n2h1w70fap6nqd31pwdax4";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cairo ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://gitlab.com/geontime/redkite";
    description = "A small GUI toolkit";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
