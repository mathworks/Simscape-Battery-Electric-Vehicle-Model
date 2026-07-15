function tf = isModelFile(filenames)
% Check that specified files are model files or not.
%
% This function just checks the file extension.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  filenames (:,1) string
end  % arguments

arguments (Output)
  tf (:,1) logical
end  % arguments

errorID = "isModelFile:";

num_files = numel(filenames);
tf = false(num_files, 1);
for idx = 1 : num_files

  if isfolder(filenames(idx))
    tf(idx) = false;

    continue

  end  % for

  if not(isfile(filenames(idx)))
    id = errorID + "NotFile";
    msg = "Specified filename is invalid: " + filenames(idx);

    throw(MException(id, msg))

  end  % if

  if endsWith(filenames(idx), ".mdl") || endsWith(filenames(idx), ".slx")
    tf(idx) = true;
  else
    tf(idx) = false;
  end  % if
end  % for
end  % function
