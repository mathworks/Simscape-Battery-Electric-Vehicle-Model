function ReturnFigure = plotSimulink1DLookupTableBlock(BlockPath, NameValuePair)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string
  NameValuePair.ParentAxes (1,:) matlab.graphics.axis.Axes
  NameValuePair.DivsionType {mustBeMember(NameValuePair.DivsionType, ["Divisions", "InterpolationInterval"])} = "Divisions"
  NameValuePair.Divisions (1,:) {mustBeInteger, mustBePositive} = 200
  NameValuePair.InterpolationInterval (1,:) {mustBePositive}
end  % arguments

arguments (Output)
  ReturnFigure matlab.ui.Figure
end  % arguments

errorID = "plotSimulink1DLookupTableBlock:";

model_name = extractBefore(BlockPath, "/");
load_system(model_name)

block_type = get_param(BlockPath, "BlockType");
table_dim = get_param(BlockPath, "NumberOfTableDimensions");
if not(block_type == "Lookup_n-D" && table_dim == "1")
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

switch NameValuePair.DivsionType
case "Divisions"
  dx = (x_data(end) - x_data(1)) / NameValuePair.Divisions;
case "InterpolationInterval"
  dx = NameValuePair.InterpolationInterval;
end  % switch

styled_block_path = replace(BlockPath, "/", " / ");

fig = SignalTool2.plotLookupTable1D(x_data, y_data, ...
  PlotXLowerBound = x_data(1), PlotXUpperBound = x_data(end), ...
  Interpolation = interp_method, Extrapolation = extrap_method, ...
  InterpolationInterval = dx, ...
  ParentAxes = ax, ...
  Title = styled_block_path);

if nargout > 0
  ReturnFigure = fig;
end  % if
end  % function
