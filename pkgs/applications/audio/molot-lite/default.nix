{ lib, stdenv, fetchFromGitHub, unzip, lv2 }:

stdenv.mkDerivation rec {

  pname = "molot-lite";
  version = "unstable-2021-05-22";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = pname;
    rev = "938e7b293d5eb930d3cadf31a92cb5fadf4168f2";
    sha256 = "1dbq21g732qr80cyn6xqd0ki92d034ywmsb76dv68yxx5ifh97km";
  };

  buildInputs = [ lv2 ];

  installPhase = ''
    make install INSTALL_DIR=$out/lib/lv2 -C Molot_Mono_Lite
    make install INSTALL_DIR=$out/lib/lv2 -C Molot_Stereo_Lite
  '';

  makeFlags = [ "INSTALL_DIR=$out/lib/lv2" ];

  meta = with lib; {
    description = "Stereo and mono audio signal dynamic range compressor in LV2 format";
    homepage = "https://github.com/magnetophon/molot-lite";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
