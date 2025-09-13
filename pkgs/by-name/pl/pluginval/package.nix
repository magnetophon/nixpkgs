{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  gtk3,
  freetype,
  fontconfig,
  xorg,
  curl,
  webkitgtk_4_1,
  libsysprof-capture,
  pcre2,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libXdmcp,
  libdeflate,
  lerc,
  xz,
  libwebp,
  libxkbcommon,
  libepoxy,
  libXtst,
  sqlite,
  ladspaH,
}:
stdenv.mkDerivation rec {
  pname = "pluginval";
  version = "1.0.4";
  src = fetchFromGitHub {
    owner = "Tracktion";
    repo = "pluginval";
    rev = "v${version}";
    sha256 = "sha256-j4Lb3pcw0931o63OvTTaIm2UzvYDIjmnaCXGvKB4gwM=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    gtk3
    freetype
    fontconfig
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXinerama
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    curl
    webkitgtk_4_1
    libsysprof-capture
    pcre2
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    libXdmcp
    libdeflate
    lerc
    xz
    libwebp
    libxkbcommon
    libepoxy
    libXtst
    sqlite
    ladspaH
  ];
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Debug"
  ];
  installPhase = ''
    install -Dm755 pluginval_artefacts/Debug/pluginval $out/bin/pluginval
  '';
  meta = with lib; {
    description = "Cross-platform plugin validator and tester for audio plugins";
    homepage = "https://github.com/Tracktion/pluginval";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.unix;
    mainProgram = "pluginval";
  };
}
