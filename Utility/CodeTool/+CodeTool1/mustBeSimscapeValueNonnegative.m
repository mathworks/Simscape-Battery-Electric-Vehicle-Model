function mustBeSimscapeValueNonnegative(x)
% Custom validation functions like this one must avoid using function argument validation.

% Copyright 2024 The MathWorks, Inc.

if value(x) < 0
  id = "sdlUtilityValidationSimscapeValue:notNonnegative";
  message = "Value must be non-negative.";
  error(id, message)
end  % if

end  % function
