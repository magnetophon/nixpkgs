{ stdenv
, fetchFromGitHub
, bash
, meson
, ninja
, cmake
, pkgconfig
, python3Packages
, help2man
, python3
, libxml2
, audec
, gtk3
, wrapGAppsHook
, guile
, gtksourceview
, lilv
, libcyaml
, libyaml
, fftw
, fftwFloat
, libjack2
, ffmpeg
, carla
, rtaudio
, rtmidi
, SDL2
, libgtop
, xdg_utils
, pandoc
, texi2html
, alsaLib
, git
, libsndfile
, libsamplerate
, sratom
, serd
, sord
, chromaprint
, rubberband
, pcre
, bash-completion
}:

stdenv.mkDerivation rec {
  pname = "zrythm";
  version = "0.8.252";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0m7i8f5y3lvkbflys0iblkl6ksw6kn2b64k6gy10yd549n8adx69";
  };

  prePatch = ''
    # doesn't work:
    # patchShebangs resources/gen_gtk_resources_xml_wrap.sh
    substituteInPlace resources/gen_gtk_resources_xml_wrap.sh --replace "/usr/bin/env sh" "${bash}/bin/sh"
  '';

  nativeBuildInputs = [ audec gtk3 wrapGAppsHook meson ninja cmake pkgconfig python3Packages.sphinx help2man python3 libxml2 ];

  buildInputs = [
    guile
    gtksourceview
    lilv
    libcyaml
    libyaml
    fftw
    fftwFloat
    libjack2
    ffmpeg
    carla
    rtaudio
    rtmidi
    SDL2
    libgtop
    xdg_utils
    pandoc
    texi2html
    alsaLib
    git
    libsndfile
    libsamplerate
    sratom
    serd
    sord
    chromaprint
    rubberband
    pcre
    bash-completion
  ];

  mesonFlags = [
    "-Denable_ffmpeg=true"
    "-Denable_rtmidi=true"
    "-Denable_rtaudio=true"
    "-Denable_sdl=true"
    "-Dmanpage=true"
    "-Duser_manual=true"
  ];

  preInstall = ''
    patchShebangs meson_post_install_wrap.sh
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.zrythm.org";
    description = "highly automated and intuitive digital audio workstation";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
