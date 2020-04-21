{ stdenv, fetchFromGitHub, fetchurl , xorg, lv2, libjack2, mesa, alsaLib, premake5,  pkgconfig,
  bash-completion, python3, python3Packages, unzip, curl, freetype, libXrandr, libXinerama, libXext, libXcursor, libX11, libXcomposite, libXrender }:

# Extract the archive into the directory libraries/juce.
stdenv.mkDerivation rec {
  pname = "squeezer";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "mzuther";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zsk7mgwc7ba6973ih50ijwzcwph32q5hv5xwy63rzrwlsaylcrh";
    # fetchSubmodules = true;
  };

  src2 = fetchurl {
    # url = "https://github.com/WeAreROLI/JUCE/releases/download/5.3.2/juce-5.3.2-linux.zip";
    url = "https://github.com/juce-framework/JUCE/archive/5.3.2.zip";
    sha256 = "1ggvjpbw19kix4rk1np0hjg4v695mj0rmansk05bg61i6q6vx19g";
  };

  propagatedBuildInputs = with python3Packages; [
    jinja2
  ];
  nativeBuildInputs = [ premake5 python3 unzip ];
  buildInputs = [
    xorg.libX11 lv2 libjack2 mesa alsaLib bash-completion curl freetype libXrandr libXinerama libXext libXcursor libX11 libXcomposite libXrender
  ];

  makeFlags = [ "--directory=linux/gmake/ --no-print-directory  config=release_x64  all" ];

  prePatch = ''
  rm -rf libraries/juce
  unzip $src2
  mv JUCE-5.3.2 libraries/juce
  substituteInPlace Builds/run_premake.sh --replace 'clang' 'gcc'
  cat Builds/run_premake.sh


'';
  preConfigure = ''
    sh ./Builds/run_premake.sh
    cd Builds
  '';

  # buildPhase =
  # ''
  # ls
  # cat build.sh
  # '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/mzuther/Squeezer";
    description = "Flexible general-purpose compressor with a touch of citrus, for lv2, jack and lv2";
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
