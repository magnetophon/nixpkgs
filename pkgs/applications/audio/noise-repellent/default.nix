{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, fftwFloat, lv2 }:

stdenv.mkDerivation rec {
  pname = "noise-repellent";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "lucianodato";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kgsv1k0fvzlv8l0jh4pw6ja7695i6p4h036pjil01js7yz9xkih";
    fetchSubmodules = true;
  };

  mesonFlags = ("--prefix=${placeholder "out"}/lib/lv2");

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [
    fftwFloat lv2
  ];

  meta = with stdenv.lib; {
    description = "An lv2 plugin for broadband noise reduction";
    homepage    = https://github.com/lucianodato/noise-repellent;
    license     = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "i686-darwin"  ];
  };
}
