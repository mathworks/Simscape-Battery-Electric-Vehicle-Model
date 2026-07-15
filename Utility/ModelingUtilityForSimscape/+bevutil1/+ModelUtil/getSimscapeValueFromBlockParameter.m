function SscVal = getSimscapeValueFromBlockParameter(FullpathToBlock, ParameterName)
% Get a simscape.Value object for a block parameter of the specified Simscape block.
%
% The parameters of Simscape blocks can have physical units.
% This function first collects the value and unit of such a parameter
% and builds a simscape.Value object and then returns it. 
%
% If a block parameter is referring to a base workspace variable,
% this function evaluates the variable and returns numeric data.
% If the referred variable is not defined in the base workspace,
% this function produces an error.
%
% If the specified parameter is not associated with units,
% this function returns a simscape.Value object with unit of "1".
% This is the case, for example, for percent values. 

% Copyright 2023-2026 The MathWorks, Inc.

arguments (Input)
  FullpathToBlock {mustBeText} = ""
  ParameterName {mustBeText} = ""
end  % arguments

arguments (Output)
  SscVal simscape.Value
end  % arguments

errorID = "getSimscapeValueFromBlockParameter:";

if FullpathToBlock == ""
  id = errorID + "EmptyBlockPath";
  msg = bevutil1.CodeUtil.i18n("Block path must be specified.");

  throw(MException(id, msg))

end  % if

if ParameterName == ""
  id = errorID + "EmptyBlockParameterName";
  msg = bevutil1.CodeUtil.i18n("Block parameter name must be specified.");

  throw(MException(id, msg))

end  % if

model_name = extractBefore(FullpathToBlock, "/");

load_system(model_name)

param = get_param(FullpathToBlock, ParameterName);

v = double(string(param));

if isnan(v)
  try
    % Evaluate the target string in the base workspace.

    evaluation_result = evalin("base", param);

  catch exception

    rethrow(exception)

  end  % try, catch

  if not(isnumeric(evaluation_result))

    id = errorID + "Nonnumeric";
    msg = bevutil1.CodeUtil.i18n("Specified parameter must be numeric or evaluated to numeric.");

    throw(MException(id, msg))

  end  % if

  v = evaluation_result;

end  % if

param_unit = get_param(FullpathToBlock, ParameterName + "_unit");

if isempty(param_unit)
  param_unit = "1";
end  % if

SscVal = simscape.Value(v, param_unit);

end  % function
