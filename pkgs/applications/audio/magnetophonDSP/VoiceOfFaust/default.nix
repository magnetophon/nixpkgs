{ lib, stdenv, fetchFromGitHub, faust2jack, faust2lv2, helmholtz, mrpeach, puredata-with-plugins }:
stdenv.mkDerivation rec {
  pname = "VoiceOfFaust";
  version = "1.1.6_big";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "VoiceOfFaust";
    # rev = version;
    rev = "a2de28b3bae69c551aa325b3f55987155f7cf905";
    sha256 = "sha256-Xv8jglUa73/QEbzmex1saYFUUUv40eSM6YgwMUpFrp0=";
  };

  plugins = [ helmholtz mrpeach ];

  pitchTracker = puredata-with-plugins plugins;

  buildInputs = [ faust2jack faust2lv2 ];

  runtimeInputs = [ pitchTracker ];

  dontWrapQtApps = true;

  patchPhase = ''
    sed -i "s@pd -nodac@${pitchTracker}/bin/pd -nodac@g" launchers/pitchTracker
    sed -i "s@pd -nodac@${pitchTracker}/bin/pd -nodac@g" launchers/pitchTrackerGUI
    sed -i "s@../PureData/OscSendVoc.pd@$out/bin/PureData/OscSendVoc.pd@g" launchers/pitchTracker
    sed -i "s@../PureData/OscSendVoc.pd@$out/bin/PureData/OscSendVoc.pd@g" launchers/pitchTrackerGUI
  '';

  makeFlags = [ "PREFIX=$(out)" ];
  enableParallelBuilding = true;

  meta = {
    description = "Turn your voice into a synthesizer";
    homepage = "https://github.com/magnetophon/VoiceOfFaust";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
