{ lib, stdenv
, fetchFromGitHub
, pkg-config
, python3
, fftw
, libGL
, libX11
, libjack2
, liblo
, lv2
}:


stdenv.mkDerivation rec {
  pname = "digidrie";
  version = "unstable-2020-08-23";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "DigiDrie";
    rev = "74960f01db8a5ff59076451286365c774fd352d1";
    sha256 = "sha256-C+W7ZbWsVJQ7fHQhEwAp58fBeXFksQGNhWSAITrRFAM=";
    fetchSubmodules = true;
  };

  preConfigure = ''
    cd plugin/dpf
    patchShebangs ./patch/apply.sh ./generate-ttl.sh
    # we are somehow missing the style dir, so don't try to copy from it
    sed -i '/style/d'  Makefile
    # we are somehow missing the README, so don't try to copy it
    sed -i '/README/d'  Makefile

  '';

  postInstall = ''
    # conflicts with UhhyouPlugins
    rm -rf $out/share/doc/UhhyouPlugins
  '';
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fftw libGL libX11 libjack2 liblo lv2 ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/magnetophon/DigiDrie/";
    description = "A monster monophonic synth, written in faust.";
    maintainers = [ maintainers.magnetophon ];
    platforms = intersectLists platforms.linux platforms.x86;
    license = licenses.agpl3;
  };
}
