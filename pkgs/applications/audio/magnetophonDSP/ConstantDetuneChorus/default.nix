{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "constant-detune-chorus";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "constant-detune-chorus";
    # rev = version;
    rev = "4a30b295244f47912d68b3bd6e3919ff3e69ad0b";
    sha256 = "sha256-cw04gYfRHOoTZPwU7xaC5jqj5F5jM6rNvcGiI4C42tw=";
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
