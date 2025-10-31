function true_or_false = isPlainTextLiveScript(filenames)
% Check that the specified files are plain-text Live Scripts.
%
% This function uses the same vector shape (row or column) for the output as the input.
% For example, if the input is a row vector, the output is also a row vector.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  filenames string {mustBeVector}
end  % arguments

arguments (Output)
  true_or_false logical {mustBeVector}
end  % arguments

errorID = "isPlainTextLiveScript:";

num_files = numel(filenames);

% Create a row vector for now.
% Later, make it a column vector if the input is a column vector.
true_or_false = false(1, num_files);

for idx = 1 : num_files

  if not(isfile(filenames(idx)))
    id = errorID + "NotFile";
    msg = "Specified filename is invalid: " + filenames(idx);

    throw(MException(id, msg))

  end  % if

  if matlab.desktop.editor.EditorUtils.isLiveCodeFile(filenames(idx)) && endsWith(filenames(idx), ".m")
    true_or_false(idx) = true;
  else
    true_or_false(idx) = false;
  end  % if
end  % for

% Use the same vector shape as the input.
if iscolumn(filenames)
  true_or_false = true_or_false';
end  % if
end  % function
