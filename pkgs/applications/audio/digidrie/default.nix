{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, alsa-lib
, freetype
, libjack2
, lv2
, libX11
, libXcursor
, libXext
, libXinerama
, libXrandr
, libGL
, libXdmcp
, gcc-unwrapped
, xcbutil
, xcb-util-cursor
, xcbutilrenderutil
, xcbutilkeysyms
, libxkbcommon
, xcbutilimage
, glib
, pcre
, cairo
, pango
, util-linuxMinimal # for libmount
, libselinux
, libsepol
, fribidi
, libthai
, libdatrie
, gtkmm3
, sqlite
, epoxy
, dbus
, at-spi2-core
, libXtst
}:

stdenv.mkDerivation rec {
  pname = "DigiDrie";
  version = "unstable-2022-07-30";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = pname;
    rev = "9e117242645d7957d8ef49ce86f06020c938be20";
    fetchSubmodules = true;
    sha256 = "sha256-zlioWlg/IIb90eOOYErrM9WvND0IPn99N59kbmsqhw8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    freetype
    libjack2
    lv2
    libX11
    libXcursor
    libXext
    libXdmcp
    libXinerama
    libXrandr
    libGL
    xcbutil
    xcb-util-cursor
    xcbutilrenderutil
    xcbutilkeysyms
    libxkbcommon
    xcbutilimage
    glib
    pcre
    cairo
    pango
    util-linuxMinimal # for libmount
    libselinux
    libsepol
    fribidi
    libthai
    libdatrie
    gtkmm3
    sqlite
    epoxy
    dbus
    at-spi2-core
    libXtst
  ];

  # JUCE dlopen's these at runtime, crashes without them
  NIX_LDFLAGS = (toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
  ]);

  cmakeFlags = [
    "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
    "-DCMAKE_NM=${gcc-unwrapped}/bin/gcc-nm"
  ];

  postPatch = ''
    # Needed to avoid /homeless-shelter error
    export HOME=$(mktemp -d)
# ~/source/DigiDrie/plugin/vst3sdk/cmake/modules/SMTG_SetupVST3LibraryDefaultPath.cmake
echo 22222222222222222222222222222222222222222222222222222222222222
echo $HOME
    cd plugin/
mkdir build
    patchShebangs vst3sdk/vstgui4/vstgui/uidescription/editing/createuidescdata.sh
cmake -S vst3sdk -B build               \
  -DCMAKE_BUILD_TYPE=Release            \
  -DSMTG_ADD_VST3_HOSTING_SAMPLES=False \
  -DSMTG_ADD_VST3_PLUGINS_SAMPLES=False \
  -DSMTG_CREATE_PLUGIN_LINK=True        \
  -DSMTG_MYPLUGINS_SRC_PATH="vst3"      \
  -DVSTGUI_ENABLE_XMLPARSER=False
patch \
  vst3sdk/vstgui4/vstgui/lib/platform/linux/cairocontext.cpp \
  patch/cairocontext.cpp.diff
'';

  installPhase = ''
    # mkdir -p $out/bin $out/lib/vst3
    # cd DigiDrie_artefacts/Release
    cp -r VST3/DigiDrie.vst3 $out/lib/vst3
    # cp -r Standalone/DigiDrie $out/bin
'';


  meta = with lib; {
    description = "A monster monophonic synth, written in faust";
    homepage = "https://github.com/magnetophon/DigiDrie";
    license = licenses.agpl3;
    maintainers = with maintainers; [ magnetophon ];
  };
}
