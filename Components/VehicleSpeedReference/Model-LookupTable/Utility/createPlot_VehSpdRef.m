function fig = createPlot_VehSpdRef(DataTable, NameValuePairs)
% Create a plot of the vehicle speed reference.
% This function assumes that the data is a table with Time and Speed columns and
% these column data are simscape.Value objects.
% The unit of the Time column must be commensurate with simscape.Unit("s").
% The unit of the Speed column must be commensurate with simscape.Unit("m/s").

% Copyright 2026 The MathWorks, Inc.

arguments (Input)

  % Time and Speed column must exist and contain simscape.Value objects.
  DataTable (:,2) table ...
    = table(simscape.Value([0, 1, 2, 4, 5, 10], "s"), simscape.Value([0 0 0 3 3 3], "m/s"), VariableNames=["Time" "Speed"])

  NameValuePairs.SpeedUnit (1,1) simscape.Unit {simscape.mustBeCommensurateUnit(NameValuePairs.SpeedUnit, "m/s")} = "m/s"

  NameValuePairs.InterpolationInterval (1,1) duration {mustBePositive} = seconds(0.1)

end  % arguments

arguments (Output)
  fig matlab.ui.Figure
end  % arguments

speed_unit = string(NameValuePairs.SpeedUnit);

fig = figure;
fig.Position(3:4) = [1000 300];  % width height

ax = axes(fig);

bevutil1.SignalUtil.plotLookupTable1D( ...
  DataTable.Time.value("s"), ...
  DataTable.Speed.value(speed_unit), ...
  InterpolationInterval = seconds(NameValuePairs.InterpolationInterval), ...
  ParentAxes = ax )

xlabel(ax, "Time (s)")
ylabel(ax, "(" + speed_unit + ")")
title(ax, "Speed")

if nargout == 0
  clear fig
end  % if
end  % function
