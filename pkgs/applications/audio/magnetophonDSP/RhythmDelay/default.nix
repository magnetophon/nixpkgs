{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "RhythmDelay";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "RhythmDelay";
    rev = version;
    sha256 = "sha256-NjuowEBfAshhSCz7thGWz5u2DNhbvrMcx1iRjePdK9A=";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    for f in $(find . -executable -type f -name '*-wrapped'); do
      cp $f $out/bin/
    done
  '';

  meta = {
    description = "Tap a rhythm into your delay! For jack and lv2";
    homepage = "https://github.com/magnetophon/RhythmDelay";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
