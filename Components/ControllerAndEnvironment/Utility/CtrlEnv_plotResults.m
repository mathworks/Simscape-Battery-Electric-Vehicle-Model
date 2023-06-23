function fig = CtrlEnv_plotResults(nvpairs)
% plots the simulation result.

% Copyright 2022-2023 The MathWorks, Inc.

arguments
  nvpairs.SimData timetable
  nvpairs.FigureWidth (1,1) {mustBePositive, mustBeInteger} = 600
  nvpairs.FigureHeight (1,1) {mustBePositive, mustBeInteger} = 400
end

sigNames = [
  "Motor torque command"
  "Brake force"
  "Vehicle speed reference kph"
  "Vehicle speed kph"
  "Motor speed reference"
  "Motor speed"
  "Motor heat flow command"
  "Motor temperature"
  "Battery heat flow command"
  "Battery temperature"
  ];

numSigs = numel(sigNames);
for i = 1 : numSigs
  fig = plotSimulationResultSignal( ...
    SimData = nvpairs.SimData, ...
    SignalName = sigNames(i) );
  fig.Position(3) = nvpairs.FigureWidth;
  fig.Position(4) = nvpairs.FigureHeight;
end

end  % function
