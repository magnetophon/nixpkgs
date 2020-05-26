{ stdenv, fetchFromGitHub,  zita-resampler, lv2 }:

stdenv.mkDerivation rec {
  pname = "tamgamp.lv2";
  version = "unstable-2020-05-14";

  src = fetchFromGitHub {
    owner = "sadko4u";
    repo = pname;
    rev = "590ced0a1da96ca481a1a719eebdb17f3af472e4";
    sha256 = "0yqdhbxsx2h1w1wwf7db7a7w9dkqmnd9c2visiznmcl9chinyhiq";
  };

  buildInputs = [
    zita-resampler lv2
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/sadko4u/tamgamp.lv2;
    description = "Guitar amplifier simulator";
    longDescription = ''
       Tamgamp (Pronouncement: "Damage Amp") is an LV2 guitar amp simulator that provides two plugins:

        - Tamgamp - a plugin based on Guitarix DK Builder simulated chains.
        - TamgampGX - a plugin based on tuned Guitarix internal amplifiers implementation.

       The reference to the original Guitarix project: https://guitarix.org/

       It simulates the set of the following guitar amplifiers:

       - Fender Princeton Reverb-amp AA1164 (without reverb module)
       - Fender Twin Reverb-Amp AA769 (Normal channel, bright off)
       - Fender Twin Reverb-Amp AA769 (Vibrato channel, bright on)
       - Marshall JCM-800 High-gain input
       - Marshall JCM-800 Low-gain input
       - Mesa/Boogie DC3 preamplifier (lead channel)
       - Mesa/Boogie DC3 preamplifier (rhythm channel)
       - Mesa Dual Rectifier preamplifier (orange channel, less gain)
       - Mesa Dual Rectifier preamplifier (red channel, more gain)
       - Peavey 5150II crunch channel
       - Peavey 5150II lead channel
       - VOX AC-30 Brilliant channel
       - VOX AC-30 normal channel
     '';
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
