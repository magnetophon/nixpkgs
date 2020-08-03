{ stdenv, fetchFromGitHub, xorg, cairo, libjack2, pcre, libXdmcp, libsigcxx, liblo, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "Mamba";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rjy7l9sx8xvk64s29g0jrrirm5h2qg0pdvvz4i1kkbs7nasnjm5";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xorg.libX11 xorg.libpthreadstubs cairo libjack2 pcre libXdmcp libsigcxx liblo
  ];

  # error: format not a string literal and no format arguments [-Werror=format-security]
  # hardeningDisable = [ "format" ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/brummer10/Mamba";
    description = "Virtual Midi keyboard for Jack Audio Connection Kit";
    maintainers = [ maintainers.magnetophon ];
    license = licenses.bsd0;
  };
}
