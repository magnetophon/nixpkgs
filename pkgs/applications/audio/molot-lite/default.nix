{ lib, stdenv, fetchFromGitHub, lv2 }:

stdenv.mkDerivation rec {

  pname = "molot-lite";
  version = "unstable-2021-05-22";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = pname;
    rev = "7604c8fc69ee5bd743f6a48c013bde2528d9eba4";
    sha256 = "09vaf5x73mxrkhzrkr5x125p84p6clynsjg9zj6cyf6w0w29ml1z";
  };

  buildInputs = [ lv2 ];

  makeFlags = [ "INSTALL_DIR=$out/lib/lv2" ];

  installPhase = ''
    make install INSTALL_DIR=$out/lib/lv2 -C Molot_Mono_Lite
    make install INSTALL_DIR=$out/lib/lv2 -C Molot_Stereo_Lite
  '';

  meta = with lib; {
    description = "Stereo and mono audio signal dynamic range compressor in LV2 format";
    homepage = "https://github.com/magnetophon/molot-lite";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
