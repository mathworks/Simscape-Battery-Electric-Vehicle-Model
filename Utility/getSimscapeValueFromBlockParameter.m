function sscVal = getSimscapeValueFromBlockParameter(fullpathToBlock, parameterName)
%% Returns Simscape value object for a block parameter of Simscape block 
% Parameters of Simscape blocks can have physical units.
% This function collects the value and unit of such a parameter
% and builds a Simscape value object,
% which is the return value of this function.
%
% To get a value in your expected physical unit,
% use value() function for the returned Simscape value object as follows.
%
%   ssc_val = getSimscapeValueFromBlockParameter("path/to/block", "Mass");
%   m_kg = value(ssc_va, "kg");
%
% If the specified parameter is not associated with units,
% this function returns a Simscape  value object with unit of "1".
% This is the case, for example, for percent values. 

% Copyright 2023 The MathWorks, Inc.

arguments
  fullpathToBlock {mustBeText} = ""
  parameterName {mustBeText} = ""
end

% Collect mask workspace variables.
% They have been evaluated.
% See the documentation for Simulink.VariableUsage.
maskVars = get_param(fullpathToBlock, "MaskWSVariables");

varNames = string({maskVars.Name});
varValues = {maskVars.Value};

variable = varValues{varNames == parameterName};

variable_unit = varValues{varNames == parameterName+"_unit"};
if variable_unit == ""
  variable_unit = "1";
end

sscVal = simscape.Value(variable, variable_unit);

end  % function
