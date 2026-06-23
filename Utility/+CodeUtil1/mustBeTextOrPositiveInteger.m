function mustBeTextOrPositiveInteger(x)

% Copyright 2023-2025 The MathWorks, Inc.

is_pos_int = @(v) isnumeric(v) && isscalar(v) && round(v) == v && v > 0;

is_a_string = @(v) isstring(v) && all(size(v) == [1 1]);

is_a_char_array = @(v) ischar(v) && height(v) == 1;

if not(is_pos_int(x) || is_a_string(x) || is_a_char_array(x))
  id = "mustBeTextOrPositiveInteger:NotTextNorPositiveInteger";
  msg = CodeUtil1.i18n("Input must be either a positive integer, a string, or a char array.");

  throw(MException(id, msg))

end  % if
end  % function
