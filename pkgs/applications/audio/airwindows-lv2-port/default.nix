{ lib, stdenv, fetchgit, lv2, cmake }:

stdenv.mkDerivation rec {
  pname = "airwindows-lv2-port";
  version = "unstable-2021-08-01";

  src = fetchgit {
    url = "https://code.volse.net/audio/plugins/airwindows-lv2-port.git";
    fetchSubmodules = true;
    rev = "685e047999ed23e61a82ffffbc97ec52e8e4b971";
    sha256 = "1mcdfbv68bl2kcab7nz1p8kvhgbryzr26j5d1vxh0dgqz6hhqvaj";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ lv2 ];

  postPatch = "cd plugins/LV2/";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/lv2
    cp -r airwindows.lv2/ $out/lib/lv2
    runHook postInstall
  '';

  meta = with lib; {
    description = "Airwindows effects ported to LV2";
    homepage = "https://code.volse.net/audio/plugins/airwindows-lv2-port.git/plain/plugins/LV2/README.md";
    license = licenses.mit;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
