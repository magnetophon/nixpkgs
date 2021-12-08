{ lib, stdenv, fetchFromGitHub, libjack2, libsndfile, libsamplerate, xorg
, freetype, libxkbcommon, cairo, pango, glib, gnome, flac, libogg, libvorbis
, libopus, cmake, pkg-config
# , makeWrapper
, pcre             # libpcre required by glib-2.0
, utillinux        # mount required by gio-2.0
, libselinux       # libselinux required by gio-2.0
, libsepol         # libsepol required by libselinx
, fribidi
, libthai          # libthai required by pango
, libdatrie        # libdatrie  required by libthai
}:

stdenv.mkDerivation rec {
  pname = "sfizz";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "sfztools";
    repo = pname;
    rev = version;
    sha256 = "sha256-9khAx3nkcigGq/TobL0GYmvrX3zQbyndf8/IhLRd978=";
    fetchSubmodules = true;
  };

  buildInputs = [
    libjack2
    libsndfile
    flac
    libogg
    libvorbis
    libopus
    xorg.libX11
    xorg.libxcb
    xorg.libXau
    xorg.libXdmcp
    xorg.xcbutil
    xorg.xcbutilcursor
    xorg.xcbutilrenderutil
    xorg.xcbutilkeysyms
    xorg.xcbutilimage
    libxkbcommon
    libsamplerate
    cairo
    pango
    glib
    gnome.zenity
    freetype
    pcre
    utillinux
    libselinux
    libsepol
    fribidi
    libthai
    libdatrie
  ];

  nativeBuildInputs = [ cmake pkg-config
                        # makeWrapper
                      ];

  postPatch = ''
    substituteInPlace plugins/editor/src/editor/NativeHelpers.cpp \
    --replace '/usr/bin/zenity' '${gnome.zenity}/bin/zenity'
  '';

  # postInstall = ''
  # wrapProgram $out/bin/sfizz_jack --prefix PATH ":" ${gnome.zenity}/bin
  # wrapProgram $out/bin/sfizz_render --prefix PATH ":" ${gnome.zenity}/bin
  # '';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" "-DSFIZZ_TESTS=ON" ];

  meta = with lib; {
    homepage = "https://github.com/sfztools/sfizz";
    description = "SFZ jack client and LV2 plugin";
    license = licenses.bsd2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.all;
    badPlatforms = platforms.darwin;
  };
}
