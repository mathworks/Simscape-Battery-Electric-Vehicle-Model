var sourceData45 = {"FileName":"C:\\local\\github-issacito12\\fork-bev\\Components\\BatteryHighVoltage\\Utility\\BatteryHV_plotInput_LoadCurrent.m","RawFileContents":["function fig = BatteryHV_plotInput_LoadCurrent(nvpairs)\r","%% Plots input signal defined in a model\r","% This functions reads the block parameters of\r","% Continuous Multi-Step block and makes a plot.\r","% The model must be loaded for this function to work.\r","\r","% Copyright 2022-2023 The MathWorks, Inc.\r","\r","arguments\r","  nvpairs.ModelName {mustBeText} = \"BatteryHV_harness_model\"\r","  nvpairs.BlockPath {mustBeText} = \"/Inputs/Load current\"\r","end\r","\r","fullpathToBlock = nvpairs.ModelName + nvpairs.BlockPath;\r","\r","% Collect mask workspace variables.\r","% They have been evaluated.\r","% See the documentation for Simulink.VariableUsage.\r","maskVars = get_param(fullpathToBlock, \"MaskWSVariables\");\r","\r","varNames = string({maskVars.Name});\r","varValues = {maskVars.Value};\r","\r","dataPoints = varValues{varNames == \"dataPoints\"};\r","deltaT = varValues{varNames == \"deltaT\"};\r","\r","sig = SignalDesigner(\"ContinuousMultiStep\");\r","sig.XYData = dataPoints;\r","sig.DeltaX = deltaT;\r","\r","fig = plotDataPoints(sig);\r","\r","end  % function\r",""],"CoverageDisplayDataPerLine":{"Function":{"LineNumber":1,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":55,"ContinuedLine":false},"Statement":[{"LineNumber":10,"Hits":[1,1],"StartColumnNumbers":[21,35],"EndColumnNumbers":[31,60],"ContinuedLine":false},{"LineNumber":11,"Hits":[1,1],"StartColumnNumbers":[21,35],"EndColumnNumbers":[31,57],"ContinuedLine":false},{"LineNumber":14,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":56,"ContinuedLine":false},{"LineNumber":19,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":57,"ContinuedLine":false},{"LineNumber":21,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":35,"ContinuedLine":false},{"LineNumber":22,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":29,"ContinuedLine":false},{"LineNumber":24,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":49,"ContinuedLine":false},{"LineNumber":25,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":41,"ContinuedLine":false},{"LineNumber":27,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":44,"ContinuedLine":false},{"LineNumber":28,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":24,"ContinuedLine":false},{"LineNumber":29,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":20,"ContinuedLine":false},{"LineNumber":31,"Hits":1,"StartColumnNumbers":0,"EndColumnNumbers":26,"ContinuedLine":false}]}}