function mustBeAppConfig(x)
% This validation function checks that
% This is meant to be used by the buildJSONTextFromAppConfig function.

% Copyright 2025 The MathWorks, Inc.

class_name_string = string(class(x));
if not(endsWith(class_name_string, "AppConfig"))
  errorID = "mustBeAppConfig:validationFailed";
  error_text = "Specified object is of type " + class_name_string + ", but it must be an object of AppConfig class.";

  throw(MException(errorID, error_text))

end  % if
end  % function
