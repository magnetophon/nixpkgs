{ stdenv, fetchFromGitHub, pkgconfig, pango, cairo, libGLU, lv2 }:

stdenv.mkDerivation rec {
  pname = "avldrums.lv2";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "x42";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vwdp3d8qzd493qa99ddya7iql67bbfxmbcl8hk96lxif2lhmyws";
    fetchSubmodules = true;
  };

  installFlags = [ "PREFIX=$(out)" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    pango cairo libGLU lv2
  ];

  meta = with stdenv.lib; {
    description = "Dedicated AVLDrumkits LV2 Plugin";
    homepage    = http://x42-plugins.com/x42/x42-avldrums;
    license     = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
