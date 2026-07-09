function DoubleVal = getDoubleValueFromBlockParameter(FullpathToBlock, ParameterName)
% Get a numeric (double) value for a block parameter of the specified block.
%
% Unlike get_param, this function always returns a numeric value.
% If a block parameter is referring to a base workspace variable, evaluation is done.
% If the referred variable is not defined in the base workspace,
% this function produces an error.

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  FullpathToBlock {mustBeText} = ""
  ParameterName {mustBeText} = ""
end  % arguments

arguments (Output)
  DoubleVal double
end  % arguments

errorID = "getDoubleValueFromBlockParameter:";

if FullpathToBlock == ""
  id = errorID + "EmptyBlockPath";
  msg = bev1mus.CodeUtil.i18n("Block path must be specified.");

  throw(MException(id, msg))

end  % if

if ParameterName == ""
  id = errorID + "EmptyBlockParameterName";
  msg = bev1mus.CodeUtil.i18n("Block parameter name must be specified.");

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
    msg = bev1mus.CodeUtil.i18n("Specified parameter must be numeric or evaluated to numeric.");

    throw(MException(id, msg))

  end  % if

  v = evaluation_result;

end  % if

DoubleVal = v;

end  % function
