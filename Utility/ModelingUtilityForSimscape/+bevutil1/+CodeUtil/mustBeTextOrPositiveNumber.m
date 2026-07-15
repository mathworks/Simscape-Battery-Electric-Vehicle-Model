function mustBeTextOrPositiveNumber(x)
% Validate that the argument is either a text or a positive integer.

% Copyright 2023-2026 The MathWorks, Inc.

% One intended use case of this validator is for the ColumnWidth property of uigridlayout,
% for example, {'fit', 200, '2x', '1x'}.

is_pos_num = @(v) isnumeric(v) && isscalar(v) && v > 0;

is_a_string = @(v) isstring(v) && all(size(v) == [1 1]);

is_a_char_array = @(v) ischar(v) && height(v) == 1;

if not(is_pos_num(x) || is_a_string(x) || is_a_char_array(x))
  id = "mustBeTextOrPositiveNumber:NotTextNorPositiveNumber";
  msg = bevutil1.CodeUtil.i18n("Input must be either a positive number, a string, or a char array.");

  throw(MException(id, msg))

end  % if
end  % function
