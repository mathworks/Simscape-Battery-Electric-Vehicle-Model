function returnFigure = plotDifference(data, NameValuePair)
% Make a plot of the adjacent-element difference of the specified vector data.
%
% The vector data argument must be a vector of type double in strictly ascending order.
% An example use case of this function is to make the plot of step size from
% simulation time step data. It typically sets the YScale option to "Log".
%
% To see an example plot this function makes, just run this function without any arguments.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  % BlockPath
  data (:,1) double {mustBeVector, CodeTool1.mustBeStrictAscend} = [0, 0.1, 0.2, 0.2222, 0.223, 0.24, 0.3, 0.4, 0.5]

  % If NewFigure is true, ParentAxes is ignored.
  NameValuePair.NewFigure (1,1) logical = true
  NameValuePair.ParentAxes (1,:) matlab.graphics.axis.Axes

  NameValuePair.Title (1,1) string = ""
  NameValuePair.XLabel (1,1) string = ""
  NameValuePair.YLabel (1,1) string = ""

  % X and Y unit texts are used in xlabel and ylabel, respectively.
  NameValuePair.XUnitText (1,1) string = ""
  NameValuePair.YUnitText (1,1) string = ""

  NameValuePair.XScale (1,1) string {mustBeMember(NameValuePair.XScale, ["Linear", "Log"])} = "Linear"
  NameValuePair.YScale (1,1) string {mustBeMember(NameValuePair.YScale, ["Linear", "Log"])} = "Linear"

  NameValuePair.PlotRangeXLowerBound (1,1) double
  NameValuePair.PlotRangeXUpperBound (1,1) double

  NameValuePair.PlotRangeYLowerBound (1,1) double
  NameValuePair.PlotRangeYUpperBound (1,1) double

  NameValuePair.PlotLineWidth (1,1) {mustBePositive} = 1.0

  % ScatterMarker provides a limited set of the Markers property of the scatter chart.
  % https://www.mathworks.com/help/matlab/ref/matlab.graphics.chart.primitive.scatter-properties.html
  NameValuePair.ScatterMarker (1,1) string {mustBeMember(NameValuePair.ScatterMarker, ["+", "*", ".", "x"])} = "x"

  % ScatterMarkerSize corresponds to the SizeData property of the scatter chart, but
  % ScatterMarkerSize supports a scalar value only.
  % The size is in point units, where one point equals 1/72 inch.
  % The default value for scatter's SizeData is 36 points.
  NameValuePair.ScatterSize (1,1) {mustBePositive} = 50

  % ScatterMarkerLineWidth corresponds to the LineWdith property of the scatter chart.
  NameValuePair.ScatterLineWidth (1,1) {mustBePositive} = 1.2
end  % arguments

arguments (Output)
  returnFigure matlab.ui.Figure {mustBeScalarOrEmpty}
end  % arguments

errorID = "plotDifference:";

% There are four combinations for the NewFigure and ParentAxes options.
if not(isfield(NameValuePair, "NewFigure"))
  if not(isfield(NameValuePair, "ParentAxes"))
    % Both NewFigure and ParentAxes are undefined. Create a new figure.
    % This is the default case.
    fig = figure;
    ax = axes(fig);
  else
    % NewFigure is undefined while ParentAxes is defined. Use ParentAxes.
    ax = NameValuePair.ParentAxes;
    cla(ax)
    fig = ax.Parent;
  end  % if
elseif isfield(NameValuePair, "NewFigure")
  if NameValuePair.NewFigure
    % NewFigure is defined as true. Create a new figure. Ignore ParentAxes option.
    fig = figure;
    ax = axes(fig);
  else
    % NewFigure is defined as false. Use ParentAxes.
    if not(isfield(NameValuePair, "ParentAxes"))
      id = errorID + "MissingParentAxes";
      msg = "ParentAxes must be specified when NewFigure is false.";

      throw(MException(id, msg))

    end  % if
    ax = NameValuePair.ParentAxes;
    cla(ax)
    fig = ax.Parent;
  end  % if
end  % if
if nargout > 0
  returnFigure = fig;
end  % if

x_data = data;

y_data = diff(x_data);
y_data = [y_data; y_data(end)];

if isfield(NameValuePair, "PlotXLowerBound")
  x_plot_lower_bound = NameValuePair.PlotRangeXLowerBound;
else
  x_plot_lower_bound = data(1);
end  % if

if isfield(NameValuePair, "PlotXUpperBound")
  x_plot_upper_bound = NameValuePair.PlotRangeXUpperBound;
else
  x_plot_upper_bound = data(end);
end  % if

if isfield(NameValuePair, "PlotYLowerBound")
  y_plot_lower_bound = NameValuePair.PlotRangeYLowerBound;
else
  y_plot_lower_bound = -Inf;
end  % if

if isfield(NameValuePair, "PlotYUpperBound")
  y_plot_upper_bound = NameValuePair.PlotRangeYUpperBound;
else
  y_plot_upper_bound = Inf;
end  % if

if not(isfield(NameValuePair, "PlotYLowerBound")) && not(isfield(NameValuePair, "PlotYUpperBound"))
  % Set the y range to be 0.002 if the distance between max and min of the y data is smaller than 0.002.
  y_min = min(y_data);
  y_max = max(y_data);
  if abs(y_max - y_min) < 0.002
    y_mid = (y_max + y_min)/2;
    y_plot_lower_bound = y_mid - 0.001;
    y_plot_upper_bound = y_mid + 0.001;
  end  % if
end  % if

ax.XScale = NameValuePair.XScale;
ax.YScale = NameValuePair.YScale;

axis(ax, "padded")
hold(ax, "on")
grid(ax, "on")

plot(ax, x_data, y_data, LineWidth=1)

s = scatter(ax, x_data, y_data);
s.Marker = NameValuePair.ScatterMarker;
s.SizeData = NameValuePair.ScatterSize;
s.LineWidth = NameValuePair.ScatterLineWidth;

xlim(ax, [x_plot_lower_bound, x_plot_upper_bound])
ylim(ax, [y_plot_lower_bound, y_plot_upper_bound])

if NameValuePair.Title ~= ""
  % Interpreter must be "none" to prevent the underscore letters from being
  % interpreted as the subscript directive for the TeX or LaTeX interpreter.
  title(ax, NameValuePair.Title, Interpreter="none")
end  % if

if NameValuePair.XLabel ~= "" && NameValuePair.XUnitText ~= ""
  x_label_string = NameValuePair.XLabel + " (" + NameValuePair.XUnitText + ")";
elseif NameValuePair.XLabel ~= "" && NameValuePair.XUnitText == ""
  x_label_string = NameValuePair.XLabel;
elseif NameValuePair.XLabel == "" && NameValuePair.XUnitText ~= ""
  x_label_string = "(" + NameValuePair.XUnitText + ")";
else
  x_label_string = "";
end  % if
xlabel(ax, x_label_string)

if NameValuePair.YLabel ~= "" && NameValuePair.YUnitText ~= ""
  y_label_string = NameValuePair.YLabel + " (" + NameValuePair.YUnitText + ")";
elseif NameValuePair.YLabel ~= "" && NameValuePair.YUnitText == ""
  y_label_string = NameValuePair.YLabel;
elseif NameValuePair.YLabel == "" && NameValuePair.YUnitText ~= ""
  y_label_string = "(" + NameValuePair.YUnitText + ")";
else
  y_label_string = "";
end  % if
ylabel(ax, y_label_string)

hold(ax, "off")
end  % function
