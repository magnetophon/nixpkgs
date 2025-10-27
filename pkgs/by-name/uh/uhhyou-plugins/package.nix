{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cairo,
  fontconfig,
  freetype,
  libxcb,
  xcbutil,
  xorg,
  xcbutilkeysyms,
  libxkbcommon,
  libX11,
  libXrandr,
  libXinerama,
  libXcursor,
  pango,
  gtkmm3,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "uhhyou-plugins";
  version = "0.67.0";
  src = fetchFromGitHub {
    owner = "ryukau";
    repo = "VSTPlugins";
    rev = "UhhyouPlugins${version}";
    hash = "sha256-8YGfcnWkOQwwq6m3510GPpZu6UbDmVi3K/dOGLrAnhM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cairo
    fontconfig
    freetype
    libxcb
    xcbutil
    xorg.xcbutilcursor
    xcbutilkeysyms
    libxkbcommon
    libX11
    libXrandr
    libXinerama
    libXcursor
    pango
    gtkmm3
    sqlite
  ];

  postPatch = ''
    patch -p1 -d lib/vst3sdk/vstgui4/ < ${./cairographicscontext.patch}
    patchShebangs lib/vst3sdk/vstgui4/vstgui/uidescription/editing/createuidescdata.sh
    export HOME=$TMPDIR
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/vst3
    cp -r VST3/Release/*.vst3 $out/lib/vst3/

    runHook postInstall
  '';

  meta = {
    description = "Collection of VST3 audio synthesis and processing plugins.";
    homepage = "https://github.com/ryukau/VSTPlugins";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
