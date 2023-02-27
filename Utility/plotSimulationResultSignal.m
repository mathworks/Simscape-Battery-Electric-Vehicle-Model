function fig = plotSimulationResultSignal(nvpairs)
% plots the simulation result.

% Copyright 2021-2023 The MathWorks, Inc.

arguments
  nvpairs.SimData timetable
  nvpairs.SignalName {mustBeTextScalar}
  nvpairs.PlotParent (1,1)  % matlab.ui.Figure
end

sigName = nvpairs.SignalName;

t = nvpairs.SimData.Time;
y = nvpairs.SimData.(sigName);

lix = nvpairs.SimData.Properties.VariableNames == sigName;
unitStr = nvpairs.SimData.Properties.VariableUnits{lix};

if not(isfield(nvpairs, "PlotParent"))
  fig = figure;
  fig.Position(3:4) = [700 300];  % width height
else
  fig = nvpairs.PlotParent;
end

hold on
grid on

plot(fig, t, y, LineWidth = 2)

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
