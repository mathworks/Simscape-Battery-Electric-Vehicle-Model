function fig = SimscapePSLookupTable1DBlockPlot(BlockPath, NameValuePair)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string
  NameValuePair.ParentAxes (1,:) matlab.graphics.axis.Axes
end  % arguments

arguments (Output)
  fig matlab.ui.Figure
end  % arguments

errorID = "SimscapePSLookupTable1DBlockPlot:";

model_name = extractBefore(BlockPath, "/");
load_system(model_name)

component_path = string(get_param(BlockPath, "ComponentPath"));
if component_path ~= "foundation.signal.lookup_tables.one_dimensional"
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

fig = SignalTool1.LookupTable1DPlot(x_data, y_data, ...
 PlotXLowerBound = x_data(1), PlotXUpperBound = x_data(end), ...
 Interpolation = interp_method, Extrapolation = extrap_method, ...
 ParentAxes = ax);

end  % function
