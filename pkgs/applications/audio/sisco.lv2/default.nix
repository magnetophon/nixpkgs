{ stdenv, fetchFromGitHub, pkgconfig
, lv2, libGLU, libGL, cairo, pango, libjack2 }:

stdenv.mkDerivation rec {

  version = "0.8.5";
  pname = "sisco.lv2";

  src = fetchFromGitHub  {
    owner = "x42";
    repo = pname;
    rev = "v${version}";
    sha256 = "14nagi0pxf32hk5syhm2cyzpc471vpc68s683z0p8sn3cifviqy2";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lv2 pango cairo libjack2 libGLU libGL ];

  sisco_VERSION = version;
  preConfigure = "makeFlagsArray=( PREFIX=$out )";

  meta = with stdenv.lib; {
    description = "Simple audio oscilloscope with variable time scale, triggering, cursors and numeric readout in LV2 plugin format";
    homepage = http://x42.github.io/sisco.lv2/;
    license = licenses.gpl2;
    maintainers = [ maintainers.e-user ];
    platforms = platforms.linux;
  };
}
