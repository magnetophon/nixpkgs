{ stdenv, fetchFromGitHub, boost, cairo, lv2, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "string-machine";
  version = "unstable-12-11-2019";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = pname;
    rev = "609eddf395735853b2ad987864d0b3539e7f83df";
    sha256 = "1l03m8yl37vs1517w8kc6gml1rwjxcq8ws2whqiwgczksljb4r7s";
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

  meta = with stdenv.lib; {
    homepage = https://github.com/jpcima/string-machine;
    description = "Digital model of electronic string ensemble instrument";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.boost;
  };
}
