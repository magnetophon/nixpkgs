{ stdenv, fetchFromGitHub, xorg, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "BSchaffl";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = version;
    sha256 = "0rbn7k7rkn610hsv2mcq41qgrp1dgl0nhg6q6sy9zqcqrk59pd77";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xorg.libX11 cairo lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sjaehn/BSchaffl";
    description = "Pattern-controlled MIDI amp & time stretch (experimental)";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
