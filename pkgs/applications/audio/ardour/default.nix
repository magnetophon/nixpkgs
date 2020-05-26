{ stdenv, fetchgit, alsaLib, aubio, boost, cairomm, curl, doxygen
, fftwSinglePrec, flac, glibc, glibmm, graphviz, gtkmm2, libjack2
, liblo, libogg, readline, itstool
, librdf_raptor, librdf_rasqal, libsamplerate, libsigcxx, libsndfile
, libusb, libuuid, libxml2, libxslt, lilv, lrdf, lv2, makeWrapper
, perl, pkgconfig, pulseaudio, python, rubberband, serd, sord, sratom
, taglib, vamp-plugin-sdk, dbus, fftw, pango, suil, libarchive
, wafHook }:

let

  # Ardour git repo uses a mix of annotated and lightweight tags. Annotated
  # tags are used for MAJOR.MINOR versioning, and lightweight tags are used
  # in-between; MAJOR.MINOR.REV where REV is the number of commits since the
  # last annotated tag. A slightly different version string format is needed
  # for the 'revision' info that is built into the binary; it is the format of
  # "git describe" when _not_ on an annotated tag(!): MAJOR.MINOR-REV-HASH.

  # Version to build.
  tag = "6.0";

in

stdenv.mkDerivation rec {
  name = "ardour6-${tag}";

  src = fetchgit {
    url = "git://git.ardour.org/ardour/ardour.git";
    rev = "360c81b815efe1e7b117ad6f96f8493f675d51bf";
    sha256 = "162jd96zahl05fdmjwvpdfjxbhd6ifbav6xqa0vv6rsdl4zk395q";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ wafHook ];
  buildInputs =
    [ alsaLib aubio boost cairomm curl doxygen dbus fftw fftwSinglePrec flac
      glibmm graphviz gtkmm2 libjack2 liblo readline itstool
      libogg librdf_raptor librdf_rasqal libsamplerate
      libsigcxx libsndfile libusb libuuid libxml2 libxslt lilv lrdf lv2
      makeWrapper pango perl pkgconfig pulseaudio python rubberband serd sord
      sratom suil taglib vamp-plugin-sdk libarchive
    ];

  # ardour's wscript has a "tarball" target but that required the git revision
  # be available. Since this is an unzipped tarball fetched from github we
  # have to do that ourself.
  patchPhase = ''
    printf '#include "libs/ardour/ardour/revision.h"\nnamespace ARDOUR { const char* revision = "6.0"; const char* date = "2020-05-23"; }\n' > libs/ardour/revision.cc
    sed 's|/usr/include/libintl.h|${glibc.dev}/include/libintl.h|' -i wscript
    patchShebangs ./tools/
    sed "382 s/mingw/x86_64/" -i libs/ardour/wscript
    '';

  wafConfigureFlags = [
    "--optimize"
    "--docs"
    "--with-backends=jack,alsa,pulseaudio,dummy"
    "--cxx11"
    "--freedesktop"
    "--ptformat"
    "--no-phone-home"
  ];

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
      https://community.ardour.org/donate
    '';
    homepage = http://ardour.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.fps ];
  };
}
