{ stdenv, fetchFromGitHub, libjack2, libGL, pkgconfig, xorg, mesa }:

stdenv.mkDerivation rec {
  pname = "Punch";
  version = "unstable-2020-04-05";

  src = fetchFromGitHub {
    owner = "clearly-broken-software";
    repo = pname;
    rev = "4ad268c1a75cc7c0cc5d94da7183e97d8a915ae2";
    sha256 = "11cc0s2i4f9ril9mb2lg8kd5xndblvwm90x445wy3zzcakw5vap6";
    # fetchSubmodules = true;
  };

  patchPhase = ''
    patchShebangs dpf/utils/generate-ttl.sh
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libjack2 xorg.libX11 libGL mesa
  ];

  installPhase = ''
    mkdir -p $out/lib/lv2
    cp -r bin/$pname.lv2 $out/lib/lv2
    mkdir -p $out/bin
    cp bin/$pname $out/bin
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/clearly-broken-software/Punch;
    description = "an LV2 compressor with character";
    license = with licenses; [ gpl2 ];
    maintainers = [ maintainers.magnetophon ];
    # platforms = [ "linux" ];
  };
}
