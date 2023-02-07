function fig = MotorDriveUnit_plotResults(nvpairs)
% plots the simulation result.

% Copyright 2021-2022 The MathWorks, Inc.

arguments
  nvpairs.SimData timetable
  nvpairs.FigureHeight (1,1) {mustBePositive} = 300
end

sigNames = [
  "Motor torque command"
  "Axle clutch switch"
  "Axle speed input"
  "Axle torque input"
  "Motor power rate"
  "Motor speed"
  "Motor temperature"
  "Battery power"
  "Battery current"
  "Battery voltage"
  ];

for i = 1 : numel(sigNames)
  fig = plotSimulationResultSignal( ...
    SimData = nvpairs.SimData, ...
    SignalName = sigNames(i) );
  fig.Position(4) = nvpairs.FigureHeight;
end

end  % function
