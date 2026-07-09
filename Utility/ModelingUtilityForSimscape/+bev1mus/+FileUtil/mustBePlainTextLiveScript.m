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

logical_index = bev1mus.FileUtil.isPlainTextLiveScript(filenames);

if not(all(logical_index))
  id = errorID + "NotPlainTextLiveScript";

  if isscalar(filenames)
    msg = "File is not plain-text Live Script: " + filenames;
  else
    msg = "Files are not plain-text Live Script:" + newline + join(filenames(not(logical_index)), newline);
  end  % if

  % The message (msg) contains a file path for example "C:\local\work" on Windows.
  % The backslash "\" may be interpreted as an escaped character such as '\l' by MException
  % if it is in the second argument, causing an error. Use "%s" to avoid it.
  throw(MException(id, "%s", msg))

end  % if
end  % function
