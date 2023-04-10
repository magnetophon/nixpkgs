{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "MBdistortion";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "MBdistortion";
    rev = version;
    sha256 = "sha256-uQs5FpB5mLLyIugM0SV+5dPkWsdA0mUyi1DD6XxnoIo=";
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
    description = "Mid-side multiband distortion for jack and lv2";
    homepage = "https://github.com/magnetophon/MBdistortion";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
