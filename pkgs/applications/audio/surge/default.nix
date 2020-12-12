{ stdenv, fetchFromGitHub, cmake, git, pkg-config, python3
, cairo, libsndfile, libxcb, libxkbcommon, xcbutil, xcbutilcursor, xcbutilkeysyms, zenity
}:

stdenv.mkDerivation rec {
  pname = "surge";
  version = "unstable-2020-12-11";
  # version = "1.7.1";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = pname;
    # rev = "release_${version}";
    # sha256 = "1b3ccc78vrpzy18w7070zfa250dnd1bww147xxcnj457vd6n065s";
    rev = "dafcd600ce044c8d860660bee449b85fa047a98e";
    sha256 = "1agp1r19hgh96r31rqsis1ja0a64g5nic723grz382gnk4izwiw2";
    leaveDotGit = true; # for SURGE_VERSION
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake git pkg-config python3 ];
  buildInputs = [ cairo libsndfile libxcb libxkbcommon xcbutil xcbutilcursor xcbutilkeysyms zenity ];

  postPatch = ''
    substituteInPlace src/common/SurgeStorage.cpp --replace "/usr/share/Surge" "$out/share/surge"
    # substituteInPlace src/common/gui/PopupEditorDialog.cpp --replace '"zenity' '"${zenity}/bin/zenity'
    substituteInPlace src/linux/UserInteractionsLinux.cpp --replace '"zenity' '"${zenity}/bin/zenity'
    substituteInPlace vstgui.surge/vstgui/lib/platform/linux/x11fileselector.cpp --replace /usr/bin/zenity ${zenity}/bin/zenity
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/lib/vst3 $out/share/surge
    cp -r surge_products/Surge.lv2 $out/lib/lv2/
    cp -r surge_products/Surge.vst3 $out/lib/vst3/
    cp -r ../resources/data/* $out/share/surge/
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    cd ..
    build/surge-headless
  '';

  meta = with stdenv.lib; {
    description = "LV2 & VST3 synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon orivej ];
  };
}
