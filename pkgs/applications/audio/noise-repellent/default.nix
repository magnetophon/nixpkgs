{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, cmake, libspecbleach, lv2 }:

stdenv.mkDerivation rec {
  pname = "noise-repellent";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "lucianodato";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hMNVzhJZFGFeu5aygLkfq495O0zpaIk41ddzejvDITE=";
    fetchSubmodules = true;
  };

  mesonFlags = ("--prefix=${placeholder "out"}/lib/lv2");

  nativeBuildInputs = [ meson ninja pkg-config cmake ];
  buildInputs = [
    libspecbleach lv2
  ];

  # See: https://github.com/lucianodato/noise-repellent/issues/99
  postInstall = ''
    mv $out/lib/lv2/.lv2/nrepellent.lv2 $out/lib/lv2/nrepellent.lv2
    rm -rf $out/lib/lv2/.lv2/
  '';

  meta = with lib; {
    description = "An lv2 plugin for broadband noise reduction";
    homepage    = "https://github.com/lucianodato/noise-repellent";
    license     = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "i686-darwin"  ];
  };
}
