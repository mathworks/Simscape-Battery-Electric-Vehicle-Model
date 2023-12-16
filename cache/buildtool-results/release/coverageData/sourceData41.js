var sourceData41 = {"FileName":"C:\\local\\github-issacito12\\fork-bev\\Components\\BatteryHighVoltage\\Utility\\BatteryHV_buildTerminalResistanceData.m","RawFileContents":["function [TR_Ohm, SOC_pct] = BatteryHV_buildTerminalResistanceData(Temperature_degC, TerminalResistanceData_Ohm, nvpairs)\r","%% Builds a SOC-by-TerminalResistance matrix for table-based battery block\r","% Given one or more pairs of temperature and data points representing\r","% terminal resistance (TR) as a function of state of charge (SOC),\r","% this function builds and returns a matrix which can be used as\r","% Terminal resistance R0(SOC,T) paramter of Tabled-Based Battery block\r","% in Simscape Electrical.\r","% The returned data are smoothly interpolated at the interval of 1 degree Selcius.\r","% This function also returns a vector of SOC in percent as a second return element.\r","%\r","% This function requires Signal Designer (SignalDesigner.m).\r","%\r","% SOC-TR data points for one temperature must be represented\r","% in an N-by-2 matrix where first column is the state of charge in %\r","% and second column is terminal resistance in Ohm.\r","%\r","% The following is an example of calling this function\r","% with three temperature points at 0, 25, and 60 degC.\r","%{\r","[TR_Ohm, SOC_pct] = ...\r","BatteryHV_buildTerminalResistanceData( ...\r","   0, [ 0 0.47 ; 5 0.45  ; 15 0.218 ; 40 0.101 ; 80 0.086 ; 100 0.1   ], ...\r","  25, [ 0 0.17 ; 5 0.12  ; 15 0.072 ; 40 0.053 ; 80 0.044 ; 100 0.033 ], ...\r","  60, [ 0 0.13 ; 5 0.005 ; 15 0.04  ; 40 0.037 ; 80 0.03  ; 100 0.024 ], ...\r","  MakePlot = true )\r","%}\r","% Note that the temperature points must be sorted in strictly increasing order.\r","%\r","% This function is used in the BatteryHV_TableBased_buildParameters script.\r","% Running the script serves as a test of this function too.\r","\r","% Copyright 2023 The MathWorks, Inc.\r","\r","arguments (Repeating)\r","  Temperature_degC (1,1) double {mustBeNonnegative}\r","  TerminalResistanceData_Ohm (:,2) double {mustBeNonnegative}\r","end\r","\r","arguments\r","  nvpairs.MakePlot (1,1) logical = false\r","end\r","doPlot = nvpairs.MakePlot;\r","\r","temperature_vec = [Temperature_degC{:}];\r","numCols = numel(temperature_vec);\r","\r","assert(issorted(temperature_vec, \"strictascend\"), ...\r","  \"Values for temperature arguments must be strictly increasing, \" ...\r","  + \"but passed values do not satisify the condition: \" + join(string(temperature_vec), \", \"))\r","\r","if numCols >= 2\r","  dataLen = nan(1, numCols);\r","  for idx = 1 : numCols\r","    dataLen(idx) = height(TerminalResistanceData_Ohm{idx});\r","  end\r","  assert(all(diff(dataLen) == 0), ...\r","    \"All terminal resistance data point matrices must have the same number of rows: \" ...\r","    + join(string(dataLen), \", \"))\r","end\r","\r","sig = SignalDesigner(\"Continuous\");\r","\r","% interpolate at the interval of 1 degree Celsius\r","sig.DeltaX = 1;\r","\r","sig.XYData = TerminalResistanceData_Ohm{1};\r","update(sig)\r","TR_Ohm = nan(numel(sig.Data.Y), numCols);\r","TR_Ohm(:, 1) = sig.Data.Y;\r","\r","SOC_pct = sig.Data.X;\r","\r","if numCols >= 2\r","  for idx = 2 : numCols\r","    sig.XYData = TerminalResistanceData_Ohm{idx};\r","    update(sig)\r","    TR_Ohm(:, idx) = sig.Data.Y;\r","  end  % for\r","end  % if-else\r","\r","if doPlot\r","  fig = figure;\r","  fig.Position(3:4) = [600 300];\r","  hold on\r","  grid on\r","  % Plot in reverse order from high temperature to low temperature.\r","  for idx = numCols : -1 : 1\r","    plot(SOC_pct, TR_Ohm(:,idx), LineWidth=2)\r","  end  % for\r","  set(gca, xdir = \"reverse\")\r","  % Flip the temperature vector from high temperature to low temperature.\r","  legendStr = string(flip(temperature_vec)) + \" degC\";\r","  legend(legendStr, Location=\"best\")\r","  xlabel(\"State of charge (%)\")\r","  ylabel(\"(Ohm)\")\r","  title(\"Terminal resistance\")\r","end  % if\r","\r","end  % function\r",""],"CoverageDisplayDataPerLine":{"Function":{"LineNumber":1,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":121,"ContinuedLine":false},"Statement":[{"LineNumber":35,"Hits":135,"StartColumnNumbers":33,"EndColumnNumbers":50,"ContinuedLine":false},{"LineNumber":36,"Hits":135,"StartColumnNumbers":43,"EndColumnNumbers":60,"ContinuedLine":false},{"LineNumber":40,"Hits":44,"StartColumnNumbers":35,"EndColumnNumbers":40,"ContinuedLine":false},{"LineNumber":42,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":26,"ContinuedLine":false},{"LineNumber":44,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":40,"ContinuedLine":false},{"LineNumber":45,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":33,"ContinuedLine":false},{"LineNumber":47,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":48,"ContinuedLine":false},{"LineNumber":48,"Hits":45,"StartColumnNumbers":2,"EndColumnNumbers":66,"ContinuedLine":true},{"LineNumber":49,"Hits":45,"StartColumnNumbers":2,"EndColumnNumbers":94,"ContinuedLine":true},{"LineNumber":51,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":15,"ContinuedLine":false},{"LineNumber":52,"Hits":45,"StartColumnNumbers":2,"EndColumnNumbers":28,"ContinuedLine":false},{"LineNumber":53,"Hits":45,"StartColumnNumbers":2,"EndColumnNumbers":23,"ContinuedLine":false},{"LineNumber":54,"Hits":135,"StartColumnNumbers":4,"EndColumnNumbers":59,"ContinuedLine":false},{"LineNumber":56,"Hits":45,"StartColumnNumbers":2,"EndColumnNumbers":32,"ContinuedLine":false},{"LineNumber":57,"Hits":45,"StartColumnNumbers":4,"EndColumnNumbers":85,"ContinuedLine":true},{"LineNumber":58,"Hits":45,"StartColumnNumbers":4,"EndColumnNumbers":34,"ContinuedLine":true},{"LineNumber":61,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":35,"ContinuedLine":false},{"LineNumber":64,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":15,"ContinuedLine":false},{"LineNumber":66,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":43,"ContinuedLine":false},{"LineNumber":67,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":11,"ContinuedLine":false},{"LineNumber":68,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":41,"ContinuedLine":false},{"LineNumber":69,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":26,"ContinuedLine":false},{"LineNumber":71,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":21,"ContinuedLine":false},{"LineNumber":73,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":15,"ContinuedLine":false},{"LineNumber":74,"Hits":45,"StartColumnNumbers":2,"EndColumnNumbers":23,"ContinuedLine":false},{"LineNumber":75,"Hits":90,"StartColumnNumbers":4,"EndColumnNumbers":49,"ContinuedLine":false},{"LineNumber":76,"Hits":90,"StartColumnNumbers":4,"EndColumnNumbers":15,"ContinuedLine":false},{"LineNumber":77,"Hits":90,"StartColumnNumbers":4,"EndColumnNumbers":32,"ContinuedLine":false},{"LineNumber":81,"Hits":45,"StartColumnNumbers":0,"EndColumnNumbers":9,"ContinuedLine":false},{"LineNumber":82,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":15,"ContinuedLine":false},{"LineNumber":83,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":32,"ContinuedLine":false},{"LineNumber":84,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":11,"ContinuedLine":false},{"LineNumber":85,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":11,"ContinuedLine":false},{"LineNumber":87,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":28,"ContinuedLine":false},{"LineNumber":88,"Hits":3,"StartColumnNumbers":4,"EndColumnNumbers":45,"ContinuedLine":false},{"LineNumber":90,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":28,"ContinuedLine":false},{"LineNumber":92,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":54,"ContinuedLine":false},{"LineNumber":93,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":36,"ContinuedLine":false},{"LineNumber":94,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":31,"ContinuedLine":false},{"LineNumber":95,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":17,"ContinuedLine":false},{"LineNumber":96,"Hits":1,"StartColumnNumbers":2,"EndColumnNumbers":30,"ContinuedLine":false}]}}