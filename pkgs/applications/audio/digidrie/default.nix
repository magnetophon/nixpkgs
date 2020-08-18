{ stdenv, fetchFromGitHub , libjack2, lv2, xorg, liblo, libGL, libXcursor, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "digidrie";
  version = "unstable-2020-17-8";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "DigiDrie";
    rev = "c5a3afdf415dec05631bf2e39c609b611ab79540";
    sha256 = "1a1j8dm3dmvccz5346rs48qb9sz84nqbcpzf25an2wlvl3424b0j";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libjack2 lv2 xorg.libX11 liblo libGL libXcursor ];

  patchPhase = ''
    cd plugin/dpf
    patchShebangs generate-ttl.sh
    patchShebangs ./patch/apply.sh
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2
    # mkdir -p $out/lib/dssi
    mkdir -p $out/lib/vst
    mkdir -p $out/bin/
    cp -r bin/DigiDrie.lv2    $out/lib/lv2/
    # cp -r bin/DigiDrie-dssi*  $out/lib/dssi/
    cp -r bin/DigiDrie-vst.so $out/lib/vst/
    cp -r bin/DigiDrie        $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/magnetophon/DigiDrie";
    description = "a monster monophonic synth, written in faust";
    license = licenses.agpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.all;
  };
}
