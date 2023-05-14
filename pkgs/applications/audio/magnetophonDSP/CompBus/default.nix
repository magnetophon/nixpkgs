{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "CompBus";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "CompBus";
    rev = version;
    sha256 = "sha256-+BwwAzgaddsDxyS1+kcluAbIB/xlMGaLW9hD+vHxPlI=";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  makeFlags = [ "PREFIX=$(out)" ];
  enableParallelBuilding = true;

  meta = {
    description = "A group of compressors mixed into a bus, sidechained from that mix bus. For jack and lv2";
    homepage = "https://github.com/magnetophon/CompBus";
    license = lib.licenses.agpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
