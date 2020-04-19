{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  name = "temper-${version}";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "creativeintent";
    repo = "temper";
    rev = "v${version}";
    sha256 = "0riv18m5pk28hih44lic929a8xslkqbwdnag207vpb35s0yq7q51";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  buildPhase = ''
    cd Dsp
    echo "Building jack standalone for temper"
    faust2jaqt -vec -time temper.dsp
    echo "Building lv2 for temper"
    faust2lv2 -vec -time temper.dsp
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2
    mv temper.lv2/ $out/lib/lv2
    mkdir -p $out/bin
    cp temper $out/bin/
  '';

  meta = {
    description = "Modern digital distortion plugin, bare bones version";
    longDescription = ''
      This is not the plugin as intended by the author, as it is not upsampled and doesn't have a GUI.
      It's a hack to get it to compile for jack and lv2, without the need for the unfree VST SDK and Juce.
  '';
    homepage = https://github.com/creativeintent/temper;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
