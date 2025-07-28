function fig = Simulink1DLookupTableBlockPlot(BlockPath, NameValuePair)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string
  NameValuePair.ParentAxes (1,:) matlab.graphics.axis.Axes
end  % arguments

arguments (Output)
  fig matlab.ui.Figure
end  % arguments

errorID = "Simulink1DLookupTableBlockPlot:";

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

dx = (x_data(end) - x_data(1)) / 200;

styled_block_path = replace(BlockPath, "/", " / ");

fig = SignalTool1.LookupTable1DPlot(x_data, y_data, ...
  PlotXLowerBound = x_data(1), PlotXUpperBound = x_data(end), ...
  Interpolation = interp_method, Extrapolation = extrap_method, ...
  InterpolationInterval = dx, ...
  ParentAxes = ax, ...
  Title = styled_block_path);

end  % function
