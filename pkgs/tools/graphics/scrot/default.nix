{ lib, stdenv, fetchFromGitHub, giblib, xlibsWrapper, autoreconfHook
, autoconf-archive, libXfixes, libXcursor, libXcomposite
, pkg-config, gettext, libtool, intltool, gtk-doc, libbsd }:

stdenv.mkDerivation rec {
  pname = "scrot";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = pname;
    rev = version;
    sha256 = "sha256-oVmEPkEK1xDcIRUQjCp6CKf+aKnnVe3L7aRTdSsCmmY=";
  };

  nativeBuildInputs = [ autoreconfHook autoconf-archive pkg-config ];
  buildInputs = [ giblib xlibsWrapper libXfixes libXcursor libXcomposite gettext libtool intltool gtk-doc libbsd ];

  meta = with lib; {
    homepage = "https://github.com/resurrecting-open-source-projects/scrot";
    description = "A command-line screen capture utility";
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin ];
    license = licenses.mit;
  };
}
