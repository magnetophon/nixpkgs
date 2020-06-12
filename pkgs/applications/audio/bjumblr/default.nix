{ stdenv, fetchFromGitHub, libX11, cairo, lv2, pkgconfig, libsndfile }:

stdenv.mkDerivation rec {
  pname = "BJumblr";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = version;
    sha256 = "17h8zx6yqy0vyykik01iidqn0z736yc3244j75711gr07ab55i3d";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libX11 cairo lv2 libsndfile
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sjaehn/BJumblr";
    description = "Pattern-controlled audio stream / sample re-sequencer LV2 plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
