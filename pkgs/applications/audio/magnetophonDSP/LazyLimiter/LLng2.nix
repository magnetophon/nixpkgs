{ stdenv, fetchFromGitHub, faust2jack, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "LLng2";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "LazyLimiter";
    rev = "9bf18451b169227dca0f83e68b876edb110980cf";
    sha256 = "18073dqwvwvvb6qyz4d2j6bb3pxa8pxmlh06nns1sb0vhqjhc8md";
  };
  # src = "/home/bart/source/LazyLimiter/";

  # so it gets built on nxb-16, with lotsa ram: 16*3.5 = 56G
  requiredSystemFeatures = [ "big-parallel" ];

  buildInputs = [ faust2jack faust2lv2 ];

  # phases = [ "patchPhase" "buildPhase" "installPhase" ];

  # patchPhase = ''
  # cd $src
  # substituteInPlace LLng2.dsp --replace "expo = 10;" "expo = 8;"
  # '';

  buildPhase = ''
    cd $src
    faust2jack -time -t 0 LLng2.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp LLng2 $out/bin/
  '';

  meta = {
    description = "A fast yet clean lookahead limiter for jack and lv2";
    homepage = https://magnetophon.github.io/LazyLimiter/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
