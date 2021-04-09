{ alsaLib
, cmake
, curl
, fetchFromGitHub
, freeglut
, freetype
, libGL
, libXcursor
, libXext
, libXinerama
, libXrandr
, libjack2
, pkgconfig
, python3
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "CHOWTapeModel";
  version = "unstable-2021-03-11";

  src = fetchFromGitHub {
    owner = "jatinchowdhury18";
    repo = "AnalogTapeModel";
