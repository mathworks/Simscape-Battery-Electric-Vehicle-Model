function tf = isPlainTextLiveScript(filenames)
%% Check that specified files are plain text Live Scripts

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  filenames (:,1) string
end  % arguments

arguments (Output)
  tf (:,1) logical
end  % arguments

errorID = "isPlainTextLiveScript:";

num_files = numel(filenames);
tf = false(num_files, 1);
for idx = 1 : num_files

  if not(isfile(filenames(idx)))
    id = errorID + "NotFile";
    msg = "Specified filename is invalid: " + filenames(idx);

    throw(MException(id, msg))

  end  % if

  if matlab.desktop.editor.EditorUtils.isLiveCodeFile(filenames(idx)) && endsWith(filenames(idx), ".m")
    tf(idx) = true;
  else
    tf(idx) = false;
  end  % if
end  % for
end  % function
