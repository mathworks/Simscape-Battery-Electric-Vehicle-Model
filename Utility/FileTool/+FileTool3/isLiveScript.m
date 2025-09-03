function tf = isLiveScript(filenames)
%% Check that specified files are Live Scripts

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  filenames (:,1) string
end  % arguments

arguments (Output)
  tf (:,1) logical
end  % arguments

errorID = "isLiveScript:";

num_files = numel(filenames);
tf = false(num_files, 1);
for idx = 1 : num_files

  if isfolder(filenames(idx))
    tf(idx) = false;

    continue

  end  % if

  if not(isfile(filenames(idx)))
    id = errorID + "NotFile";
    msg = "Specified filename is invalid: " + filenames(idx);

    throw(MException(id, msg))

  end  % if

  if endsWith(filenames(idx), ".mlx") || matlab.desktop.editor.EditorUtils.isLiveCodeFile(filenames(idx))
    tf(idx) = true;
  else
    tf(idx) = false;
  end  % if
end  % for
end  % function
