function returnFigure = DifferencePlot(data, NameValuePair)
% Make a plot of the difference of specified data.
% To see how this function works, just run this function without any arguments.
%
% The data argument must be a vector of type double in strictly ascending order.
%
% An example use case of this function is to make the plot of step size from
% simulation time step data.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  % BlockPath
  data (:,1) double {mustBeVector, SignalTool1.mustBeStrictAscend} = 0 : 0.1 : 10

  % If NewFigure is true, ParentAxes is ignored.
  NameValuePair.NewFigure (1,1) logical = true
  NameValuePair.ParentAxes (1,:) matlab.graphics.axis.Axes

  NameValuePair.Title (1,1) string = ""
  NameValuePair.XLabel (1,1) string = ""
  NameValuePair.YLabel (1,1) string = ""
  NameValuePair.XUnitText (1,1) string = ""
  NameValuePair.YUnitText (1,1) string = ""

  NameValuePair.PlotXLowerBound (1,1) double
  NameValuePair.PlotXUpperBound (1,1) double

  NameValuePair.PlotYLowerBound (1,1) double %= 1e-3
  NameValuePair.PlotYUpperBound (1,1) double %= 1e+1
end  % arguments

arguments (Output)
  returnFigure (1,1) matlab.ui.Figure
end  % arguments

errorID = "StepSizePlot:";

if NameValuePair.NewFigure
  fig = figure;
  ax = axes(fig);
elseif isfield(NameValuePair, "ParentAxes")
  ax = NameValuePair.ParentAxes;
  cla(ax)
  fig = ax.Parent;
else

  id = errorID + "InvalidFigureContainer";
  msg = "It is valid that NewFigure is false and ParentAxes is undefined.";

  throw(MException(id, msg))

end  % if
if nargout > 0
  returnFigure = fig;
end  % if

if isfield(NameValuePair, "PlotXLowerBound")
  x_plot_lower_bound = NameValuePair.PlotXLowerBound;
else
  x_plot_lower_bound = data(1);
end  % if

if isfield(NameValuePair, "PlotXUpperBound")
  x_plot_upper_bound = NameValuePair.PlotXUpperBound;
else
  x_plot_upper_bound = data(end);
end  % if

if isfield(NameValuePair, "PlotYLowerBound")
  y_plot_lower_bound = NameValuePair.PlotYLowerBound;
else
  y_plot_lower_bound = -Inf;
end  % if

if isfield(NameValuePair, "PlotYUpperBound")
  y_plot_upper_bound = NameValuePair.PlotYUpperBound;
else
  y_plot_upper_bound = Inf;
end  % if

time_steps = data;
step_sizes = [0; diff(time_steps)];

ax.YScale = "log";
axis(ax, "padded")

hold(ax, "on")
grid(ax, "on")

plot(ax, time_steps, step_sizes, LineWidth=1)

s = scatter(ax, time_steps, step_sizes);
s.Marker = "x";
s.SizeData = 50;  % default value is 36
s.LineWidth = 1.5;

xlim(ax, [x_plot_lower_bound, x_plot_upper_bound])
ylim(ax, [y_plot_lower_bound, y_plot_upper_bound])

if NameValuePair.Title ~= ""
  % Interpreter must be "none" to prevent the underscore latters from being
  % interpreted as subscript directive for the TeX or LaTeX interpreter.
  title(ax, NameValuePair.Title, Interpreter="none")
end  % if

if NameValuePair.XLabel ~= "" && NameValuePair.XUnitText ~= ""
  xstr = NameValuePair.XLabel + " (" + NameValuePair.XUnitText + ")";
  xlabel(ax, xstr)
elseif NameValuePair.XLabel ~= "" && NameValuePair.XUnitText == ""
  xstr = NameValuePair.XLabel;
  xlabel(ax, xstr)
elseif NameValuePair.XLabel == "" && NameValuePair.XUnitText ~= ""
  xstr = "(" + NameValuePair.XUnitText + ")";
  xlabel(ax, xstr)
end  % if

if NameValuePair.YLabel ~= "" && NameValuePair.YUnitText ~= ""
  ystr = NameValuePair.YLabel + " (" + NameValuePair.YUnitText + ")";
  ylabel(ax, ystr)
elseif NameValuePair.YLabel ~= "" && NameValuePair.YUnitText == ""
  ystr = NameValuePair.YLabel;
  ylabel(ax, ystr)
elseif NameValuePair.YLabel == "" && NameValuePair.YUnitText ~= ""
  ystr = "(" + NameValuePair.YUnitText + ")";
  ylabel(ax, ystr)
end  % if

hold(ax, "off")
end  % function
