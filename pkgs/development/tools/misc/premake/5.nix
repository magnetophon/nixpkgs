{ stdenv, fetchFromGitHub, Foundation, readline }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "premake5";
  version = "5.0.0-alpha14";

  src = fetchFromGitHub {
    owner = "premake";
    repo = "premake-core";
    rev = "v${version}";
    sha256 = "15pbx08l8549m2vqn1ild2ckc27awcp4741dchqzff9g24zbxiq0";
    fetchSubmodules = true;
  };

  buildInputs = optionals stdenv.isDarwin [ Foundation readline ];

  patchPhase = optional stdenv.isDarwin ''
    substituteInPlace premake5.lua \
      --replace -mmacosx-version-min=10.4 -mmacosx-version-min=10.5
  '';

  buildPhase =
    if stdenv.isDarwin then ''
       make -f Bootstrap.mak osx
    '' else ''
       make -f Bootstrap.mak linux
    '';

  installPhase = ''
    install -Dm755 bin/release/premake5 $out/bin/premake5
  '';

  premake_cmd = "premake5";
  setupHook = ./setup-hook.sh;

  meta = {
    homepage = https://premake.github.io;
    description = "A simple build configuration and project generation tool using lua";
    license = stdenv.lib.licenses.bsd3;
    platforms = platforms.darwin ++ platforms.linux;
  };
}
