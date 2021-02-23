{ stdenv
, alsaLib
, fetchFromGitHub
, freetype
, libGL
, libX11
, libXcursor
, libXext
, libXrender
, meson
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "distrho-ports";
  version = "2021-01-15";

  src = fetchFromGitHub {
    owner = "DISTRHO";
    repo = "DISTRHO-Ports";
    rev = "a420f376b8f4891b421b058e7dc971243a54e264";
    sha256 = "1zliq9ppjnvji74yg7hwkz9zxf9gjhd8002cqav23azd644k5ikd";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];

  buildInputs = [
      alsaLib
      freetype
      libGL
      libX11
      libXcursor
      libXext
      libXrender
  ];

  meta = with stdenv.lib; {
    homepage = "http://distrho.sourceforge.net/ports";
    description = "Linux audio plugins and LV2 ports";
    longDescription = ''
      Includes:
        arctican-function
        arctican-pilgrim
        dexed
        drowaudio-distortion
        drowaudio-distortionshaper
        drowaudio-flanger
        drowaudio-reverb
        drowaudio-tremolo
        drumsynth
        easySSP
        eqinox
        HiReSam
        juce-opl
        klangfalter
        LUFSMeter
        LUFSMeter-Multi
        luftikus
        obxd
        pitchedDelay
        refine
        stereosourceseparation
        tal-dub-3
        tal-filter
        tal-filter-2
        tal-noisemaker
        tal-reverb
        tal-reverb-2
        tal-reverb-3
        tal-vocoder-2
        temper
        vex
        wolpertinger
    '';
    license = with licenses; [ gpl2 gpl3 gpl2Plus lgpl3 mit ];
    maintainers = [ maintainers.goibhniu ];
    platforms = [ "x86_64-linux" ];
  };
}
