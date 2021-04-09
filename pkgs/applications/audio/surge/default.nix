{ stdenv, fetchurl, fetchFromGitHub, cmake, git, pkg-config, python3
, cairo, libsndfile, libxcb, libxkbcommon, xcbutil, xcbutilcursor, xcbutilkeysyms, zenity
, curl, rsync
}:

stdenv.mkDerivation rec {
  pname = "surge";
  # version = "1.8.1";
  version = "unstable-2021-04-08";

  # src = fetchurl {
  # url = "https://github.com/surge-synthesizer/releases/releases/download/${version}/SurgeSrc_${version}.tgz";
  # sha256 = "1nakblkrig10816ixmhlb6wcfj1ki1wx7k68qnanbpdw0wmwy7y2";
  # };

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    rev = "d20cbe49e25906dd9de33da1c1e0ec8aa6635623";
    sha256 = "1wgymjfvj3shhvhx139hlrihmmnnd0cn6im6arz18d5jsy539dlz";
    leaveDotGit = true;
    fetchSubmodules = true;
  };

  extraContent = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge-extra-content";
    # rev from: https://github.com/surge-synthesizer/surge/blob/release_1.8.1/cmake/stage-extra-content.cmake#L6
    # SURGE_EXTRA_CONTENT_HASH
    rev = "a4265856ae98f34a5b4e38ce8f36d29b646f56ec";
    sha256 = "119b55h7prw3id5fnpgc3zpildddnr7r48glzczcp65v7qawxi4y";
  };
  nativeBuildInputs = [ cmake git pkg-config python3 ];
  buildInputs = [ cairo libsndfile libxcb libxkbcommon xcbutil xcbutilcursor xcbutilkeysyms zenity curl rsync ];

  postPatch = ''
    substituteInPlace src/common/SurgeStorage.cpp --replace "/usr/share/Surge" "$out/share/surge"
    substituteInPlace src/linux/UserInteractionsLinux.cpp --replace '"zenity' '"${zenity}/bin/zenity'
    patchShebangs scripts/linux/
    # cp -r $extraContent/Skins/ resources/data/skins
  '';


  installPhase = ''
    cd ..
    cmake --build build --config Release --target install-everything-global
  '';

  doInstallCheck = true;
  installCheckPhase = ''
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
