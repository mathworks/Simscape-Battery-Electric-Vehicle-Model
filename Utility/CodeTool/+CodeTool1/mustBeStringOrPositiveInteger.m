function mustBeStringOrPositiveInteger(x)

% Copyright 2023-2025 The MathWorks, Inc.

is_pos_int = @(v) isnumeric(v) && isscalar(v) && round(v) == v && v > 0;

is_a_string = @(v) isstring(v) && all(size(v) == [1 1]);

if not(is_pos_int(x) || is_a_string(x))
  errorID = "Type:notCorrectType";
  error_message = "Input must be a string or a positive integer.";
  throw(MException(errorID, error_message))
end  % if

end  % function
