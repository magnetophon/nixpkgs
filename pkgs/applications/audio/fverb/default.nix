{ stdenv, fetchFromGitHub, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "fverb";
  version = "unstable-2020-04-04";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = pname;
    rev = "0ae96411e0af029821c362c30d510bbc94fecdae";
    sha256 = "1lcbdysaavl6ga410ybq0f35jnqgcyjymrqs48rg8n0mi513xbj5";
  };

  buildInputs = [ faust2lv2 ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A stereo variant of the reverberator by Jon Dattorro, for lv2";
    homepage = "https://github.com/jpcima/fverb";
    license = licenses.bsd2;
    maintainers = [ maintainers.magnetophon ];
    };
}
