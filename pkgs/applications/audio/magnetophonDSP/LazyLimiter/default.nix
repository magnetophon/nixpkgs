{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "LazyLimiter";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "LazyLimiter";
    rev = version;
    sha256 = "sha256-JZB9ZMvFLUwBYRxq9Ud2XcwInrKlPTJMZCzygEz4dRM=";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  makeFlags = [ "PREFIX=$(out)" ];
  enableParallelBuilding = true;

  postInstall = ''
    for f in $(find . -executable -type f -name '*-wrapped'); do
      cp $f $out/bin/
    done
  '';

  meta = {
    description = "A fast yet clean lookahead limiter for jack and lv2";
    homepage = "https://magnetophon.github.io/LazyLimiter/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
