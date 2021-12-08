{
  stdenv
, fetchFromGitHub
, fetchzip
, freetype
, jansson
, lib
, libGL
, libX11
, libXcursor
, libXext
, libarchive
, libsamplerate
, pkg-config
, speexdsp
, libXrandr
, liblo
, mesa
, python3
}:

let
  # The package repo vendors some of the package dependencies as submodules.
  # Others are downloaded with `make deps`. Due to previous issues with the
  # `glfw` submodule (see above) and because we can not access the network when
  # building in a sandbox, we fetch the dependency source manually.
  pfft-source = fetchzip {
    url = "https://vcvrack.com/downloads/dep/pffft.zip";
    sha256 = "084csgqa6f1a270bhybjayrh3mpyi2jimc87qkdgsqcp8ycsx1l1";
  };
  nanovg-source = fetchFromGitHub {
    owner = "memononen";
    repo = "nanovg";
    rev = "1f9c8864fc556a1be4d4bf1d6bfe20cde25734b4";
    sha256 = "08r15zrr6p1kxigxzxrg5rgya7wwbdx7d078r362qbkmws83wk27";
  };
  nanosvg-source = fetchFromGitHub {
    owner = "memononen";
    repo = "nanosvg";
    rev = "25241c5a8f8451d41ab1b02ab2d865b01600d949";
    sha256 = "114qgfmazsdl53rm4pgqif3gv8msdmfwi91lyc2jfadgzfd83xkg";
  };
  osdialog-source = fetchFromGitHub {
    owner = "AndrewBelt";
    repo = "osdialog";
    rev = "e5db5de6444f4b2c4e1390c67b3efd718080c3da";
    sha256 = "0iqxn1md053nl19hbjk8rqsdcmjwa5l5z0ci4fara77q43rc323i";
  };
  oui-blendish-source = fetchFromGitHub {
    owner = "AndrewBelt";
    repo = "oui-blendish";
    rev = "79ec59e6bc7201017fc13a20c6e33380adca1660";
    sha256 = "17kd0lh2x3x12bxkyhq6z8sg6vxln8m9qirf0basvcsmylr6rb64";
  };
  QuickJS-source = fetchFromGitHub {
    owner = "JerrySievert";
    repo = "QuickJS";
    rev = "b70d5344013836544631c361ae20569b978176c9";
    sha256 = "sha256-hSWOGTmTJgtHVSBlEpv7w1qiyTgoAI1d7bQ66q59mik=";
  };
in

stdenv.mkDerivation rec {
  name = "cardinal-${version}";
  version = "unstable-2021-12-08";

  src = fetchFromGitHub {
    owner = "DISTRHO";
    repo = "cardinal";
    rev = "1304a16f7361e0babb8e8af1954e313be504a8a1";
    sha256 = "sha256-RNkUcn2y9C/bZVqvHKMkL8AZPzWNRTnwOHRCm2JFTuE=";
    fetchSubmodules = true;
  };

  prePatch = ''
    # As we can't use `make dep` to set up the dependencies (as explained
    # above), we do it here manually
    mkdir -p src/Rack/dep/include

    cp -r ${pfft-source} src/Rack/dep/jpommier-pffft-source
    cp -r ${nanovg-source}/* src/Rack/dep/nanovg
    cp -r ${nanosvg-source}/* src/Rack/dep/nanosvg
    cp -r ${osdialog-source}/* src/Rack/dep/osdialog
    cp -r ${oui-blendish-source}/* src/Rack/dep/oui-blendish
    mkdir -p src/Rack/dep/QuickJS
    cp -r ${QuickJS-source }/* src/Rack/dep/QuickJS


    cp src/Rack/dep/jpommier-pffft-source/*.h src/Rack/dep/include
    cp src/Rack/dep/nanosvg/**/*.h src/Rack/dep/include
    cp src/Rack/dep/nanovg/src/*.h src/Rack/dep/include
    cp src/Rack/dep/osdialog/*.h src/Rack/dep/include
    cp src/Rack/dep/oui-blendish/*.h src/Rack/dep/include
    cp src/Rack/dep/QuickJS/*.h src/Rack/dep/include

    # substituteInPlace src/Rack/dep/oui-blendish/blendish.h --replace '#error "nanovg.h must be included first."' '#include "../include/nanovg.h"'
    # substituteInPlace src/Rack/dep/include/blendish.h --replace '#error "nanovg.h must be included first."' '#include "nanovg.h"'

    substituteInPlace src/Rack/dep/oui-blendish/blendish.h --replace '#ifndef NANOVG_H' '#include "../include/nanovg.h"
#ifndef NANOVG_H '
    substituteInPlace src/Rack/dep/include/blendish.h --replace '#ifndef NANOVG_H' '#include "nanovg.h"
#ifndef NANOVG_H '
  '';
  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    freetype
    jansson
    libGL
    libX11
    libXcursor
    libXext
    libarchive
    libsamplerate
    speexdsp
    libXrandr
    libXrandr
    liblo
    mesa
    python3
  ];

  makeFlags = [ "SYSDEPS=true" ];

  meta = {
    description = "Plugin wrapper around VCV Rack";
    homepage = "https://github.com/DISTRHO/cardinal";

    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.all;
  };
}
