function fig = VehSpdRef_ResultsPlot(NameValuePair)
% plots the simulation result.

% Copyright 2022-2024 The MathWorks, Inc.

arguments (Input)
  NameValuePair.SimData timetable
  NameValuePair.FigureWidth (1,1) {mustBePositive, mustBeInteger} = 600
  NameValuePair.FigureHeight (1,1) {mustBePositive, mustBeInteger} = 400
end

arguments (Output)
  fig matlab.ui.Figure {mustBeScalarOrEmpty}
end

sigName = "Vehicle speed reference kph";

fig = plotSimulationResultSignal( ...
  SimData = NameValuePair.SimData, ...
  SignalName = sigName );

fig.Position(3) = NameValuePair.FigureWidth;
fig.Position(4) = NameValuePair.FigureHeight;

axis padded

ylabel(gca, "km/h")
title(gca, "Vehicle speed reference")

end  % function
