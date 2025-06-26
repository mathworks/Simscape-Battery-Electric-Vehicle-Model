function fig = plotSimulationResultSignal(NameValuePair)
% plots the simulation result.

% Copyright 2021-2024 The MathWorks, Inc.

arguments (Input)
  NameValuePair.SimData timetable
  NameValuePair.SignalName {mustBeTextScalar}
  NameValuePair.PlotParent matlab.ui.Figure {mustBeScalarOrEmpty}
end

arguments (Output)
  fig matlab.ui.Figure {mustBeScalarOrEmpty}
end

sigName = NameValuePair.SignalName;

t = NameValuePair.SimData.Time;
y = NameValuePair.SimData.(sigName);

lix = NameValuePair.SimData.Properties.VariableNames == sigName;
unitStr = NameValuePair.SimData.Properties.VariableUnits{lix};

if not(isfield(NameValuePair, "PlotParent"))
  fig = figure;
  fig.Position(3:4) = [700 300];  % width height
else
  fig = NameValuePair.PlotParent;
end

hold on
grid on

plot(t, y, LineWidth = 2)

% This prevents the plot range of Y axis from getting too narrow
% by limiting the range to be at least 0.02 of the signal.
% This makes the plot of a signal to be a straight line
% when the signal should be interpreted as not changing.
% Note that the value 0.02 is assuming that
% the unit used for the signal is "reasonable".
setMinimumYRange(gca, y, dy_threshold=0.02)

xlabel("Time")
title(sigName + " (" + unitStr + ")")

end
