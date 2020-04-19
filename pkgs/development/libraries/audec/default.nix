{ stdenv, fetchurl, libsndfile, libsamplerate, meson, ninja, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "audec";
  version = "0.2";

  src = fetchurl {
    url =  "https://git.zrythm.org/cgit/libaudec/snapshot/libaudec-${version}.tar.gz";
    sha256 = "0xwgsdls96p5b3zazi6b6m0kwyca1pylbxbh2wfl1zzmw80mkz43";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [
    libsndfile libsamplerate meson
  ];
 
  meta = with stdenv.lib; {
    description = "Library for reading and resampling audio files";
    homepage = "https://git.zrythm.org/cgit/libaudec";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
