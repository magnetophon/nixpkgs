{ stdenv, fetchFromGitHub, cairo, meson, ninja, pkgconfig, cmake, faust, boost, zita-resampler, zita-convolver, lv2, ladspa-sdk, fftw, gnome3, libxcb, xcbutilwm }:

stdenv.mkDerivation rec {
  pname = "Kapitonov-Plugins-Pack";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "olegkapitonov";
    repo = pname;
    rev = version;
    sha256 = "1mxi7b1vrzg25x85lqk8c77iziqrqyz18mqkfjlz09sxp5wfs9w4";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    cmake
    faust
  ];

  buildInputs = [
    cairo
    boost
    zita-resampler
    zita-convolver
    lv2
    ladspa-sdk
    fftw
    libxcb
    xcbutilwm
  ];

  meta = with stdenv.lib; {
    description = "Set of LADSPA and LV2 plugins for guitar sound processing";
    homepage = https://github.com/olegkapitonov/Kapitonov-Plugins-Pack;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ magnetophon ];
  };
}
