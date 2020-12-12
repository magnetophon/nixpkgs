{ stdenv, fetchurl, pkg-config, meson, ninja, libGLU, lv2, serd, sord, libX11, libXext, glew
, pname, version, sha256, description
, url ? "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-${version}.tar.xz"
, additionalBuildInputs ? []
, postPatch ? ""
, broken ? false
, ...
}:

stdenv.mkDerivation {
  inherit pname;

  inherit version;

  inherit postPatch;

  inherit description;

  inherit broken;

  src = fetchurl {
    url = url;
    sha256 = sha256;
  };
  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [
    lv2
    sord
    libX11
    libXext
    glew
  ]
  ++ additionalBuildInputs;

  meta = with stdenv.lib; {
    homepage    = "https://open-music-kontrollers.ch/lv2/${pname}:";
    license     = licenses.artistic2;
    maintainers = [ maintainers.magnetophon ];
    platforms = with platforms; all;
  };
}
