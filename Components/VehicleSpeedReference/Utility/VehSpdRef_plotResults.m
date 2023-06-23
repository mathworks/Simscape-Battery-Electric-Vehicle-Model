function fig = VehSpdRef_plotResults(nvpairs)
% plots the simulation result.

% Copyright 2022-2023 The MathWorks, Inc.

arguments
  nvpairs.SimData timetable
  nvpairs.FigureWidth (1,1) {mustBePositive, mustBeInteger} = 600
  nvpairs.FigureHeight (1,1) {mustBePositive, mustBeInteger} = 400
end

sigName = "Vehicle speed reference kph";

fig = plotSimulationResultSignal( ...
  SimData = nvpairs.SimData, ...
  SignalName = sigName );

fig.Position(3) = nvpairs.FigureWidth;
fig.Position(4) = nvpairs.FigureHeight;

axis padded

ylabel(gca, "km/h")
title(gca, "Vehicle speed reference")

end  % function
