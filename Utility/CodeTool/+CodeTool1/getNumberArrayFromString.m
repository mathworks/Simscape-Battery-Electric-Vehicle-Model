function val = getNumberArrayFromString(ValueString)
% This function converts a string representing a row vector to a column vector containing numbers.
% For example, "[1 2]" is converted to [1; 2].
% Use this function to avoid eval.
% The string must be a plain row vector representation.
% It cannot contain the array-related symbols. For example, "(1:4)" is not accepted.
% Variables cannot exist in the string. For example, "[a 2]" is not accepted.
%
% For slightly more general cases to convert a string containing a MATLAB expression to
% a numeric value, consider using getNumericValueFromString which
% avoids eval in the first pass but uses eval if the first pass failed.

% Copyright 2025 The MathWorks, Inc.

% !todo: Improve return type consistency with getNumericValueFromString.
% This function and getNumericValueFromString have very similar function names,
% but their return types are very different.

arguments (Input)
  ValueString (1,1) string  % A string representing a vector
end  % arguments

arguments (Output)
  val (:,1) double
end  % arguments

errorID = "getNumberArrayFromString:";

if contains(ValueString, ";") || not(contains(ValueString, "[")) || not(contains(ValueString, "]"))
  id = errorID + "InvalidString";
  msg = CodeTool1.i18n("Passed string is invalid.");

  throw(MException(id, msg))

end  % if

tmp_str = extractBetween(ValueString, "[" + optionalPattern(whitespacePattern), optionalPattern(whitespacePattern) + "]");
tmp_str = replace(tmp_str, ",", " ");
tmp_str = split(tmp_str, whitespacePattern);

val = double(tmp_str);

% Use the width function to validate that the result is a column vector.
if not(isnumeric(val)) || isempty(val) || isscalar(val) || (width(val) > 1) || any(isnan(val))
  id = errorID + "InvalidString";
  msg = CodeTool1.i18n("The passed string is not convertible to an array: ") + ValueString;

  throw(MException(id, msg))

end  % if
end  % function
