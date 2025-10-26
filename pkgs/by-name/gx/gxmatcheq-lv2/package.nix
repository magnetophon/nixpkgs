{
  lib,
  stdenv,
  gcc13Stdenv,
  fetchFromGitHub,
  xorg,
  xorgproto,
  cairo,
  lv2,
  pkg-config,
}:
let
  # see: https://github.com/brummer10/GxMatchEQ.lv2/issues/8
  # Use gcc13 on Linux, but default stdenv (clang) on Darwin since gcc13 doesn't build there
  buildStdenv = if stdenv.isDarwin then stdenv else gcc13Stdenv;
in
buildStdenv.mkDerivation rec {
  pname = "GxMatchEQ.lv2";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "brummer10";
    repo = "GxMatchEQ.lv2";
    rev = "V${version}";
    sha256 = "0azdmgzqwjn26nx38iw13666a1i4y2bv39wk89pf6ihdi46klf72";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorg.libX11
    xorgproto
    cairo
    lv2
  ];

  # error: format not a string literal and no format arguments [-Werror=format-security]
  hardeningDisable = [ "format" ];

  installFlags = [ "INSTALL_DIR=$(out)/lib/lv2" ];

  meta = with lib; {
    homepage = "https://github.com/brummer10/GxMatchEQ.lv2";
    description = "Matching Equalizer to apply EQ curve from one source to another source";
    maintainers = [ maintainers.magnetophon ];
    license = licenses.gpl3;
  };
}
