{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "pluginUtils";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "pluginUtils";
    rev = version;
    sha256 = "sha256-066Y1cuDJftqIXUQMlU6WfD0IcY277U4+8L/VPbSBiY=";
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
    description = "Some simple utility lv2 plugins";
    homepage = "https://github.com/magnetophon/pluginUtils";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
