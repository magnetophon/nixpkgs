{ stdenv, fetchgit, pkgconfig, libjack2, liblo, libGL, libX11, lv2, fftw }:

stdenv.mkDerivation rec {
  pname = "uhhyou.lv2";
  version = "unstable-2020-05-27";

  src = fetchgit {
    url = "https://github.com/ryukau/LV2Plugins";
    rev = "f20d1c8a624d3a757f820b5c41c70f6f9bb6dc22";
    deepClone = true;
    sha256 = "12g9j4rrhkw91sbnqi8xg8wkl5j34m0l7fdwhqa2ny526n52lq7k";
  };

  buildInputs = [ libjack2 liblo libGL libX11 lv2 fftw ];

  nativeBuildInputs = [ pkgconfig ];

  # Temporary patch to DPF. See: https://github.com/DISTRHO/DPF/issues/216
  prePatch = ''
    # patchShebangs dpf/utils/generate-ttl.sh
    patchShebangs generate-ttl.sh
    cp patch/NanoVG.cpp lib/DPF/dgl/src/NanoVG.cpp
  '';

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/lib/lv2/
    mkdir -p $out/lib/lxvst/
    mkdir -p $out/bin
    cd bin
ls
    for lv2 in *.lv2; do
      mv $lv2 "$out/lib/lv2/"
    done;
    for lxvst in *.so; do
      mv $lxvst "$out/lib/lxvst/"
    done;
    mv * "$out/bin/"
  '';

  # installPhase = ''
  # mkdir -p $out/bin
  # mkdir -p $out/lib/lv2/
  # mkdir -p $out/lib/vst/
  # cd bin
  # for bin in ; do
  # cp -a $bin        $out/bin/
  # cp -a $bin-vst.so $out/lib/vst/
  # cp -a $bin.lv2/   $out/lib/lv2/ ;
  # done
  # '';

  meta = with stdenv.lib; {
    description = "Synth and FX plugins for LV2";
    longDescription = ''
      Plugin List:
      - CubicPadSynth
      - EnvelopedSine
      - EsPhaser
      - FDNCymbal
      - IterativeSinCluster
      - LatticeReverb
      - LightPadSynth
      - SevenDelay
      - SyncSawSynth
      - TrapezoidSynth
      - WaveCymbal
    '';
    homepage = "https://github.com/ryukau/LV2Plugins/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
