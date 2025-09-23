{
  rustPlatform,
  fetchFromGitHub,
  lib,
  libxkbcommon,
  libGL,
  wayland,
  xorg,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ringboard";

  # release version needs nightly, so we use a custom tree, see:
  # https://github.com/SUPERCILEX/clipboard-history/issues/22#issuecomment-3322075172
  version = "unstable-2025-09-23";

  src = fetchFromGitHub {
    owner = "SUPERCILEX";
    repo = "clipboard-history";
    rev = "228a39dd8a9aece0bb06f68ad44906b297270628";
    hash = "sha256-qA7wwvWnnZHN9edkmubEo37F+peU0LQGo/Zl8FpywuE=";
  };

  cargoHash = "sha256-MFfuUu/hpb6Uaqe21bvXNKRyJazAL5m+Vw/vAeeDYEk=";

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    libxkbcommon
    libGL

    # WINIT_UNIX_BACKEND=wayland
    wayland

    # WINIT_UNIX_BACKEND=x11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libX11
  ];

  buildPhase = ''
     runHook preBuild

    local flagsArray=("-j $NIX_BUILD_CORES --target x86_64-unknown-linux-gnu --offline --release");
    concatTo flagsArray cargoBuildFlags;

    echo "Building package: clipboard-history-server"
    cargo build $flagsArray --package clipboard-history-server --no-default-features --features systemd
    echo "Building package: clipboard-history-x11"
    cargo build $flagsArray --package clipboard-history-x11 --no-default-features
    echo "Building package: clipboard-history-wayland"
    cargo build $flagsArray --package clipboard-history-wayland --no-default-features
    echo "Building package: clipboard-history"
    cargo build $flagsArray --package clipboard-history
    echo "Building package: clipboard-history-tui"
    cargo build $flagsArray --package clipboard-history-tui
    echo "Building package: clipboard-history-egui"
    cargo build $flagsArray --package clipboard-history-egui

     runHook postBuild
  '';

  # check needs nightly, see:
  # https://github.com/SUPERCILEX/clipboard-history/issues/22#issuecomment-3322330559
  doCheck = false;

  postInstall = ''
    wrapProgram  $out/bin/ringboard-egui --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"
    install -m 444 -D egui/ringboard-egui.desktop $out/share/applications/ringboard-egui.desktop
    install -Dm644 logo.jpeg -t $out/share/icons/hicolor/1024x1024/
    sed -i "s|Exec=ringboard-egui|Exec=$(echo /bin/sh -c \"ps -p \`cat /tmp/.ringboard/\$USER.egui-sleep 2\> /dev/null\` \> /dev/null 2\>\\\&1 \\\&\\\& exec rm -f /tmp/.ringboard/\$USER.egui-sleep \\\|\\\| exec $out/bin/ringboard-egui\")|g" $out/share/applications/ringboard-egui.desktop
    sed -i "s|Icon=ringboard|Icon=$out/share/icons/hicolor/1024x1024/logo.jpeg|g" $out/share/applications/ringboard-egui.desktop
  '';

  meta = {
    description = "A fast, efficient, and composable clipboard manager for Linux";
    homepage = "https://github.com/SUPERCILEX/clipboard-history";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.magnetophon ];
  };
})
