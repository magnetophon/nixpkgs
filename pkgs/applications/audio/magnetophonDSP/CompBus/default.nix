{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "CompBus";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "CompBus";
    rev = version;
    sha256 = "sha256-/kMI+NQ9v38l0cUTkP6ymZ0/RCWbENqq3aUtXwCGrTs=";
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
    description = "A group of compressors mixed into a bus, sidechained from that mix bus. For jack and lv2";
    homepage = "https://github.com/magnetophon/CompBus";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
