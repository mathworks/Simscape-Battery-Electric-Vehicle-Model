function pass = checkSimscapeUnitsInBlockParameters(BlockPath, ParameterSymbol)
% Check that unit settings in the value and unit of a block parameter are the same.
%
% This function works with Simscape blocks with parameters having units.
% The target model must be loaded before calling this function.
%
% For example, if the block parameter value has var1.value("s") or value(var1, "s"),
% check that the block parameter unit is s.

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string = ""
  ParameterSymbol (1,1) string = ""
end  % arguments

arguments (Output)
  pass (1,1) logical
end  % arguments

param_value_text = string(get_param(BlockPath, ParameterSymbol));
param_unit = string(get_param(BlockPath, ParameterSymbol + "_unit"));

% The value("s") style.
unit_in_value = string(extractBetween(param_value_text, "value(""", """)"));
if unit_in_value == ""
  % The value(var1, "s") style.
  unit_in_value = string(extractBetween(param_value_text, "value(" + wildcardPattern + """", """)"));
end  % if

pass = (unit_in_value == param_unit);

end  % function
