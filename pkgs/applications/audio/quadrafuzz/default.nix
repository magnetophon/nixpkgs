{ stdenv, fetchFromGitHub, boost, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "quadrafuzz";
  version = "unstable-17-10-2019";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = pname;
    rev = "a7cc7cba0bef09da9e6443e8967366650a372c37";
    sha256 = "1kjsf7il9krihwlrq08gk2xvil4b4q5zd87nnm103hby2w7ws7z1";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    boost cairo lv2
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  installPhase = ''
    mkdir -p $out/lib/lv2
    cp -r bin/quadrafuzz.lv2/ $out/lib/lv2
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jpcima/quadrafuzz;
    description = "Multi-band fuzz distortion plugin";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.isc;
  };
}
