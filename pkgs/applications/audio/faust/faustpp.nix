{ stdenv
, fetchFromGitHub
, cmake
, jinja2
, boost
, faust
}:

stdenv.mkDerivation rec {
  pname = "faustpp";
  version = "unstable-2020-05-19";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = pname;
    rev = "946b0811616f5931d58923da24f2ddc091216ad0";
    sha256 = "0nfx3d3qjil2bx9lfp4ygkshbwxlsldbgmxa05d6slyjrcbp0xil";
    fetchSubmodules = true;
  };

  buildInputs = [ cmake boost ];

  propagatedBuildInputs = [ jinja2 faust ];

  meta = with stdenv.lib; {
    description = "A post-processor for faust, which allows to generate with more flexibility";
    homepage = "https://github.com/jpcima/faustpp";
    license = licenses.boost;
    platforms = platforms.linux;
    maintainers = with maintainers; [ magnetophon ];
  };
}
