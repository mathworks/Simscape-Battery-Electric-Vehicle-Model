function val = getNumberArrayFromText(ValueString)
% This function converts a string representing a row vector to a column vector containing numbers.
% For example, "[1 2]" is converted to [1; 2].
% Use this function to avoid eval.
% The string must be a plain row vector representation.
% It cannot contain the array-related symbols. For example, "(1:4)" is not accepted.
% Variables cannot exist in the string. For example, "[a 2]" is not accepted.
%
% For slightly more general cases to convert a string containing a MATLAB expression to
% a numeric value, consider using getNumericValueFromText which
% avoids eval in the first pass but uses eval if the first pass failed.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  ValueString (1,1) string  % A string representing a vector
end  % arguments

arguments (Output)
  val double
end  % arguments

errorID = "getNumberArrayFromText:";

tmp_str = strip(ValueString);

% Accept a scalar value.
val = double(tmp_str);
if not(isnan(val))

  return

end  % if

if not(contains(tmp_str, "[")) || not(contains(tmp_str, "]"))
  id = errorID + "InvalidString";
  msg = bevutil1.CodeUtil.i18n("Value must represent an array with ""["" and ""]"".");

  throw(MException(id, msg))

end  % if

% Check if the text represents a row vector.
tmp_str = extractBetween(tmp_str, "[" + optionalPattern(whitespacePattern), optionalPattern(whitespacePattern) + "]");

if contains(tmp_str, ";")
  % Assume height > 1.
  % When the split receives a 1x1 string, it returns the result as a column vector.
  rows_str = split(tmp_str, ";");
  % When the split receives a column vector, it returns the result as a matrix preserving the number of rows.
  rows_str = strip(replace(rows_str, ",", " "));
  % 
  rows_str = split(rows_str, whitespacePattern);
  val = double(rows_str);
else
  % Assume height==1, i.e., a row vector.
  row_str = strip(replace(tmp_str, ",", " "));
  % The split command returns the result as a column vector.
  row_str = transpose(split(row_str, whitespacePattern));
  val = double(row_str);
end  %if

if not(isnan(val))

  return

end  % if

% Some elements were not converted to numeric values.
try
  val = evalin("base", ValueString);

catch exception

  rethrow(exception)

end  % try, catch
end  % function
