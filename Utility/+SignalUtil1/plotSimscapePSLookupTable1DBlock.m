function ReturnFigure = plotSimscapePSLookupTable1DBlock(BlockPath, NameValuePair)

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

errorID = "plotSimscapePSLookupTable1DBlock:";

model_name = extractBefore(BlockPath, "/");
load_system(model_name)

if not(ModelUtil1.isSimscapePSLookupTable1DBlock(BlockPath))
  id = errorID + "InvalidBlock";
  msg = "Specified block is not PS Lookup Table (1D) block: " + BlockPath;

  throw(MException(id, msg))

end  % if

x_data = eval(get_param(BlockPath, "x"));  % !todo: avoid eval
y_data = eval(get_param(BlockPath, "f"));  % !todo: avoid eval

interp_method = extractAfter(get_param(BlockPath, "interp_method"), asManyOfPattern(alphanumericsPattern + "."));
interp_method = [upper(interp_method(1)) interp_method(2:end)];  % Capitalize

extrap_method = extractAfter(get_param(BlockPath, "extrap_method"), asManyOfPattern(alphanumericsPattern + "."));
extrap_method = [upper(extrap_method(1)) extrap_method(2:end)];  % Capitalize

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

fig = SignalUtil1.plotLookupTable1D(x_data, y_data, ...
  PlotXLowerBound = x_plot_lower_bound, PlotXUpperBound = x_plot_upper_bound, ...
  Interpolation = interp_method, Extrapolation = extrap_method, ...
  InterpolationInterval = dx, ...
  ParentAxes = ax, ...
  Title = title_text);

if nargout > 0
  ReturnFigure = fig;
end  % if
end  % function
