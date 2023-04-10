{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "constant-detune-chorus";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "constant-detune-chorus";
    rev = version;
    sha256 = "sha256-wLAUy21OxGBCwMrp8upjlV6JVsE0YGva6ZR84FrDPV4=";
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
    description = "A chorus algorithm that maintains constant and symmetric detuning depth (in cents), regardless of modulation rate. For jack and lv2";
    homepage = "https://github.com/magnetophon/constant-detune-chorus";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
