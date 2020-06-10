{ stdenv, fetchFromGitHub, requireFile, unzip, cmake }:

stdenv.mkDerivation rec {
  pname = "airwindows";
  version = "unstable-2020-06-10";

  # we use a fork of the main repo since upstream has a broken build system and hasn't merged any PR's since 2018
  # https://github.com/airwindows/airwindows/pulls?q=is%3Apr+is%3Aclosed
  # We track this branch:
  # https://github.com/laserbat/airwindows/tree/new_build
  src = fetchFromGitHub {
    owner = "laserbat";
    repo = pname;
    rev = "efa467d44b0c8f9b6aeb228e8c9770c8b82842b4";
    sha256 = "1s390d91rm38lwyxkv5q1vl8dpa1fc8sj9vblv274rwxrr5h6s0x";
  };

  vst-sdk = stdenv.mkDerivation rec {
    name = "vst_sdk2_4_rev2";
    src = requireFile {
      name = "${name}.zip";
      url = "https://archive.org/download/VST2SDK/vst_sdk2_4_rev2.zip";
      sha256 = "0d4p9f52wh0af9c15g2kyj217ixqyl0m27zigqv064npk34q2p3r";
    };
    nativeBuildInputs = [ unzip ];
    installPhase = "cp -r . $out";
    meta.license = stdenv.lib.licenses.unfree;
  };


  nativeBuildInputs = [ cmake ];

  postPatch = ''
    cd plugins/LinuxVST
    mkdir -p vstsdk
    cp ${vst-sdk}/public.sdk/source/vst2.x/* ./vstsdk/
    cp -r ${vst-sdk}/pluginterfaces ./vstsdk/pluginterfaces
  '';

  installPhase = ''
    for so_file in *.so; do
      install -vDm 644 $so_file -t "$out/lib/lxvst"
    done;
  '';

  meta = with stdenv.lib; {
    description = "Handsewn bespoke linuxvst plugins";
    homepage = "http://www.airwindows.com/airwindows-linux/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
