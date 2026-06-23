function ReturnFigure = plotTimedData(NameValuePair)
%% Plot timetable data.

% Copyright 2021-2025 The MathWorks, Inc.

arguments (Input)

  % TimedData's Properties must have VariableNames.
  % - TimedData.Properties.VariableNames
  %
  % TimedData's Properties can optionally have VariableUnits.
  % - TimedData.Properties.VariableUnits
  %
  NameValuePair.TimedData timetable = timetable(seconds(0:2)', (2:4)', VariableNames="Var_12")

  % SignalName must exist in as a column of TimedData.
  NameValuePair.SignalName (1,1) string = "Var_12"

  NameValuePair.ParentAxes matlab.graphics.axis.Axes {mustBeScalarOrEmpty}

  % FigureWidth and FigureHeight are valid when parentAxes is NOT specified.
  NameValuePair.FigureWidth (1,1) {mustBeInteger, mustBePositive} = 700
  NameValuePair.FigureHeight (1,1) {mustBeInteger, mustBePositive} = 300

end  % arguments

arguments (Output)
  ReturnFigure matlab.ui.Figure {mustBeScalarOrEmpty}
end  % arguments

errorID = "plotTimedData:";

signal_name = NameValuePair.SignalName;

t = NameValuePair.TimedData.Time;
y = NameValuePair.TimedData.(signal_name);

logical_index = NameValuePair.TimedData.Properties.VariableNames == signal_name;

if nnz(logical_index) == 0
  id = errorID + "SignalNotFound";
  msg = "Specified signal is not found in the timetable: " + signal_name;

  throw(MException(id, msg))

end  % if

if not(isempty(NameValuePair.TimedData.Properties.VariableUnits))
  unit_text = NameValuePair.TimedData.Properties.VariableUnits{logical_index};
else
  unit_text = "";
end  % if

if not(isfield(NameValuePair, "ParentAxes"))
  fig = figure;
  fig.Position(3) = NameValuePair.FigureWidth;
  fig.Position(4) = NameValuePair.FigureHeight;
  ax = axes(fig);
else
  ax = NameValuePair.ParentAxes;
  fig = ax.Parent;
end  % if

hold(ax, "on")
grid(ax, "on")
axis(ax, "padded")

plot(ax, t, y, LineWidth = 2)

% This prevents the plot range of Y axis from getting too narrow
% by limiting the range to be at least 0.02 of the signal.
% This makes the plot of a signal to be a straight line
% when the signal should be interpreted as not changing.
% Note that the value 0.02 is assuming that
% the unit used for the signal is "reasonable".
SignalUtil1.setMinimumYRange(ax, y, dy_threshold=0.02)

xlim(ax, [t(1), t(end)])
xlabel(ax, "Time")

% Disable tex/latex interpreters so that names like Data_3 or Data_11 are properly printed.
if unit_text == ""
  title(ax, signal_name, Interpreter="none")
else
  title(ax, signal_name + " (" + unit_text + ")", Interpreter="none")
end  % if

if nargout > 0
  ReturnFigure = fig;
end  % if
end  % function
