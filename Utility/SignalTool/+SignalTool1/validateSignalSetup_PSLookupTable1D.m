function Validated = validateSignalSetup_PSLookupTable1D(BlockPath)
%% Check that signal design matrix text matches the xdata and ydata block parameters

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string
end  % arguments

arguments (Output)
  Validated (1,1) logical
end  % arguments

errorID = "validateSignalSetup_PSLookupTable1D:";

model_name = extractBefore(BlockPath, "/");
load_system(model_name)

component_path = string(get_param(BlockPath, "ComponentPath"));
if component_path ~= "foundation.signal.lookup_tables.one_dimensional"
  id = errorID + "InvalidBlock";
  msg = "Specified block is not PS Lookup Table (1D) block: " + BlockPath;

  throw(MException(id, msg))

end  % if

% If block parameters are referring to workspace variables but if they are undefined,
% the following code throws an exception.
block_xdata = eval(get_param(BlockPath, "x"));  % !todo: avoid eval
block_ydata = eval(get_param(BlockPath, "f"));  % !todo: avoid eval

interp_method = extractAfter(get_param(BlockPath, "interp_method"), asManyOfPattern(alphanumericsPattern + "."));
if interp_method ~= "smooth"
  id = errorID + "InvalidInterpolation";
  msg = "Interpolation must be ""smooth"".";

  throw(MException(id, msg))

end  % if

% !todo: Check extrapolation setting? Much less important than interpolation.
% extrap_method = extractAfter(get_param(BlockPath, "extrap_method"), asManyOfPattern(alphanumericsPattern + "."));

design_matrix = SignalTool1.getSignalDesignMatrixFromBlockDescription(BlockPath);
result = SignalTool1.getXYVectorsFromSignalDesignMatrix(design_matrix);
derived_xdata = result.X';
derived_ydata = result.Y';

% The following two lines can throw an exception.
dx = block_xdata - derived_xdata;
dy = block_ydata - derived_ydata;

x_validity = all(abs(dx) < 1e-6);
y_validity = all(abs(dy) < 1e-6);

Validated = x_validity & y_validity;

end  % function
