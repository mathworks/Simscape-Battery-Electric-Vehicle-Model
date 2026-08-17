function mustBeNumericValueStringOrValidNameOrEmpty(x)

% x must be of type string. The char is converted to string.
% Examples of acceptable string for x:
%   p.q
%   p.q.r
%   value(a)
%   value(p.q)
%   value(p.q.r)
%   value(L  "1")
%   value(5, "m^2")
%   value(p.q, "s")
%   value(p.q.r, "s")

% Copyright 2025 The MathWorks, Inc.

if ischar(x)
  x = string(x);
end  % if

if not(isstring(x))
  id = "mustBeNumericValueStringOrValidNameOrEmpty:NotString";
  msg = bevutil1.CodeUtil.i18n("Value must be a string.");

  throw(MException(id, msg))

end  % if

% Accept a zero-length string.
if x == ""

  return

end  % if

% Accept a real scalar value.
if not(isnan(double(x)))

  return

end  % if

% Accept a variable name, such as "a", "var1", "k_0" etc.
varname_pattern = lettersPattern + optionalPattern(asManyOfPattern(lettersPattern | digitsPattern | "_"));
if matches(x, varname_pattern)

  return

end  % if

% Accept a struct field, up to two-levels deep:
%   p.q
%   p.q.r
fieldname_pattern = varname_pattern + "." + varname_pattern + optionalPattern("." + varname_pattern);
if matches(x, fieldname_pattern)

  return

end  % if

% Accept the value function of a simscape.Value object without unit specification.
%   value(a)
%   value(p.q)
value_pattern_1 = "value(" + (varname_pattern|fieldname_pattern) + ")";
if matches(x, value_pattern_1)

  return

end  % if

% Accept the value function of a simscape.Value object with unit specification.
%   value(L  "1")
%   value(5, "m^2")
%   value(p.q, "s")
%   value(p.q.r, "s")
q = (""""|"'");
% quoted_one = q + "1" + q;
% This unit string pattern is a simple validation, not strictly validiting as simscape.Unit.
unit_pattern = ("1"|(lettersPattern + optionalPattern(asManyOfPattern(lettersPattern|digitsPattern|"/"|"*"|"^"|"("|")"))));
value_pattern_2 = "value(" + (varname_pattern|fieldname_pattern) + "," + whitespacePattern + q + unit_pattern + q + ")";
if matches(x, value_pattern_2)

  return

end  % if

id = "mustBeNumericValueStringOrValidNameOrEmpty:ValidationFailed";
msg = bevutil1.CodeUtil.i18n("Value must be convertible to either a real scalar, a variable, or a struct field.");

throw(MException(id, msg))

end  % function
