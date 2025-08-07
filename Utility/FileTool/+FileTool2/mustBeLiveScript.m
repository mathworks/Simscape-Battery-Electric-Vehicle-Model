function mustBeLiveScript(filenames)
% This function checks that the specified filenames are Live Scripts.
%
% You can use this function as a validation function for function argument validation.
% For more information, see the documentation.
% https://www.mathworks.com/help/matlab/matlab_prog/argument-validation-functions.html

% Copyright 2025 The MathWorks, Inc.

% To avoid a confluence of error messages, custom validation functions
% must avoid using function argument validation.

errorID = "mustBeLiveScript:";

logical_index = FileTool2.isLiveScript(filenames);

if not(all(logical_index))
  id = errorID + "NotLiveScript";

  if isscalar(filenames)
    msg = "File is not Live Script: " + filenames;
  else
    msg = "Files are not Live Script:" + newline + join(filenames(not(logical_index)), newline);
  end  % if

  throw(MException(id, msg))

end  % if
end  % function
