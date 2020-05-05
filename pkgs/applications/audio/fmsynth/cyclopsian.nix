{ stdenv, fetchFromGitHub, gtkmm3, lv2, lvtk-cyclopsian, pkgconfig }:
stdenv.mkDerivation {
  pname = "fmsynth-cyclopsian-unstable";
  version = "2019-02-13";

  src = fetchFromGitHub {
    owner = "cyclopsian";
    repo = "libfmsynth";
    rev = "82ed1f52de458f5199d01f20f8501f9d836db329";
    sha256 = "1v45x38hjgvxhwnhvnfn7i4q7cajwnj2smpfi90zplsd9bm4rcsv";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtkmm3 lv2 lvtk-cyclopsian ];

  buildPhase = ''
    cd lv2
    substituteInPlace GNUmakefile --replace "/usr/lib/lv2" "$out/lib/lv2"
    make  SIMD=0
  '';

  preInstall = "mkdir -p $out/lib/lv2";

  meta = {
    description = "a flexible 8 operator FM synthesizer for LV2";
    longDescription = ''
      The synth core supports:

      - Arbitrary amounts of polyphony
      - 8 operators
      - No fixed "algorithms"
      - Arbitrary modulation, every operator can modulate any other operator, even itself
      - Arbitrary carrier selection, every operator can be a carrier
      - Sine LFO, separate LFO per voice, modulates amplitude and frequency of operators
      - Envelope per operator
      - Carrier stereo panning
      - Velocity sensitivity per operator
      - Mod wheel sensitivity per operator
      - Pitch bend
      - Keyboard scaling
      - Sustain, sustained keys can overlap each other for a very rich sound
      - Full floating point implementation optimized for SIMD
      - Hard real-time constraints
    '';
    homepage = "https://github.com/cyclopsian/libfmsynth";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
