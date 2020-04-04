{ stdenv, fetchFromGitLab, cmake, cairo }:

stdenv.mkDerivation rec {
  pname = "redkite";
  version = "0.8.0";

  src = fetchFromGitLab {
    owner = "geontime";
    repo = pname;
    rev = "348d65511a52b24df18024d4fce971b47fd2e6e4";
    sha256 = "0gv0zs4vpabw1gkbsgv6dgzxmzr2kyv5f2iz8hbqkxz0yazs4d2l";
    # rev = "v${version}";
    # sha256 = "1747w1kg8y9jbl11xi018d85dm38xk7843pz26sh0k5fdv87a10q";
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
