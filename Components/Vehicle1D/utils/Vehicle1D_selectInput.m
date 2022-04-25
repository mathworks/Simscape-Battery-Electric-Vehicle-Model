function Vehicle1D_selectInput(nvpairs)
%% Selects external input signal pattern

% Copyright 2022 The MathWorks, Inc.

arguments
  nvpairs.InputPattern {mustBeTextScalar, mustBeMember(nvpairs.InputPattern, ...
    ["Constant", "Coastdown", "Brake3", "RoadGrade3", "DriveAxle"])} ...
    = "DriveAxle"
  nvpairs.DisplayMessage (1,1) logical = false
  nvpairs.DisplayPlot (1,1) logical = false
end

inputPattern = nvpairs.InputPattern;
dispMsg = nvpairs.DisplayMessage;
dispPlot = nvpairs.DisplayPlot;

%%
if dispMsg
  disp("Selecting input: " + inputPattern)
end

inSigBuilder = Vehicle1D_InputSignalBuilder;
inSigBuilder.Plot_tf = dispPlot;

inpData = feval(char(inputPattern), inSigBuilder);

assignin("base", "vehicle_InputSignals", inpData.Signals)
assignin("base", "vehicle_InputBus", inpData.Bus)

% Simulation time
t_end = inpData.Options.StopTime_s;
assignin("base", "t_end", t_end)

if dispMsg
  disp("Setting initial vehicle speed...")
end
evalin("base", ...
  "initial.vehicle_speed_kph = " + inpData.Options.InitialVehicleSpeed_kph + ";");

end  % function
