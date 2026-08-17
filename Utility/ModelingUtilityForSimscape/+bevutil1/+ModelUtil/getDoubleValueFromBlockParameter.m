function DoubleVal = getDoubleValueFromBlockParameter(FullpathToBlock, ParameterName)
% Get a numeric (double) value for a block parameter of the specified block.
%
% Unlike get_param, this function always returns a numeric value.
% If a block parameter refers to a base workspace variable,
% this function returns an evaluated value.
% If the referred variable is not defined in the base workspace,
% this function produces an error.

% Copyright 2026 The MathWorks, Inc.

% Notes on implementation
%
% Unlike getSimscapeValueFromBlockParameter, this function cannot use
% the "value@param_name" format to get an evaluated value because the "value@"
% prefix text only works with masked block parameters.
%
% !todo:
% In R2025a or newer, a potential improvement is to use
%   evaluateAndCapture
%   https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.evaluateandcapture.html
% together with
%   matlab.lang.Workspace.baseWorkspace
%   https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.baseworkspace.html

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

DoubleVal = v;

end  % function
