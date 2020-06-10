{ stdenv, fetchFromGitHub, requireFile, unzip, cmake }:

stdenv.mkDerivation rec {
  pname = "airwindows";
  version = "unstable-2020-06-05";

  # we use a fork of the main repo since upstream has a broken build system and hasn't merged any PR's since 2018
  # https://github.com/airwindows/airwindows/pulls?q=is%3Apr+is%3Aclosed
  # We track this branch:
  # https://github.com/laserbat/airwindows/tree/new_build
  src = fetchFromGitHub {
    owner = "laserbat";
    repo = pname;
    rev = "d480ce3a0f849e5dbf06e28f93e148f8bf3e23a5";
    sha256 = "0yixazwl5c1fj4rj2k89brvp7fr2n6q52kmiql4cnsh6n9vjjdp4";
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
    # mkdir -p vstsdk
    # cp ${vst-sdk}/public.sdk/source/vst2.x/* ./vstsdk/
    # cp -r ${vst-sdk}/pluginterfaces ./vstsdk/pluginterfaces
    # chmod -R 777 vstsdk/pluginterfaces
  mkdir -p include/vstsdk
  cp ${vst-sdk}/public.sdk/source/vst2.x/* ./include/vstsdk/
  cp -r ${vst-sdk}/pluginterfaces ./include/vstsdk/pluginterfaces
  chmod -R 777 include/vstsdk/pluginterfaces
echo ls88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
ls include/vstsdk
  '';

  # mkdir -p include/vstsdk
  # cp ${vst-sdk}/public.sdk/source/vst2.x/* ./include/vstsdk/
  # cp -r ${vst-sdk}/pluginterfaces ./include/vstsdk/pluginterfaces
  # chmod -R 777 include/vstsdk/pluginterfaces
  #
  # patchPhase = ''
  #   cd plugins/LinuxVST
  #   rm build/CMakeCache.txt
  #   mkdir -p include/vstsdk
  #   cp -r ${airwindows-ports}/include/vstsdk/CMakeLists.txt include/vstsdk/
  #   cp -r ${vst-sdk}/pluginterfaces include/vstsdk/pluginterfaces
  #   cp -r ${vst-sdk}/public.sdk/source/vst2.x/* include/vstsdk/
  #   chmod -R 777 include/vstsdk/pluginterfaces
  # '';

  # installPhase = ''
  #   for so_file in *.so; do
  #     install -vDm 644 $so_file -t "$out/lib/lxvst"
  #   done;
  # '';

  meta = with stdenv.lib; {
    description = "Handsewn bespoke linuxvst plugins";
    homepage = "http://www.airwindows.com/airwindows-linux/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
