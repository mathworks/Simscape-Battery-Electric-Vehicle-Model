function Result = getDoubleOrSimscapeValueFromText(ValueText, NameValuePair)
% Get a value of type double or simscape.Value from a text string.
%
% This function takes a string and converts it to a value of type double or simscape.Value.
% If the given text is zero-length text "" or reduces to it after removing spaces,
% this function returns nan.
%
% The string can be
% - Literal number like "1"
% - Arithmetic expression like "2*pi - 30/pi"
% - MATLAB expression containing variables like "sqrt(x^2 + y^2)"
%
% This function avoids evaluation in the first pass,
% but it does do evaluation in the second pass if necessary.
%
% If the string contains variables, they must exist in the base workspace.
% For example, if the string is "sqrt(x^2 + y^2)", x and y must evaluate
% in the base workspace to double or simscape.Value.

% !todo: Parse a text representing an array or a matrix.
%   ValueText="[1 2 3]"
%   ValueText="[1 2; 3 4]"
% This could be done after the double returning nan and before resorting to evalin.

% !todo: Detect comments and remove them.
% Example:
%   ValueText="1 % comment"
% Note that percent symbols can appear within a single-quoted or double-quoted
% text, which should not be misinterpreted as comment start.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Input)
  ValueText (1,1) string = ""

  % MaxTextLength prevents this function from processing the given text.
  % The value needs to be big enough to accept a textual representation of a large matrix.
  NameValuePair.MaxTextLength (1,1) {mustBeInteger, mustBePositive} = 1e6
end  % argument

arguments (Output)
  Result {mustBeA(Result, ["double", "simscape.Value"])}
end  % arguments

functionID = "getDoubleOrSimscapeValueFromText:";

if strlength(ValueText) > NameValuePair.MaxTextLength
  id = functionID + "TextIsTooLong";
  msg = bev1mus.CodeUtil.i18n("Text must be shorter than MaxTextLength.");

  throw(MException(id, msg))

end  % if

% Remove leading and trailing whitespaces
ValueText = strip(ValueText);
if ValueText == ""
  Result = nan;

  return

end  % if

% First apply the double and see if evaluation is unnecessary.
Result = double(ValueText);
if isnan(Result)
  try
    % Evaluation is necessary.
    Result = evalin("base", ValueText);
  catch exception
    id = functionID + "EvaluationFailed";
    msg = string(exception.message);

    throw(MException(id, msg))

  end  % try, catch
end  % if

if not(isa(Result, "double")) && not(isa(Result, "simscape.Value"))
  id = functionID + "InvalidDataType";
  msg = bev1mus.CodeUtil.i18n("Text must evaluate to double or simscape.Value.");

  throw(MException(id, msg))

end  % if
end  % function
