{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "shelfMultiBand";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "shelfMultiBand";
    rev = version;
    sha256 = "sha256-+n3fAVtfW5GnmfMsr64kMaybgCJwyv5F6/XQWrW/z/4=";
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
    description = "A multiband compressor made from shelving filters.";
    homepage = "https://github.com/magnetophon/shelfMultiBand";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
