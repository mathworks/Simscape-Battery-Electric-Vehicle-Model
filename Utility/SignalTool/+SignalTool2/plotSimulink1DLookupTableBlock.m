function ReturnFigure = plotSimulink1DLookupTableBlock(BlockPath, NameValuePair)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string
  NameValuePair.ParentAxes (1,:) matlab.graphics.axis.Axes
  NameValuePair.DivisionType {mustBeMember(NameValuePair.DivisionType, ["Divisions", "InterpolationInterval"])} = "Divisions"
  NameValuePair.Divisions (1,:) {mustBeInteger, mustBePositive} = 200
  NameValuePair.InterpolationInterval (1,:) {mustBePositive}
  NameValuePair.Title (1,:) string
  NameValuePair.PlotXLowerBound (1,1) double
  NameValuePair.PlotXUpperBound (1,1) double
end  % arguments

arguments (Output)
  ReturnFigure {mustBeScalarOrEmpty, mustBeA(ReturnFigure, ["matlab.ui.Figure", "matlab.graphics.layout.TiledChartLayout"])}
end  % arguments

errorID = "plotSimulink1DLookupTableBlock:";

model_name = extractBefore(BlockPath, "/");
load_system(model_name)

if not(ModelTool1.isSimulink1DLookupTableBlock(BlockPath))
  id = errorID + "InvalidBlock";
  msg = "Specified block is not 1-D Lookup Table block: " + BlockPath;

  throw(MException(id, msg))

end  % if

x_data = eval(get_param(BlockPath, "BreakpointsForDimension1"));
y_data = eval(get_param(BlockPath, "Table"));

interp_method = get_param(BlockPath, "InterpMethod");
extrap_method = get_param(BlockPath, "ExtrapMethod");

if isfield(NameValuePair, "ParentAxes")
  ax = NameValuePair.ParentAxes;
else
  ax = axes(figure);
end  % if

switch NameValuePair.DivisionType
case "Divisions"
  dx = (x_data(end) - x_data(1)) / NameValuePair.Divisions;
case "InterpolationInterval"
  dx = NameValuePair.InterpolationInterval;
end  % switch

if isfield(NameValuePair, "Title")
  title_text = NameValuePair.Title;
else
  title_text = replace(BlockPath, "/", " / ");
end  % if

if isfield(NameValuePair, "PlotXLowerBound")
  x_plot_lower_bound = NameValuePair.PlotXLowerBound;
else
  x_plot_lower_bound = x_data(1);
end  % if

if isfield(NameValuePair, "PlotXUpperBound")
  x_plot_upper_bound = NameValuePair.PlotXUpperBound;
else
  x_plot_upper_bound = x_data(end);
end  % if

fig = SignalTool2.plotLookupTable1D(x_data, y_data, ...
  PlotXLowerBound = x_plot_lower_bound, PlotXUpperBound = x_plot_upper_bound, ...
  Interpolation = interp_method, Extrapolation = extrap_method, ...
  InterpolationInterval = dx, ...
  ParentAxes = ax, ...
  Title = title_text);

if nargout > 0
  ReturnFigure = fig;
end  % if
end  % function
