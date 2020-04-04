{ stdenv, fetchFromGitHub, libjack2, libGL, pkgconfig, xorg, mesa, libsndfile, libsamplerate }:

stdenv.mkDerivation rec {
  pname = "ninjas2";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "clearly-broken-software";
    repo = pname;
    rev = "v${version}";
    sha256 = "1kwp6pmnfar2ip9693gprfbcfscklgri1k1ycimxzlqr61nkd2k9";
    fetchSubmodules = true;
  };

  patchPhase = ''
    patchShebangs dpf/utils/generate-ttl.sh
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libjack2 xorg.libX11 libGL mesa libsndfile libsamplerate
  ];

  installPhase = ''
  mkdir -p $out/lib/lv2
  cp -r bin/ninjas2.lv2 $out/lib/lv2
  mkdir -p $out/lib/vst
  cp bin/ninjas2-vst.so  $out/lib/vst
  mkdir -p $out/bin
  cp bin/ninjas2 $out/bin
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/clearly-broken-software/ninjas2;
    description = "sample slicer plugin for LV2, VST, and jack standalone";
    license = with licenses; [ gpl3 ];
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
