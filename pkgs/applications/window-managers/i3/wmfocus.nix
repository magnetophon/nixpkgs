{ stdenv, fetchFromGitHub, rustPlatform,
  xorg, python3, pkgconfig, cairo, libxkbcommon }:

rustPlatform.buildRustPackage rec {
  pname = "wmfocus";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = version;
    sha256 = "17qdsqp9072yr7rcm6g1h620rff95ldawr8ldpkbjmkh0rc86skn";
  };

  cargoSha256 = "1jhsz3swqkzi6xp8kjcp3hi39id0d8spx3zhxv1asfk47sc65drp";

  nativeBuildInputs = [ python3 pkgconfig ];
  buildInputs = [ cairo libxkbcommon xorg.xcbutilkeysyms ];

  # For now, this is the only available featureset. This is also why the file is
  # in the i3 folder, even though it might be useful for more than just i3
  # users.
  cargoBuildFlags = [ "--features i3" ];

  meta = with stdenv.lib; {
    description = "Visually focus windows by label";
    maintainers = with maintainers; [ synthetica ];
    platforms = platforms.linux;
    license = licenses.mit;
    homepage = https://github.com/svenstaro/wmfocus;
  };
}
