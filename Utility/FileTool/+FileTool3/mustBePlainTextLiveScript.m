function mustBePlainTextLiveScript(filenames)
% This function checks that the specified filenames are plain-text Live Scripts.
%
% You can use this function as a validation function for function argument validation.
% For more information, see the documentation.
% https://www.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html

% Copyright 2025 The MathWorks, Inc.

% To avoid a confluence of error messages, custom validation functions
% must avoid using function argument validation.

errorID = "mustBePlainTextLiveScript:";

logical_index = FileTool3.isPlainTextLiveScript(filenames);

if not(all(logical_index))
  id = errorID + "NotPlainTextLiveScript";

  if isscalar(filenames)
    msg = "File is not plain-text Live Script: " + filenames;
  else
    msg = "Files are not plain-text Live Script:" + newline + join(filenames(not(logical_index)), newline);
  end  % if

  throw(MException(id, msg))

end  % if
end  % function
