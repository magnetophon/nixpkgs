{ stdenv, fetchFromGitLab, cmake, cairo }:

stdenv.mkDerivation rec {
  pname = "redkite";
  version = "0.8.1";

  src = fetchFromGitLab {
    owner = "geontime";
    repo = pname;
    rev = "v${version}";
    sha256 = "17kv2jc4jvn3sdicz3sf8dnf25wbvv7ijzkr0mm0sbrrjz6vrwz0";
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
