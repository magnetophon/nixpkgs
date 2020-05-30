{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gendesk";
  version = "1.0.5";

  goPackagePath = "github.com/xyproto/gendesk";
  src = fetchFromGitHub {
    rev = version;
    owner = "xyproto";
    repo = "gendesk";
    sha256 = "1a098ylfwzmwcmr38qhfmqxp5j899mhxslahz6hsyxaf15xyncbd";
  };

  meta = with stdenv.lib; {
    description = "Generate .desktop files and download .png icons by specifying a minimum of information";
    homepage = "https://gendesk.roboticoverlords.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ magnetophon ];
  };
}
