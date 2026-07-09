function mustBeNonnegativeOrNan(x)

% MATLAB's mustBeNonnegative rejects nan:
%
%   mustBeNonnegative(nan)
%   Value must be nonnegative.
%
% while this function accepts nan.

% To avoid a confluence of error messages, custom validation functions
% must avoid using function argument validation.

% Copyright 2026 The MathWorks, Inc.

% nan is of type double, i.e., isa(nan, 'double') is true.
if not(isa(x, 'double'))
  id = "mustBeNonnegativeOrNan:InvalidType";
  msg = bev1mus.CodeUtil.i18n("Value must be a double or nan.");

  throw(MException(id, msg))

end  % if

% Comparing nan results in false, i.e.,
% nan <= 0, nan > 0, nan == 0, etc. are false.
if x < 0
  id = "mustBeNonnegativeOrNan:InvalidValue";
  msg = bev1mus.CodeUtil.i18n("Value must be nonnegative or nan.");

  throw(MException(id, msg))

end  % if
end  % function
