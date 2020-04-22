{ stdenv, fetchFromGitLab, cmake, pkgconfig, redkite, libsndfile, rapidjson, libjack2, lv2, libX11, cairo }:

stdenv.mkDerivation rec {
  pname = "geonkick";
  version = "2.0.2";

  src = fetchFromGitLab {
    owner = "iurie-sw";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rfy0pa7h65ww62fhwycksfwxry77blmz8f9dj2mc5b0wpvdv2i1";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ redkite libsndfile rapidjson libjack2 lv2 libX11 cairo ];

  enableParallelBuilding = true;

  cmakeFlags = [ "-DGKICK_REDKITE_SDK_PATH=${redkite}" ];


  meta = {
    homepage = "https://gitlab.com/iurie-sw/geonkick";
    description = "A free software percussion synthesizer";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
