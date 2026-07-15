function mustBeTextOrNonnegativeNumber(x)

% Copyright 2025 The MathWorks, Inc.

is_nonneg_num = @(v) isnumeric(v) && isscalar(v) && v >= 0;

is_a_string = @(v) isstring(v) && all(size(v) == [1 1]);

is_a_char_array = @(v) ischar(v) && height(v) == 1;

if not(is_nonneg_num(x) || is_a_string(x) || is_a_char_array(x))
  id = "mustBeTextOrNonnegativeNumber:NotTextNorNonnegativeNumber";
  msg = bevutil1.CodeUtil.i18n("Input must be either a non-negative number, a string, or a char array.");

  throw(MException(id, msg))

end  % if
end  % function
