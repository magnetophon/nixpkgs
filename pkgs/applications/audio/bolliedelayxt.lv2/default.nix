{ lib, stdenv, fetchFromGitHub, lv2 }:

stdenv.mkDerivation  rec {
  pname = "bolliedelayxt.lv2";
  version = "unstable 2017-10-25";

  src = fetchFromGitHub {
    owner = "MrBollie";
    repo = pname;
    rev = "4f6b8aafd9ed4f20f0cc6750977dcdc57d1fc493";
    sha256 = "sha256-dbUzb7vuGTVBfvEzjPiX9knxk2AYRMUD1majA1HkBPk=";
  };

  buildInputs = [ lv2 ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A flexible LV2 delay plugin";
    homepage = "https://github.com/MrBollie/bolliedelayxt.lv2";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
