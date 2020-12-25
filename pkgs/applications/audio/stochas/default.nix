{ stdenv, fetchFromGitHub, cmake, pkg-config, libX11, libXrandr, libXinerama, libXext, libXcursor, freetype, alsaLib, libjack2 }:

stdenv.mkDerivation rec {
  pname = "stochas";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b26mbj727dnygavz4kihnhmnnvwsr9l145w6kydq7bd7nwiw7lq";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    libX11 libXrandr libXinerama libXext libXcursor freetype alsaLib libjack2
  ];

  installPhase = ''
    mkdir -p $out/lib/vst3
    cp -r stochas_artefacts/Release/VST3/Stochas.vst3 $out/lib/vst3
  '';

  meta = with stdenv.lib; {
    description = "Objective-C runtime for use with GNUstep";
    homepage = "http://gnustep.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ashalkhakov matthewbauer ];
    platforms = platforms.unix;
  };
}
