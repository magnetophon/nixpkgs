{ stdenv, ffmpeg }:

stdenv.mkDerivation {
  name = "ffmpeg_harvid";

  buildInputs = [ ffmpeg ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin/
    ln -s ${stdenv.lib.makeBinPath [ ffmpeg ]}/ffmpeg $out/bin/ffmpeg_harvid
    ln -s ${stdenv.lib.makeBinPath [ ffmpeg ]}/ffprobe $out/bin/ffprobe_harvid
  '';

  meta = with stdenv.lib; {
    description = "A link to ffmpeg 2 under a different name, needed for Ardour format conversion";
    longDescription = ''
      Two binaries called ffmpeg_harvid and ffprobe_harvid are part of http://x42.github.io/harvid/,
      which Ardpour uses for it's video timeline, but also some other file format conversions.
      If you don't need the video timeline, this pkg will enable format conversion.
    '';
    license = licenses.gpl3;
    maintainers = [ maintainers.magnetophon ];
  };
}
