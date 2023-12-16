var sourceData149 = {"FileName":"C:\\local\\github-issacito12\\fork-bev\\Components\\VehicleSpeedReference\\Utility\\Configuration\\VehSpdRef_loadSimulationCase.m","RawFileContents":["function VehSpdRef_loadSimulationCase(nvpairs)\r","%% Sets up simulation\r","% This function sets up the followings:\r","% - Simulation stop time\r","% - Input signals\r","%\r","% Model must be loaded for this function to work.\r","\r","% Copyright 2023 The MathWorks, Inc.\r","\r","arguments\r","  nvpairs.CaseName {mustBeTextScalar} = \"Default\"\r","\r","  nvpairs.ModelName {mustBeTextScalar} = \"VehSpdRef_harness_model\"\r","  nvpairs.TargetSubsystemPath {mustBeTextScalar} = \"/Vehicle speed reference\"\r","\r","  nvpairs.CaseNumber (1,1) {mustBeMember(nvpairs.CaseNumber, 1:5)} = 1\r","  nvpairs.StopTime (1,1) {mustBePositive} = 100\r","\r","  nvpairs.DisplayMessage (1,1) logical = true\r","end\r","\r","dispMsg = nvpairs.DisplayMessage;\r","\r","if dispMsg\r","  disp(\"Setting up simulation...\")\r","  disp(\"Simulation case: \" + nvpairs.CaseName)\r","end\r","\r","mdl = nvpairs.ModelName;\r","\r","t_end = nvpairs.StopTime;\r","\r","if dispMsg\r","  disp(\"Setting simulation stop time to \" + t_end + \" sec.\")\r","end\r","\r","set_param(mdl, StopTime = num2str(t_end));\r","\r","caseNumStr = num2str(nvpairs.CaseNumber);\r","if dispMsg\r","  disp(\"Selecting simulation case \" + caseNumStr + \".\")\r","end\r","\r","sysPath = mdl + nvpairs.TargetSubsystemPath;\r","\r","set_param( sysPath + \"/Simulation Case\", ...\r","  Value = caseNumStr)\r","\r","end  % function\r",""],"CoverageDisplayDataPerLine":{"Function":{"LineNumber":1,"Hits":14,"StartColumnNumbers":0,"EndColumnNumbers":46,"ContinuedLine":false},"Statement":[{"LineNumber":12,"Hits":[14,1],"StartColumnNumbers":[20,40],"EndColumnNumbers":[36,49],"ContinuedLine":false},{"LineNumber":14,"Hits":[14,1],"StartColumnNumbers":[21,41],"EndColumnNumbers":[37,66],"ContinuedLine":false},{"LineNumber":15,"Hits":[14,1],"StartColumnNumbers":[31,51],"EndColumnNumbers":[47,77],"ContinuedLine":false},{"LineNumber":17,"Hits":[14,1],"StartColumnNumbers":[28,69],"EndColumnNumbers":[65,70],"ContinuedLine":false},{"LineNumber":18,"Hits":[14,1],"StartColumnNumbers":[26,44],"EndColumnNumbers":[40,47],"ContinuedLine":false},{"LineNumber":20,"Hits":1,"StartColumnNumbers":41,"EndColumnNumbers":45,"ContinuedLine":false},{"LineNumber":23,"Hits":14,"StartColumnNumbers":0,"EndColumnNumbers":33,"ContinuedLine":false},{"LineNumber":25,"Hits":14,"StartColumnNumbers":0,"EndColumnNumbers":10,"ContinuedLine":false},{"LineNumber":26,"Hits":14,"StartColumnNumbers":2,"EndColumnNumbers":34,"ContinuedLine":false},{"LineNumber":27,"Hits":14,"StartColumnNumbers":2,"EndColumnNumbers":46,"ContinuedLine":false},{"LineNumber":30,"Hits":14,"StartColumnNumbers":0,"EndColumnNumbers":24,"ContinuedLine":false},{"LineNumber":32,"Hits":14,"StartColumnNumbers":0,"EndColumnNumbers":25,"ContinuedLine":false},{"LineNumber":34,"Hits":14,"StartColumnNumbers":0,"EndColumnNumbers":10,"ContinuedLine":false},{"LineNumber":35,"Hits":14,"StartColumnNumbers":2,"EndColumnNumbers":60,"ContinuedLine":false},{"LineNumber":38,"Hits":14,"StartColumnNumbers":0,"EndColumnNumbers":42,"ContinuedLine":false},{"LineNumber":40,"Hits":14,"StartColumnNumbers":0,"EndColumnNumbers":41,"ContinuedLine":false},{"LineNumber":41,"Hits":14,"StartColumnNumbers":0,"EndColumnNumbers":10,"ContinuedLine":false},{"LineNumber":42,"Hits":14,"StartColumnNumbers":2,"EndColumnNumbers":55,"ContinuedLine":false},{"LineNumber":45,"Hits":14,"StartColumnNumbers":0,"EndColumnNumbers":44,"ContinuedLine":false},{"LineNumber":47,"Hits":14,"StartColumnNumbers":0,"EndColumnNumbers":39,"ContinuedLine":false},{"LineNumber":48,"Hits":14,"StartColumnNumbers":2,"EndColumnNumbers":21,"ContinuedLine":true}]}}