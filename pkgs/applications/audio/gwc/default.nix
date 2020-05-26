{
  stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, alsaLib
, libpulseaudio
, gtk2
, hicolor-icon-theme
, libsndfile
, fftw
, perl
, xdg_utils
, vorbis-tools
}:

stdenv.mkDerivation rec {
  pname = "gwc";
  version = "0.22-04";

  src = fetchFromGitHub {
    owner = "AlisterH";
    repo = pname;
    rev = version;
    sha256 = "0xvfra32dchnnyf9kj5s5xmqhln8jdrc9f0040hjr2dsb58y206p";
  };

  buildInputs = [
    alsaLib
    libpulseaudio
    gtk2
    hicolor-icon-theme
    libsndfile
    fftw
    perl
    xdg_utils
    vorbis-tools
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  meta = with stdenv.lib; {
    description = "a gui application to remove noise (hiss, pops and clicks) from audio files";
    homepage = "http://gwc.sourceforge.net/";
    license = licenses.gpl1;
    maintainers = maintainers.magnetophon;
    platforms = platforms.linux;
  };
}
