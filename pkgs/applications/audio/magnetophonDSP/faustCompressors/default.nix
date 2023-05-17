{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "faustCompressors";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "faustCompressors";
    rev = version;
    sha256 = "sha256-nUKDHaXBZ6pu+H/xKaku/CaB99/k89lXLaHLgB6oHvU=";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  makeFlags = [ "PREFIX=$(out)" ];
  dontWrapQtApps = true;
  enableParallelBuilding = true;

  postInstall = ''
    for f in $(find . -executable -type f -name '*-wrapped'); do
      cp $f $out/bin/
    done
  '';


  meta = {
    description = "A collection of bread and butter compressors";
    homepage = "https://github.com/magnetophon/faustCompressors";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
