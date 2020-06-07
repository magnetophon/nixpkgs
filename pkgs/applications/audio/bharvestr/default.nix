{ stdenv, fetchFromGitHub, xorg, cairo, lv2, libsndfile, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "BHarvestr";
  version = "unstable-2020-05-22";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = pname;
    rev = "ffd310a794e899eb863ab3a1d9ce672c540503f7";
    sha256 = "0w4d9phhj3rrdslfgrxx28804ggp4dz68sqwafjnyxvdlbc8c316";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xorg.libX11 cairo lv2 libsndfile
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/sjaehn/BHarvestr";
    description = "Granular synthesizer LV2 plugin (experimental)";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
