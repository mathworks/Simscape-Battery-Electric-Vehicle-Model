function mustBePositiveOrNan(x)

% MATLAB's mustBePositive rejects nan:
%
%   mustBePositive(nan)
%   Value must be positive.
%
% while this function accepts nan.

% To avoid a confluence of error messages, custom validation functions
% must avoid using function argument validation.

% Copyright 2026 The MathWorks, Inc.

% nan is of type double, i.e., isa(nan, 'double') is true.
if not(isa(x, 'double'))
  id = "mustBePositiveOrNan:InvalidType";
  msg = CodeUtil1.i18n("Value must be a double or nan.");

  throw(MException(id, msg))

end  % if

% Comparing nan results in false, i.e.,
% nan <= 0, nan > 0, nan == 0, etc. are false.
if x <= 0
  id = "mustBePositiveOrNan:InvalidValue";
  msg = CodeUtil1.i18n("Value must be positive or nan.");

  throw(MException(id, msg))

end  % if
end  % function
