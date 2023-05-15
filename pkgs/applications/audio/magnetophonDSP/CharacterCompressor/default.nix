{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "CharacterCompressor";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "CharacterCompressor";
    rev = version;
    sha256 = "sha256-PwiNHeqcpg8K4K2ohUdw0sfibtEYESg3RllibVOb+Cw=";
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
    description = "A compressor with character. For jack and lv2";
    homepage = "https://github.com/magnetophon/CharacterCompressor";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
