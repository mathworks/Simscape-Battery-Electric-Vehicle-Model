var sourceData106 = {"FileName":"C:\\local\\github-issacito12\\fork-bev\\Components\\MotorDriveUnit\\Utility\\Configuration\\MotorDriveUnit_useRefsub.m","RawFileContents":["function MotorDriveUnit_useRefsub(nvpairs)\r","\r","% Copyright 2023 The MathWorks, Inc.\r","\r","arguments\r","  nvpairs.ModelName {mustBeTextScalar} = \"MotorDriveUnit_harness_model\"\r","  nvpairs.BlockPath {mustBeTextScalar} = \"/Motor Drive Unit\"\r","  nvpairs.RefsubName {mustBeTextScalar}    = \"MotorDriveUnit_refsub_Basic\"\r","  nvpairs.ParamFileName {mustBeTextScalar} = \"MotorDriveUnit_refsub_Basic_params\"\r","end\r","\r","mdl = nvpairs.ModelName;\r","blkpath = mdl + nvpairs.BlockPath;\r","refsub = nvpairs.RefsubName;\r","paramfile = nvpairs.ParamFileName;\r","\r","if not(bdIsLoaded(mdl))\r","  load_system(mdl)\r","end\r","\r","disp(\"Model: \" + mdl)\r","disp(\"Setting up referenced subsystem: \" + refsub)\r","evalin(\"base\", paramfile)\r","set_param( blkpath, ReferencedSubsystem = refsub );\r","\r","end  % function\r",""],"CoverageDisplayDataPerLine":{"Function":{"LineNumber":1,"Hits":25,"StartColumnNumbers":0,"EndColumnNumbers":42,"ContinuedLine":false},"Statement":[{"LineNumber":6,"Hits":[25,1],"StartColumnNumbers":[21,41],"EndColumnNumbers":[37,71],"ContinuedLine":false},{"LineNumber":7,"Hits":[25,1],"StartColumnNumbers":[21,41],"EndColumnNumbers":[37,60],"ContinuedLine":false},{"LineNumber":8,"Hits":[25,1],"StartColumnNumbers":[22,45],"EndColumnNumbers":[38,74],"ContinuedLine":false},{"LineNumber":9,"Hits":[25,1],"StartColumnNumbers":[25,45],"EndColumnNumbers":[41,81],"ContinuedLine":false},{"LineNumber":12,"Hits":25,"StartColumnNumbers":0,"EndColumnNumbers":24,"ContinuedLine":false},{"LineNumber":13,"Hits":25,"StartColumnNumbers":0,"EndColumnNumbers":34,"ContinuedLine":false},{"LineNumber":14,"Hits":25,"StartColumnNumbers":0,"EndColumnNumbers":28,"ContinuedLine":false},{"LineNumber":15,"Hits":25,"StartColumnNumbers":0,"EndColumnNumbers":34,"ContinuedLine":false},{"LineNumber":17,"Hits":25,"StartColumnNumbers":0,"EndColumnNumbers":23,"ContinuedLine":false},{"LineNumber":18,"Hits":5,"StartColumnNumbers":2,"EndColumnNumbers":18,"ContinuedLine":false},{"LineNumber":21,"Hits":25,"StartColumnNumbers":0,"EndColumnNumbers":21,"ContinuedLine":false},{"LineNumber":22,"Hits":25,"StartColumnNumbers":0,"EndColumnNumbers":50,"ContinuedLine":false},{"LineNumber":23,"Hits":25,"StartColumnNumbers":0,"EndColumnNumbers":25,"ContinuedLine":false},{"LineNumber":24,"Hits":25,"StartColumnNumbers":0,"EndColumnNumbers":51,"ContinuedLine":false}]}}