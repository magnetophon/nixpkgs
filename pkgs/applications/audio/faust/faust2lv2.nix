{ boost
, faust
, lv2_1_16
, qt4
, which

}:

faust.wrapWithBuildEnv {

  baseName = "faust2lv2";

  propagatedBuildInputs = [ boost lv2_1_16 qt4 which ];

}
