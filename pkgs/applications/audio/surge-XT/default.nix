{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, cairo, libxkbcommon, xcbutilcursor, xcbutilkeysyms, xcbutil, libXrandr, libXinerama, libXcursor, alsa-lib, libjack2
}:

stdenv.mkDerivation rec {
  pname = "surge-XT";
  version = "unstable-2021-09-04";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    rev = "364cf98c13512560f60bb03db6103b60974d4353";
    sha256 = "160h0kyp56x1awjwi3zw9zwpa6f2mdh2p03jps0kxgqw974cbqwa";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ cairo libxkbcommon xcbutilcursor xcbutilkeysyms xcbutil libXrandr libXinerama libXcursor alsa-lib libjack2 ];

  installPhase = ''
    cd ..
    cmake --build build --config Release --target install
  '';

  doInstallCheck = false;

  meta = with lib; {
    description = "LV2 & VST3 synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon orivej ];
  };
}
