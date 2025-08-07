function returnFigure = plotLookupTable1D(x_data, y_data, NameValuePair)
% Make a plot of a curve and specified data points.
%
% As the function name indicates, the function takes data usually used to specify
% lookup table data, one for input data points, and the other for output data points.
% The function builds a curve from the specified data together with interpolation
% interval, which can be optionally specified. Specified data points are also plotted
% using the scatter plot.
%
% The function supports smooth, linear, or flat interpolation.
% Smooth interpolation is modified Akima spline interpolation.
% Linear interpolation is piece-wise linear interpolation.
% Flat interpolation is piece-wise constant interpolation.
% The keywords to specify interpolation type are those used in
% Simscape PS Lookup Table (1D) block or
% Simulink 1-D Lookup Table block.
%
% The function supports nearest or linear extrapolation.
% Extrapolation option is ignored if the Interpolation option is Flat.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  % BlockPath
  x_data (1,:) double {mustBeVector} = [0, 1, 2, 4, 7, 8, 9]
  y_data (1,:) double {mustBeVector} = [0, 0, 0, 2, 1, 1, 1]

  % If NewFigure is true, ParentAxes is ignored.
  NameValuePair.NewFigure (1,:) logical {mustBeScalarOrEmpty}
  NameValuePair.ParentAxes (1,:) matlab.graphics.axis.Axes {mustBeScalarOrEmpty}

  NameValuePair.Title (1,1) string = ""
  NameValuePair.XLabel (1,1) string = ""
  NameValuePair.YLabel (1,1) string = ""

  % X and Y unit texts are used in xlabel and ylabel, respectively.
  NameValuePair.XUnitText (1,1) string = ""
  NameValuePair.YUnitText (1,1) string = ""

  % Interpolation interval
  NameValuePair.InterpolationInterval (1,1) double {mustBeNonnegative} = 0.1

  NameValuePair.PlotXLowerBound (1,1) double
  NameValuePair.PlotXUpperBound (1,1) double

  % "Linear" and "Smooth" are the same as Simscape PS Lookup Table (1D) block.
  % "Linear point-slope" and "Akima spline" are the same as Simulink 1-D Lookup Table block.
  NameValuePair.Interpolation (1,1) string {mustBeMember(NameValuePair.Interpolation, ["Linear", "Smooth", "Linear point-slope", "Akima spline", "Flat"])} = "Smooth"

  % "Linear" and "Nearest" are the same as Simscape PS Lookup Table (1D) block.
  % "Linear" is also the same Simulink 1-D Lookup Table block.
  % When Simulink 1-D Lookup Table block uses "Akima spline" for interpolation,
  % extrapolation is automatically set to "Akima spline" which users cannot change.
  % In this function, "Nearest" is used for extrapolation.
  NameValuePair.Extrapolation (1,1) string {mustBeMember(NameValuePair.Extrapolation, ["Linear", "Nearest"])} = "Nearest"

end  % arguments

arguments (Output)
  returnFigure matlab.ui.Figure {mustBeScalarOrEmpty}
end  % arguments

errorID = "plotLookupTable1D:";

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

dx = NameValuePair.InterpolationInterval;
x_query = x_data(1) : dx : x_data(end);

if isfield(NameValuePair, "PlotXLowerBound")
  x_plot_lower_bound = NameValuePair.PlotXLowerBound;
else
  x_plot_lower_bound = x_data(1);
end  % if
if x_plot_lower_bound < x_query(1)
  x_query = [x_plot_lower_bound, x_query];
end  % if

if isfield(NameValuePair, "PlotXUpperBound")
  x_plot_upper_bound = NameValuePair.PlotXUpperBound;
else
  x_plot_upper_bound = x_data(end);
end  % if
if x_plot_upper_bound > x_query(end)
  x_query = [x_query, x_plot_upper_bound];
end  % if

if NameValuePair.Interpolation == "Linear" || NameValuePair.Interpolation == "Linear point-slope"
  % "Linear" for Simscape. "Linear point-slope" for Simulnk.

  if NameValuePair.Extrapolation == "Linear"
    y_refined = interp1(x_data, y_data, x_query, "linear", "extrap");

  else
    % extrapolation "Nearest"
    y_refined = interp1(x_data, y_data, x_query, "linear", y_data(end));

  end  % if

elseif NameValuePair.Interpolation == "Smooth" || NameValuePair.Interpolation == "Akima spline"
  % "Smooth" for Simscape. "Akima spline" for Simulnk.

  if NameValuePair.Extrapolation == "Linear"
    y_refined = interp1(x_data, y_data, x_query, "makima", "extrap");

  else
    % extrapolation "Nearest"
    y_refined = interp1(x_data, y_data, x_query, "makima", y_data(end));

  end  % if

else
  % Piece-wise constant.
  % "Flat" in Simulink 1-D Lookup Table block.

  y_refined = interp1(x_data, y_data, x_query, "previous", y_data(end));

end  % if

plot(ax, x_query, y_refined, LineWidth=1.5)
hold(ax, "on")

scatter_property = scatter(ax, x_data, y_data);
scatter_property.Marker = "x";
scatter_property.LineWidth = 1.5;
scatter_property.SizeData = 36;

axis(ax, "padded")
xlim(ax, [x_plot_lower_bound, x_plot_upper_bound])

grid(ax, "on")

if NameValuePair.Title ~= ""
  % Interpreter must be "none" to prevent the underscore latters from being
  % interpreted as subscript directive for the TeX or LaTeX interpreter.
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
