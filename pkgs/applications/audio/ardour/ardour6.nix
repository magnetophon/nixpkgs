{ stdenv, fetchgit, alsaLib, aubio, boost, cairomm, curl, doxygen
, fftwSinglePrec, flac, glibc, glibmm, graphviz, gtkmm2, libjack2
, liblo, libogg, readline, webkit
, librdf_raptor, librdf_rasqal, libsamplerate, libsigcxx, libsndfile
, libusb, libuuid, libxml2, libxslt, lilv, lrdf, lv2, makeWrapper
, perl, pkgconfig, python, rubberband, serd, sord, sratom
, taglib, vamp-plugin-sdk, dbus, fftw, pango, suil, libarchive
, wafHook }:

# 'cppunit' >= 1.12.0                     : not found
# Checking for 'libwebsockets' >= 2.0.0                : not found
# Checking for 'lv2' >= 1.17.2                         : not found
#  * Build documentation                               : False
#  * Beatbox test app                                  : False
#  * Freedesktop files                                 : False
#  * Lua Binding Doc                                   : False
#  * Process thread timing                             : False
#
#(15:12:50) rgareus: magnetophon: That's odd, I have only seen this with windows asm. The "-D" flag is not ignored but used for debug, message so all the defined -DHAVE_..  -> "H" is passed on.
# (15:13:56) rgareus: magnetophon: the solution on GNU/Linux is to use a GNU asbm.   -> man 1 as  "-D  Ignored."
# (15:15:32) rgareus: magnetophon: alternatively try https://github.com/Ardour/ardour/blob/master/libs/ardour/wscript#L383  (remove the condition to use it only for windows)

let

  # Ardour git repo uses a mix of annotated and lightweight tags. Annotated
  # tags are used for MAJOR.MINOR versioning, and lightweight tags are used
  # in-between; MAJOR.MINOR.REV where REV is the number of commits since the
  # last annotated tag. A slightly different version string format is needed
  # for the 'revision' info that is built into the binary; it is the format of
  # "git describe" when _not_ on an annotated tag(!): MAJOR.MINOR-REV-HASH.

  # Version to build.
  tag = "6.0-unstable-2020-04-15";

in

stdenv.mkDerivation rec {
  name = "ardour6-${tag}";

  src = fetchgit {
    url = "git://git.ardour.org/ardour/ardour.git";
    rev = "9fac6139ea40ee2ba5af1415c302c61fee6a13aa";
    sha256 = "0g5hbgr0wphc2x42vv2q6as4ngxc5q4h5gxgd3gblkcgipmybnhb";
  };

  nativeBuildInputs = [ wafHook ];
  buildInputs =
    [ alsaLib aubio boost cairomm curl doxygen dbus fftw fftwSinglePrec flac
      glibmm graphviz gtkmm2 libjack2 liblo readline webkit
      libogg librdf_raptor librdf_rasqal libsamplerate
      libsigcxx libsndfile libusb libuuid libxml2 libxslt lilv lrdf lv2
      makeWrapper pango perl pkgconfig python rubberband serd sord
      sratom suil taglib vamp-plugin-sdk libarchive
    ];

  # ardour's wscript has a "tarball" target but that required the git revision
  # be available. Since this is an unzipped tarball fetched from github we
  # have to do that ourself.
  patchPhase = ''
    printf '#include "libs/ardour/ardour/revision.h"\nnamespace ARDOUR { const char* revision = "6.0-pre1-212-g7434478a35"; const char* date = "2020-04-08"; }\n' > libs/ardour/revision.cc
cat wscript | grep libintl
    sed 's|/usr/include/libintl.h|${glibc.dev}/include/libintl.h|' -i wscript
cat wscript | grep libintl
    patchShebangs ./tools/
  '';

  wafConfigureFlags = [
    "--optimize"
    "--docs"
    "--with-backends=jack,alsa,dummy"
  ];
  # preConfigure = ''
  # patchShebangs waf
  # cat wscript
  # ./waf configure
  # '';

  postInstall = ''
    # Install desktop file
    mkdir -p "$out/share/applications"
    cat > "$out/share/applications/ardour.desktop" << EOF
    [Desktop Entry]
    Name=Ardour 6
    GenericName=Digital Audio Workstation
    Comment=Multitrack harddisk recorder
    Exec=$out/bin/ardour6
    Icon=$out/share/ardour6/resources/Ardour-icon_256px.png
    Terminal=false
    Type=Application
    X-MultipleArgs=false
    Categories=GTK;Audio;AudioVideoEditing;AudioVideo;Video;
    EOF
  '';

  meta = with stdenv.lib; {
    description = "Multi-track hard disk recording software";
    longDescription = ''
      Ardour is a digital audio workstation (DAW), You can use it to
      record, edit and mix multi-track audio and midi. Produce your
      own CDs. Mix video soundtracks. Experiment with new ideas about
      music and sound.

      Please consider supporting the ardour project financially:
      https://community.ardour.org/node/8288
    '';
    homepage = http://ardour.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.fps ];
  };
}
