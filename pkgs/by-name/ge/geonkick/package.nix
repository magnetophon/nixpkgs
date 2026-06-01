{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  libsndfile,
  rapidjson,
  libjack2,
  lv2,
  libx11,
  cairo,
  openssl,
  validatePlugin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geonkick";
  version = "3.7.0";

  src = fetchFromGitLab {
    owner = "Geonkick-Synthesizer";
    repo = "geonkick";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8FfgtqFfiO1CKp2t0uXbXEtH6C1bx1EJWagjCfDwIwY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libsndfile
    rapidjson
    libjack2
    lv2
    libx11
    cairo
    openssl
  ];

  # Without this, the lv2 ends up in
  # /nix/store/$HASH/nix/store/$HASH/lib/lv2
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  passthru.tests = validatePlugin {
    plugin = finalAttrs.finalPackage;
    # plugin-torture can't instantiate geonkick (LV2 Options requirement).
    torture = false;
    lv2lintFlags = [
      # Redkite (Rk), the C++ widget toolkit geonkick's UI is built on; its
      # private symbols use the rk__ prefix and end up in the UI binary.
      "-s"
      "rk__*"
    ];
  };

  meta = {
    homepage = "https://gitlab.com/iurie-sw/geonkick";
    description = "Free software percussion synthesizer";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.magnetophon ];
    mainProgram = "geonkick";
  };
})
