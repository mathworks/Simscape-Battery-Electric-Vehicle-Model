function fig = TimetableSingleSignalPlot(NameValuePair)
%% Make a plot of the specified signal from the specified timetable.
% To see what plot this function creates, run this function without any arguments.
%
% The name of the signal is shown above the plot using the title command.
% If the unit string is defined in the timetable, it is shown after the signal name.
% For example, signal Var1 has unti string "m/s", they are printed as "Var1 (m/s)".
% ylabel is not used so that the whole plot width is used for plotting the signal.

% Copyright 2021-2025 The MathWorks, Inc.

arguments (Input)
  NameValuePair.ParentAxes matlab.graphics.axis.Axes {mustBeScalarOrEmpty}

  NameValuePair.Timetable timetable = timetable(seconds((0:3)'), [0, -0.002, 0.002, 0]')
  NameValuePair.SignalName (1,1) string = "Var1"

  % This prevents the plot range in Y axis from getting too narrow
  % by limiting the Y range to be at least the specified value.
  % This makes the plot of a signal to be a straight line when
  % the signal should be interpreted as not changing.
  % Note that the default value of 0.02 is assuming that
  % the unit used for the signal is "reasonable".
  NameValuePair.MinimumYRange (1,1) {mustBePositive} = 0.02

  NameValuePair.LineWidth (1,1) {mustBePositive} = 1.5

  NameValuePair.XLabel (1,1) string = LiteApp6.Utility.i18n("Time")

  % If timetable's Properties.VariableUnits is not defined, this is used.
  % If timetable's Properties.VariableUnits is defined, this is ignored.
  NameValuePair.SignalUnit (1,1) string = ""

  % PlotWidth and PlotHeight are valid if ParentAxes is not specified.
  % If ParentAxes is specified, PlotWidth and PlotHeight are ignored.
  NameValuePair.PlotWidth (1,1) {mustBePositive} = 700
  NameValuePair.PlotHeight (1,1) {mustBePositive} = 300
end  % arguments

arguments (Output)
  fig matlab.ui.Figure {mustBeScalarOrEmpty}
end  % arguments

errorID = "TimetableSingleSignalPlot:";

if isempty(NameValuePair.Timetable)
  id = errorID + "InvalidTimetable";
  msg = LiteApp6.Utility.i18n("Empty Timetable is not allowed.");

  throw(MException(id, msg))

end  % if
time_table = NameValuePair.Timetable;

if isempty(NameValuePair.SignalName) || NameValuePair.SignalName==""
  id = errorID + "InvalidSignalName";
  msg = LiteApp6.Utility.i18n("Empty SignalName is not allowed.");

  throw(MException(id, msg))

end  % if
signal_name = NameValuePair.SignalName;

t = time_table.Time;
y = time_table.(signal_name);

if isfield(NameValuePair, "ParentAxes") && not(isempty(NameValuePair.ParentAxes))
  ax = NameValuePair.ParentAxes;
else
  fig = figure;
  fig.Position(3:4) = [NameValuePair.PlotWidth, NameValuePair.PlotHeight];
  ax = axes(fig);
end  % if

hold(ax, "on")
grid(ax, "on")

plot(ax, t, y, LineWidth=NameValuePair.LineWidth)

minimumYRangePlot(ax, y, NameValuePair.MinimumYRange)

if NameValuePair.XLabel ~= ""
  xlabel(ax, NameValuePair.XLabel)
end  % if

if isempty(time_table.Properties.VariableUnits)
  signal_unit = NameValuePair.SignalUnit;
else
  logical_index = time_table.Properties.VariableNames == signal_name;
  signal_unit = time_table.Properties.VariableUnits{logical_index};
end  % if

if signal_unit == ""
  title_str = signal_name;
else
  title_str = signal_name + " (" + signal_unit + ")";
end  % if
title(ax, title_str)

% Add paddings above Y max value and below Y min value so that the plotted curve is fully visible.
axis(ax, "padded")

% Remove the paddings in X direction.
xlim(ax, seconds([0 inf]))

end  % function

function minimumYRangePlot(parent_axes, ydata, threshold)
%% Add an invisible plot to prevent the y-axis range from getting too narrow.

arguments (Input)
  parent_axes (1,1) matlab.graphics.axis.Axes
  ydata (1,:) double
  threshold (1,1) double {mustBePositive}
end  % arguments

errorID = "minimumYRange:";

if isempty(ydata)
  id = errorID + "InvalidYData";
  msg = LiteApp6.Utility.i18n("Empty ydata is not allowed.");

  throw(MException(id, msg))

end  % if

y_hi = max(ydata);
y_lo = min(ydata);
dy_data = y_hi - y_lo;

if abs(dy_data) < threshold
  y_mean = (y_hi + y_lo) / 2;
  upper_bound = y_mean + threshold/2;
  lower_bound = y_mean - threshold/2;
  y_bounds = [lower_bound, upper_bound];

  plot(parent_axes, xlim(parent_axes), y_bounds, LineStyle="none", Marker="none")

end  % if
end  % local function
