{ stdenv, fetchFromGitHub, makeWrapper, autoreconfHook, pkgconfig, MMA, libjack2, libsmf, python2Packages }:

let
  inherit (python2Packages) pyGtkGlade pygtksourceview python;
in stdenv.mkDerivation rec {
  pname = "linuxband";
  version = "unstable-2020-02-23";
  # version = "12.02.1";

  # src = fetchurl {
  # url = "http://linuxband.org/assets/sources/${pname}-${version}.tar.gz";
  # sha256 = "1r71h4yg775m4gax4irrvygmrsclgn503ykmc2qwjsxa42ri4n2n";
  # };

  src = fetchFromGitHub {
    owner = "noseka1";
    repo = pname;
    rev = "e5459ccc75feaa9bd03d3a0d74af1b81f62825ce";
    sha256 = "0mlxrrz1c0qbpbx1y5ilkl33mdv6smwxj7l7n89j6bh6462lzpmf";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ makeWrapper MMA libjack2 libsmf python pyGtkGlade pygtksourceview ];

  patchPhase = ''
    sed -i 's@/usr/@${MMA}/@g' src/main/config/linuxband.rc.in
    # cat src/main/config/linuxband.rc.in
ls
cat autogen.sh
  '';

  # preConfigure = "autoreconf --install";

  postFixup = ''
    PYTHONPATH=$pyGtkGlade/share/:pygtksourceview/share/:$PYTHONPATH
    for f in $out/bin/*; do
      wrapProgram $f \
      --prefix PYTHONPATH : $PYTHONPATH
    done
  '';

  meta = {
    description = "A GUI front-end for MMA: Type in the chords, choose the groove and it will play an accompaniment";
    homepage = "http://linuxband.org/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
