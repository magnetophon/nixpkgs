{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, alsa-lib
, freetype
, libjack2
, lv2
, libX11
, libXcursor
, libXext
, libXinerama
, libXrandr
}:

stdenv.mkDerivation rec {
  pname = "monique-monosynth";
  version = "unstable-2021-12-18";
  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "monique-monosynth";
    rev = "d175dbb037f3c477e59db0cc8d4a50e349e5e10f";
    sha256 = "sha256-GswWnp7btJkj2kbAnvzqmwHJS1Cuvpz2cgfYcL8Jd20=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    freetype
    libjack2
    lv2
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
  ];

  # Ignore undefined references to a bunch of libsoup symbols
  NIX_LDFLAGS = "--unresolved-symbol=ignore-all";

  installPhase = ''
    mkdir -p $out/lib/vst3
    cp -r MoniqueMonosynth_artefacts/Release/VST3/MoniqueMonosynth.vst3 $out/lib/vst3
  '';

  meta = {
    description = "A monophonic synth plugin";
    homepage = "https://github.com/surge-synthesizer//monique";

    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
