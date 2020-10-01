{ stdenv, fetchFromGitHub, jack2,
  python3Packages
}:

stdenv.mkDerivation rec {
  pname = "catia";
  version = "unstable-2020-09-26";

  src = fetchFromGitHub {
    owner = "falkTX";
    repo = pname;
    rev = "78b0307afeded440c80a2b1d732dd15382f7b335";
    sha256 = "0bva0hj1shpn8k7xhfxfxhm631p3dxc7qqm7zw951dngyc0v6364";
  };

  nativeBuildInputs = [
    python3Packages.wrapPython
  ];

  pythonPath = with python3Packages; [
    pyqt5
  ] ;

  buildInputs = [
   jack2
  ] ++ pythonPath;

  enableParallelBuilding = true;

  installFlags = [ "PREFIX=$(out)" ];

  dontWrapQtApps = true;
  # postFixup = ''
    # wrapPythonPrograms
  # wrapPythonProgramsIn "$out/share/carla/resources" "$out $pythonPath"

  # find "$out/share/carla" -maxdepth 1 -type f -not -name "*.py" -print0 | while read -d "" f; do
  # patchPythonScript "$f"
  # done
  # patchPythonScript "$out/share/carla/carla_settings.py"

  # for program in $out/bin/*; do
  # wrapQtApp "$program" \
  # --prefix PATH : "$program_PATH:${which}/bin" \
  # --set PYTHONNOUSERSITE true
  # done

  # find "$out/share/carla/resources" -maxdepth 1 -type f -not -name "*.py" -print0 | while read -d "" f; do
  # wrapQtApp "$f" \
  # --prefix PATH : "$program_PATH:${which}/bin" \
  # --set PYTHONNOUSERSITE true
  # done
  # '';

  meta = with stdenv.lib; {
    homepage = "https://kx.studio/catia";
    description = "Simple JACK Patchbay with A2J integration and JACK Transport controls";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
