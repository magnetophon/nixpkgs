{ stdenv, fetchurl, fetchFromGitHub, cmake, git, pkg-config, python3
, cairo, libsndfile, libxcb, libxkbcommon, xcbutil, xcbutilcursor, xcbutilkeysyms, zenity
, curl, rsync
}:

stdenv.mkDerivation rec {
  pname = "surge";
  version = "1.8.0";

  src = fetchurl {
    url = "https://github.com/surge-synthesizer/releases/releases/download/${version}/SurgeSrc_${version}.tgz";
    sha256 = "1rk7lpiflp1269g7zic74h29rcjiq10yycnx9r82nzi124navpay";
  };

  extraContent = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge-extra-content";
    # rev from: https://github.com/surge-synthesizer/surge/blob/release_1.8.0/cmake/stage-extra-content.cmake#L6
    # SURGE_EXTRA_CONTENT_HASH
    rev = "a4265856ae98f34a5b4e38ce8f36d29b646f56ec";
    sha256 = "119b55h7prw3id5fnpgc3zpildddnr7r48glzczcp65v7qawxi4y";
    };
  nativeBuildInputs = [ cmake git pkg-config python3 ];
  buildInputs = [ cairo libsndfile libxcb libxkbcommon xcbutil xcbutilcursor xcbutilkeysyms zenity curl rsync ];

  postPatch = ''
    substituteInPlace src/common/SurgeStorage.cpp --replace "/usr/share/Surge" "$out/share/surge"
    substituteInPlace src/linux/UserInteractionsLinux.cpp --replace '"zenity' '"${zenity}/bin/zenity'
    cp -r $extraContent/Skins/ resources/data/skins
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
