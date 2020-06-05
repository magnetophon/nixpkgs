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
    rev = "e766c1011631e4a8a75f1d5fd36605ba5f9e49b3";
    sha256 = "0pp41jc83zwaw38mpazb6s4rpxx1wk7bfrn8pr0s9hm9xvz1f178";
  };

  vst-sdk = stdenv.mkDerivation rec {
    name = "vstsdk366_27_06_2016_build_61";
    src = requireFile {
      name = "${name}.zip";
      url = "https://www.steinberg.net/sdk_downloads/vstsdk366_27_06_2016_build_61.zip";
      sha256 = "05gsr13bpi2hhp34rvhllsvmn44rqvmjdpg9fsgfzgylfkz0kiki";
    };
    nativeBuildInputs = [ unzip ];
    installPhase = "cp -r . $out";
    meta.license = stdenv.lib.licenses.unfree;
  };


  nativeBuildInputs = [ cmake ];

  postPatch = "cd plugins/LinuxVST";

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
