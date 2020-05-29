{ stdenv, fetchurl, pkgconfig, libsamplerate, libsndfile, fftw
, vamp-plugin-sdk, ladspaH }:

stdenv.mkDerivation rec {
  pname = "rubberband";
  version = "1.8.2";

  src = fetchurl {
    url = "https://breakfastquay.com/files/releases/${pname}-${version}.tar.bz2";
    sha256 = "1jn3ys16g4rz8j3yyj5np589lly0zhs3dr9asd0l9dhmf5mx1gl6";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsamplerate libsndfile fftw vamp-plugin-sdk ladspaH ];

  # https://github.com/breakfastquay/rubberband/issues/17
  postPatch = ''
    substituteInPlace Makefile.in --replace \
    'cp -f $(JNI_TARGET) $(DESTDIR)$(INSTALL_LIBDIR)/$(JNINAME)$(DYNAMIC_EXTENSION)' \
    'test -f $(JNI_TARGET) && cp -f $(JNI_TARGET) $(DESTDIR)$(INSTALL_LIBDIR)/$(JNINAME)$(DYNAMIC_EXTENSION) || true'
  '';

  meta = with stdenv.lib; {
    description = "High quality software library for audio time-stretching and pitch-shifting";
    homepage = "https://breakfastquay.com/rubberband/";
    # commercial license available as well, see homepage. You'll get some more optimized routines
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
