{ stdenv, fetchgit, graphviz, gtk2, gtkmm2, pkgconfig, python, wafHook }:

stdenv.mkDerivation rec {
  pname = "ganv";
  version = "1.8.0";

  src = fetchgit {
    url = "https://gitlab.com/drobilla/${pname}.git";
    fetchSubmodules = true;
    rev = version;
    sha256 = "01zrnalirbqxpz62fbw2c14c8xn117jc92xv6dhb3hln92k9x37f";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ graphviz gtk2 gtkmm2 python ];

  meta = with stdenv.lib; {
    description = "An interactive Gtk canvas widget for graph-based interfaces";
    homepage = "http://drobilla.net";
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
  }
