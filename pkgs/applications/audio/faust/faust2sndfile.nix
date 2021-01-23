{ faust
, libsndfile
, flac
, libogg
, libopus
, libvorbis
}:

# This just runs faust2svg, then attempts to open a browser using
# 'xdg-open'.

faust.wrapWithBuildEnv {

  baseName = "faust2sndfile";

  propagatedBuildInputs = [ libsndfile flac libogg libopus libvorbis ];

    # faust2csound generated .cpp files have
    #   #include "csdl.h"
  # but that file is in the csound/ subdirectory
  preFixup = ''
    NIX_CFLAGS_COMPILE="$(printf '%s' "$NIX_CFLAGS_COMPILE" | sed 's%${libsndfile}/include%${libsndfile}/include%')"
  '';

}
