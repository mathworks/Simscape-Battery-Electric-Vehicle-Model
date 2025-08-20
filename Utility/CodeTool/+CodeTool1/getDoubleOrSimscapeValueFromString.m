function Result = getDoubleOrSimscapeValueFromString(ValueString)
% Get a value of type double or simscape.Value from a string.
%
% This function takes a string and converts it to a value of type double or simscape.Value.
%
% The string can be
% - Lliteral number like "1"
% - Arithmetic expression like "2*pi - 30/pi"
% - MATLAB expression containing variables like "sqrt(x^2 + y^2)"
%
% This function avoids evaluation in the first pass,
% but it does do evaluation in the second pass if necessary.
%
% If the string contains variables, they must exist in the base workspace.
% For example, if the string is "sqrt(x^2 + y^2)", x and y must evaluate to
% double or simscape.Value.
%
% This function returns a struct containing the following fields.
%   Result.Type ... string. Type of the evaluation result. "double" or "simscape.Value".
%   Result.NumericValue ... double. Numeric result of evaluating the passed string.
%   Result.NumericString ... string. String version of Result.NumericValue.
%   Result.PhysicalUnit ... string. Physical unit. Only when evaluation result is simscape.Value.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Input)
  ValueString (1,1) string = ""
end  % argument

arguments (Output)
  Result struct {mustBeScalarOrEmpty}
end  % arguments

errorID = "getDoubleOrSimscapeValueFromString:";

expression_string = ValueString;

if expression_string == ""
  id = errorID + "InvalidString";
  msg = CodeTool1.i18n("Empty string is not accepted.");

  throw(MException(id, msg))

end  % if

% Reject if the string is too long.
% Rejection threshold must be big enough to accept _reasonably_ large matrices.
if strlength(expression_string) > 10000
  id = errorID + "StringTooLong";
  msg = CodeTool1.i18n("Passed value as a string is too long. It must be shorter than 10,000 characters.");

  throw(MException(id, msg))

end  % if

% Remove leading and trailing whitespaces
expression_string = strtrim(expression_string);
if expression_string == ""
  id = errorID + "InvalidString";
  msg = CodeTool1.i18n("Given string was empty.");

  throw(MException(id, msg))

end  % if

% First apply the double and see if evaluation is unnecessary.
evaluation_result = double(expression_string);
evaluated = false;
if isnan(evaluation_result)
  evaluated = true;
  try
    evaluation_result = evalin("base", expression_string);
  catch exception
    id = errorID + "EvaluationFailed";
    msg = string(exception.message);

    throw(MException(id, msg))

  end  % try, catch
end  % if
Result.Evaluated = evaluated;

Result.Type = string(class(evaluation_result));

if Result.Type == "double"
  Result.NumericValue = evaluation_result;
elseif Result.Type == "simscape.Value"
  Result.NumericValue = value(evaluation_result);
  Result.SimscapeValue = evaluation_result;
else
  id = errorID + "InvalidDataType";
  msg = CodeTool1.i18n("Passed string must evaluate to double or simscape.Value.");

  throw(MException(id, msg))

end  % if

Result.NumericString = CodeTool1.stringify(Result.NumericValue, WithoutSpace=true);

% Add physical unit information if the evaluation result was of type simscape.Value.
if Result.Type == "simscape.Value"
  Result.PhysicalUnit = string(unit(evaluation_result));
end  % if

end  % function
