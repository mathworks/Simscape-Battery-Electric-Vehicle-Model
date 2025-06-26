function [Result, ErrorMessage] = AnalyzeValueString(ValueString)
%% Analyze a string as a value by parsing and evaluating it as an expression
% AnalyzeValueString takes a string representing a value,
% whose class as a result of evaluation must be either double or simscape.Value.
% The string can be a literal number like "1",
% an arithmetic expression like "2*pi - 30/pi",
% or a MATLAB expression containing variables like "sqrt(x^2 + y^2)".
%
% The function evaluates the passed string in base workspace,
% meaning that if the string contains variables, they must exist in base workspace.
% For example, if the string is "sqrt(x^2 + y^2)", x and y must evaluate to
% double or simscape.Value so that the whole string evalues to either of them.
%
% AnalyzeValueString returns an array with 2 elements. The first
% element is a struct containing the result of analysis. The second one is
% a string containing an error message, which is a zero-length string "" in
% case of success.
%
% The Result struct which this function returns has the following fields.
%   Result.Type ... string. Type of the evaluation result. "double" or "simscape.Value".
%   Result.NumericValue ... double. Numeric result of evaluating the passed string.
%   Result.NumericString ... string. String version of Result.NumericValue.
%   Result.PhysicalUnit ... string. Physical unit. Only when evaluation result is simscape.Value.
%
% When evaluating the passed string, MATLAB can throw a runtime exception.
% This function catches an exception from MATLAB and returns it in the second
% returned element as an error message.

% Copyright 2024-2025 The MathWorks, Inc.

arguments(Input)
  ValueString (1,1) string = ""
end  % argument

arguments (Output)
  Result struct {mustBeScalarOrEmpty}
  ErrorMessage (1,1) string
end  % arguments

ErrorMessage = "";

expression_string = ValueString;

if expression_string == ""
  Result = struct;
  Result.Evaluated = false;
  Result.Type = "simscape.Value";
  Result.NumericValue = 1;
  Result.SimscapeValue = simscape.Value(1, "1");
  Result.NumericString = "1";
  Result.PhysicalUnit = "1";

  return

end  % if

% Reject if the string is too long.
% Threshold must be big enough to allow _reasonably_ large matrices.
if strlength(expression_string) > 10000
  ErrorMessage = "Passed value as a string is too long. It must be shorter than 10,000 characters.";
  Result = struct;

  return

end  % if

% Remove leading and trailing whitespaces
expression_string = strtrim(expression_string);
if expression_string == ""
  ErrorMessage = "A string representing a value is required as an argument.";
  Result = struct;

  return

end  % if

% First apply the double and see if evaluation can be avoided.
evaluation_result = double(expression_string);
evaluated = false;
if isnan(evaluation_result)
  evaluated = true;
  try
    evaluation_result = evalin("base", expression_string);
  catch exception
    ErrorMessage = string(exception.message);
    Result = struct;

    return

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
  ErrorMessage = "Invalid expression. Passed string must evaluate to double or simscape.Value.";
  Result = struct;

  return

end  % if

Result.NumericString = LiteApp5.Utility.Stringify(Result.NumericValue, WithoutSpace=true);

% Add physical unit information if the evaluation result was of type simscape.Value.
if Result.Type == "simscape.Value"
  Result.PhysicalUnit = string(unit(evaluation_result));
end  % if

end  % function
