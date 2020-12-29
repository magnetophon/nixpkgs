{ stdenv, fetchFromGitHub, cmake, git, pkg-config, python3
, cairo, libsndfile, libxcb, libxkbcommon, xcbutil, xcbutilcursor, xcbutilkeysyms, zenity
, curl
}:

stdenv.mkDerivation rec {
  pname = "surge";
  #
  # version = "unstable-2020-12-23";
  # rev = "42c50f83d885bbe719df5999063cd12d13b6e97f";
  # sha256 = "07y0ni701ia6zn34aaj8wbzdz4s3qzxvb0p83mjs86xq3lyfm1kw";
  #
  # version = "1.7.1";
  # rev = "release_${version}";
  # sha256 = "1b3ccc78vrpzy18w7070zfa250dnd1bww147xxcnj457vd6n065s";
  #
  #https://github.com/surge-synthesizer/surge/commit/b97c6842bacf8375b7d981b7639710294bd331a4
  #
  #
  # for ardour song digita||atino
  # version = "unstable-2020-12-17";
  # rev = "dbdad6c927c1912cb0ee1d31cd593fcdc52ff8b1";
  # sha256 = "0a39m6mmnyhy30a7srghqmk9ndkacs9haxmn4y52ab4sb3qj09k3";

  version = "unstable-2020-12-29";
  # version = "unstable-2020-12-17";
  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = pname;
    # rev = "dbdad6c927c1912cb0ee1d31cd593fcdc52ff8b1";
    # sha256 = "0a39m6mmnyhy30a7srghqmk9ndkacs9haxmn4y52ab4sb3qj09k3";
    rev = "c70d689d55697f3cd5a40f8315c810bffd73ef12";
    sha256 = "02s6jfwc481wc1kqhjvgagzp07gl9sx1lc0xgrj0g6iggy25k6pg";
    leaveDotGit = true; # for SURGE_VERSION
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake git pkg-config python3 ];
  buildInputs = [ cairo libsndfile libxcb libxkbcommon xcbutil xcbutilcursor xcbutilkeysyms zenity curl ];

  postPatch = ''
    substituteInPlace src/common/SurgeStorage.cpp --replace "/usr/share/Surge" "$out/share/surge"
    # substituteInPlace src/common/gui/PopupEditorDialog.cpp --replace '"zenity' '"${zenity}/bin/zenity'
    # substituteInPlace src/linux/UserInteractionsLinux.cpp --replace '"zenity' '"${zenity}/bin/zenity'
    # substituteInPlace vstgui.surge/vstgui/lib/platform/linux/x11fileselector.cpp --replace /usr/bin/zenity ${zenity}/bin/zenity
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
    export HOME=$(mktemp -d)
    export SURGE_DISABLE_NETWORK_TESTS=TRUE
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
