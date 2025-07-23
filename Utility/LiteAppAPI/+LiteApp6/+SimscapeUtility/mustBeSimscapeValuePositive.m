function mustBeSimscapeValuePositive(x)
% Custom validation functions like this one must avoid using function argument validation.

% Copyright 2024 The MathWorks, Inc.

if value(x) <= 0
  id = "sdlUtilityValidationSimscapeValue:notPositive";
  message = "Value must be positive.";
  error(id, message)
end  % if

end  % function
