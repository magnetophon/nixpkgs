{ stdenv, fetchurl, pkg-config, meson, ninja, libGLU, lv2, serd, sord, libX11, libXext, glew
, pname, version, src, description
, additionalBuildInputs ? []
, postPatch ? ""
, ...
}:

stdenv.mkDerivation {
  inherit pname;

  inherit version;

  inherit src;

  inherit postPatch;

  inherit description;

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
