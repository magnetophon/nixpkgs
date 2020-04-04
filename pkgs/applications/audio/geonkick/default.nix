{ stdenv, fetchFromGitLab, cmake, pkgconfig, redkite, libsndfile, rapidjson, libjack2, lv2, libX11, cairo }:

stdenv.mkDerivation rec {
  pname = "geonkick";
  # version = "1.10.0";
  version = "unstable";

  src = fetchFromGitLab {
    owner = "geontime";
    repo = pname;
    rev = "8a4a729d312a801e4a3c9653e3de44da03795caf";
    sha256 = "0srbplal5k0plmhxzaf4mpxmvvhayqj3mscgh7wh8ipjybcfpqky";
    # rev = "v${version}";
    # sha256 = "1a59wnm4035kjhs66hihlkiv45p3ffb2yaj1awvyyi5f0lds5zvh";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ redkite libsndfile rapidjson libjack2 lv2 libX11 cairo ];

  enableParallelBuilding = true;

  cmakeFlags = [ "-DGKICK_REDKITE_SDK_PATH=${redkite}" ];


  meta = {
    homepage = "https://gitlab.com/geontime/geonkick";
    description = "A free software percussion synthesizer";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
