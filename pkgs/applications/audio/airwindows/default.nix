{ stdenv, lib, fetchFromGitHub, requireFile, unzip, cmake }:

stdenv.mkDerivation rec {
  pname = "airwindows";
  version = "unstable-2021-12-24";

  src = fetchFromGitHub {
    owner = "airwindows";
    repo = "airwindows";
    rev = "0e28ead5b7dd759ad07ff7bfbd95e1e458e7fcd2";
    sha256 = "sha256-QUM7dKPcan9g3miZFtaf4oblYVnJ86iJiyOKi70jV/E=";
  };

  vst-sdk = stdenv.mkDerivation rec {
    name = "vstsdk366_27_06_2016_build_61";
    src = requireFile {
      name = "${name}.zip";
      url =
        "https://www.steinberg.net/sdk_downloads/vstsdk366_27_06_2016_build_61.zip";
      sha256 = "05gsr13bpi2hhp34rvhllsvmn44rqvmjdpg9fsgfzgylfkz0kiki";
    };
    nativeBuildInputs = [ unzip ];
    installPhase = "cp -r . $out";
  };

  airwindows-ports = stdenv.mkDerivation rec {
    name = "airwindows-ports";
    src = fetchFromGitHub {
      owner = "ech2";
      repo = "airwindows-ports";
      rev = "0.4.0";
      sha256 = "1ya4qbc63sb52nzisdapsydrnnpqnjsl5kgxibbr3dxf32474g89";
    };
    installPhase = "cp -r . $out";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    cd plugins/LinuxVST
    mkdir -p include/vstsdk
    cp -r ${airwindows-ports}/include/vstsdk/CMakeLists.txt include/vstsdk/
    cp -r ${vst-sdk}/pluginterfaces include/vstsdk/pluginterfaces
    cp -r ${vst-sdk}/public.sdk/source/vst2.x/* include/vstsdk/
    chmod -R 755 include/vstsdk/pluginterfaces
  '';

  installPhase = ''
    runHook preInstall
    for so_file in *.so; do
      install -vDm 644 $so_file -t "$out/lib/lxvst"
    done;
    runHook postInstall
  '';

  meta = with lib; {
    description = "Handsewn bespoke linuxvst plugins";
    homepage = "http://www.airwindows.com/airwindows-linux/";
    # airwindows is mit, but the vst sdk is unfree
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
