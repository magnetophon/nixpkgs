{ stdenv, fetchFromGitHub, cairo, meson, ninja, pkgconfig, cmake, faust, boost, zita-resampler, zita-convolver, lv2, ladspa-sdk, fftw, gnome3, libxcb, xcbutilwm }:

stdenv.mkDerivation rec {
  pname = "Kapitonov-Plugins-Pack";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "olegkapitonov";
    repo = pname;
    rev = "v${version}";
    sha256 = "01ww3a0vdvx2l655f219p3159q6d3hph9i3g9siplv34b12rxxbn";
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

  postPatch = ''
    substituteInPlace LV2/kpp_tubeamp/kpp_tubeamp_ui.src/kpp_tubeamp_gui.c --replace zenity ${gnome3.zenity}/bin/zenity
  '';

  meta = with stdenv.lib; {
    description = "Set of LADSPA and LV2 plugins for guitar sound processing";
    homepage = https://github.com/olegkapitonov/Kapitonov-Plugins-Pack;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ magnetophon ];
  };
}
