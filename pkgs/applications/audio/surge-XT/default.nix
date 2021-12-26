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
}:

let
  juce-lv2 = stdenv.mkDerivation {
    pname = "juce-lv2";
    version = "unstable-2021-12-11";

    # lv2 branch
    src = fetchFromGitHub {
      owner = "lv2-porting-project";
      repo = "JUCE";
      # see https://github.com/lv2-porting-project/JUCE/issues/18
      # rev = "c5174d84fdb12e2233ec3c502fb6a9c54ed87a9f";
      # sha256 = "sha256-jwWDB0XXaKkHJDNOSnhV4tDd+2lt61Qp8gFwXDuY63c=";
      # see https://github.com/lv2-porting-project/JUCE/issues/18#issuecomment-1001005528
      # rev = "13e817f41f381a72a788618852f9c6799c9a9711";
      # sha256 = "sha256-RNS/CahCWT56n8dReAnMUFAtjZ5jJRvJtecrIgiW8fI=";
      # see https://github.com/lv2-porting-project/JUCE/issues/18?notification_referrer_id=NT_kwDOAHSqD7IyODY2NjgyNDQ2Ojc2NDU3MTE&notifications_query=is%3Aunread#issuecomment-1001152634
      rev = "936a26d4beb49529d68f3c67765d783dc2de4e62";
      sha256 = "sha256-XtLN77GZadKNE5ZfifrvcWIfql15z5KfXzyGYH9/M+c=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      cp -r . $out
    '';
  };
in
stdenv.mkDerivation rec {
  pname = "surge-XT";
  version = "unstable-2021-12-24";

  src = fetchFromGitHub {
    owner = "surge-synthesizer";
    repo = "surge";
    rev = "74164850e53d4891083a1055da5de538bad6f0a1";
    fetchSubmodules = true;
    sha256 = "sha256-SN1m7BWvLQ7EtaNpfZZ8JB9fHDkd9fa6txAoJvjZpBI=";
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
    libXinerama
    libXrandr
  ];

  cmakeFlags = [
    "-DJUCE_SUPPORTS_LV2=ON"
    "-DSURGE_JUCE_PATH=${juce-lv2}"
  ];

  # JUCE dlopen's these at runtime, crashes without them
  NIX_LDFLAGS = (toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
    "-ljack -L${libjack2}"
  ]);

  # see https://github.com/NixOS/nixpkgs/pull/149487#issuecomment-991747333
  postPatch = ''
    export XDG_DOCUMENTS_DIR=$(mktemp -d)
  '';

  meta = with lib; {
    description = "LV2 & VST3 synthesizer plug-in (previously released as Vember Audio Surge)";
    homepage = "https://surge-synthesizer.github.io";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ magnetophon orivej ];
  };
}
