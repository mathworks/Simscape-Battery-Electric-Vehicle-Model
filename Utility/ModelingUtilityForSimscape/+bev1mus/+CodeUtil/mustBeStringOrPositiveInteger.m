function mustBeStringOrPositiveInteger(x)

% Copyright 2023-2025 The MathWorks, Inc.

is_pos_int = @(v) isnumeric(v) && isscalar(v) && round(v) == v && v > 0;

is_a_string = @(v) isstring(v) && all(size(v) == [1 1]);

if not(is_pos_int(x) || is_a_string(x))
  id = "mustBeStringOrPositiveInteger:NotStringNorPositiveInteger";
  msg = bev1mus.CodeUtil.i18n("Input must be a string or a positive integer.");

  throw(MException(id, msg))

end  % if
end  % function
