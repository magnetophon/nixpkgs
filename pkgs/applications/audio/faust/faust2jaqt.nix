{ faust
, jack2
, qtbase
, libsndfile
, alsa-lib
, writeText
, makeWrapper
, which
}:
let
  # Wrap the binary coming out of the the compilation script, so it knows QT_PLUGIN_PATH
  wrapBinary = writeText "wrapBinary" ''
    source ${makeWrapper}/nix-support/setup-hook
    for p in $FILES; do
      workpath=$PWD
      cd -- "$(dirname "$p")"
      binary=$(basename --suffix=.dsp "$p")
      mv $binary ."$binary"-wrapped
      makeWrapper "./.$binary-wrapped" ".$binary-temp" --set QT_PLUGIN_PATH "${qtbase}/${qtbase.qtPluginPrefix}"
      mv ".$binary-temp" "$binary"
      sed -i $binary -e 's@exec@cd "$(dirname "$(readlink -f "''${BASH_SOURCE[0]}")")" \&\& exec@g'
      cd $workpath
    done
  '';
in
faust.wrapWithBuildEnv {

  baseName = "faust2jaqt";

  scripts = [
    "faust2jaqt"
    "faust2jackserver"
  ];

  propagatedBuildInputs = [
    jack2
    qtbase
    libsndfile
    alsa-lib
    which
  ];

  dontWrapQtApps = true;

  preFixup = ''
    for script in "$out"/bin/*; do
      # append the wrapping code to the compilation script
      cat ${wrapBinary} >> $script
      # prevent the qmake error when running the script
      sed -i "/QMAKE=/c\ QMAKE="${qtbase.dev}/bin/qmake"" $script
    done
  '';
}
