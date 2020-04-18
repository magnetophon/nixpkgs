{ stdenv, fetchFromGitHub, xorg, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "BChoppr";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = "${version}";
    sha256 = "1hgh9i92zdfnrsbb7n1xpvrwrbjs7l7nx43sl6kikgn3hcdppdzy";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xorg.libX11 cairo lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/sjaehn/BChoppr;
    description = "An audio stream chopping LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
