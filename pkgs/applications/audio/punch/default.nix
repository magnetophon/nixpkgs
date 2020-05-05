{ stdenv, fetchFromGitHub, libjack2, libGL, pkgconfig, xorg, mesa }:

stdenv.mkDerivation rec {
  pname = "Punch";
  version = "unstable-2020-04-28";

  src = fetchFromGitHub {
    owner = "clearly-broken-software";
    repo = pname;
    rev = "c50eb0548aa08df67efc447660e01fb03b9002b7";
    sha256 = "1ypq8x011ljvjqixpdjjb2nzhv7mvxvmkrhq0rp5k884cyycnpry";
    fetchSubmodules = true;
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
