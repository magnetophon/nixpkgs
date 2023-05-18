{ lib, stdenv, fetchFromGitHub, faust2jack, faust2lv2, helmholtz, mrpeach, puredata-with-plugins }:
stdenv.mkDerivation rec {
  pname = "VoiceOfFaust";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "VoiceOfFaust";
    # rev = version;
    rev = "51c52c987cde35d03b0e8074d5a39b3f69d7ab84";
    sha256 = "sha256-xR3XGebYEhvC9tMt/nJlPKRtLn8dgDV2gUT8obIrmDQ=";
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
