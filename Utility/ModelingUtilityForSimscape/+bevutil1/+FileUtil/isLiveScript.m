function TrueOrFalse = isLiveScript(FileNames)
% Check that the specified files are Live Scripts.
%
% This function uses the same vector shape (row or column) for the output as the input.
% For example, if the input is a row vector, the output is also a row vector.
%
% In R2024b or older, this function returns false for the "*.m" plain-text Live Script.

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  FileNames (:,1) string
end  % arguments

arguments (Output)
  TrueOrFalse (:,1) logical
end  % arguments

errorID = "isLiveScript:";

num_files = numel(FileNames);

% Create a row vector for now.
% Later, make it a column vector if the input is a column vector.
TrueOrFalse = false(num_files, 1);

for k = 1 : num_files

  if isfolder(FileNames(k))
    TrueOrFalse(k) = false;

    continue

  end  % if

  if not(isfile(FileNames(k)))
    id = errorID + "NotFile";
    msg = "Specified filename is invalid: " + FileNames(k);

    throw(MException(id, "%s", msg))

  end  % if

  if endsWith(FileNames(k), ".mlx")
      TrueOrFalse(k) = true;
  elseif endsWith(FileNames(k), ".m")
    if isMATLABReleaseOlderThan("R2025a")
      % In R2024b or older, the "*.m" plain-text Live Script is not supported.
      TrueOrFalse(k) = false;
    else
      % R2025a or newer
      if matlab.desktop.editor.EditorUtils.isLiveCodeFile(FileNames(k))
        TrueOrFalse(k) = true;
      else
        TrueOrFalse(k) = false;
      end  % if
    end  % if
  else
    TrueOrFalse(k) = false;
  end  % if
end  % for

% Use the same vector shape as the input.
if iscolumn(FileNames)
  TrueOrFalse = TrueOrFalse';
end  % if
end  % function
