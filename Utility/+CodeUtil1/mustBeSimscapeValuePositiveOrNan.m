function mustBeSimscapeValuePositiveOrNan(x)

% To avoid a confluence of error messages, custom validation functions
% must avoid using function argument validation.

% Copyright 2024-2026 The MathWorks, Inc.

if not(isa(x, 'simscape.Value')) && not(isnan(x))
  id = "mustBeSimscapeValuePositiveOrNan:InvalidType";
  msg = CodeUtil1.i18n("Value must be a simscape.Value or nan.");

  throw(MException(id, msg))

end  % if

% Comparing nan results in false, i.e.,
% nan <= 0, nan > 0, nan == 0, etc. are false.
if value(x) <= 0
  id = "mustBeSimscapeValuePositiveOrNan:InvalidValue";
  msg = CodeUtil1.i18n("Value must be positive or nan.");

  throw(MException(id, msg))

end  % if
end  % function
