{ stdenv, rustPlatform, lib, fetchFromGitHub, xdg_utils, libsixel, gst_all_1, cudatoolkit,
  withGstPlugins ? true
, withCups ? true, cups
}:
let optionals = stdenv.lib.optionals; in

rustPlatform.buildRustPackage rec {
  pname = "hunter";
  # version = "1.3.4";
  version = "dev";

  src = fetchFromGitHub {
    owner = "rabite0";
    repo = pname;
    # rev = "v${version}";
    # sha256 = "01xr8l5jqxq1hfbmdrh82yjg1013aklr5a2fiidgycy3ysd9kzaj";
    rev = "1f90edbafbd72ff89e84c00a364b2c5a24790665";
    sha256 = "0fxd5rr48ycxvcpd9l81w9fmmizplskkqk4si3h4zc4w5kvsv1zr";
    # rev = "17c25221241c61acf6a77967471439775829abe8";
    # sha256 = "0zagxjl1yq1mh9g6x4hiyax5hpk59lvq4n7l28v0h9ym73ipfcwd";
  };

  # cargoSha256 = "0xnd3n26qlxgiccc7a98625hxn2d61gg03mksknmipiwd3qdjs4x";
  cargoSha256 = "161vyhb2i1w0rx5i4cv2r9h9nqnhqi9hd6snycgcpwc9cix8cs9z";
  # cargoSha256 = "13xn7sl38kisflk21av932c600kad6i68y3dhd3d3s92ama9z7rf";

  buildInputs =
    [ xdg_utils libsixel cudatoolkit ]
    ++ (with gst_all_1;
      [ gstreamer gst-plugins-base gst-libav ]
      ++ optionals withGstPlugins
        [ gst-plugins-good gst-plugins-ugly gst-plugins-bad ]);

  # Don't bail out if compiler isn't a nightly
  # https://github.com/rabite0/hunter/blob/v1.3.4/build.rs
  prePatch = ''
    sed -e '10,22d' -i build.rs
  '';

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    homepage = https://rabite0.github.io/hunter/;
    license = licenses.wtfpl;
    description = "ranger-like file browser written in rust";
    maintainers = with maintainers; [ magnetophon ];
  };
}
