function TrueOrFalse = isPlainTextLiveScript(FileNames)
% Check that the specified files are plain-text Live Scripts.
%
% This function uses the same vector shape (row or column) for the output as the input.
% For example, if the input is a row vector, the output is also a row vector.
%
% In R2024b or older, this function returns false for all file names.

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  FileNames string {mustBeVector}
end  % arguments

arguments (Output)
  TrueOrFalse logical {mustBeVector}
end  % arguments

errorID = "isPlainTextLiveScript:";

if FileNames == ""
  id = errorID + "FileNotSpecified";
  msg = CodeUtil1.i18n("File was not specified.");

  throw(MException(id, msg))

end  % if

num_files = numel(FileNames);

% Create a row vector for now.
% Later, make it a column vector if the input is a column vector.
TrueOrFalse = false(1, num_files);

if not(isMATLABReleaseOlderThan("R2025a"))
  % R2025a or newer
  for k = 1 : num_files
    if not(isfile(FileNames(k)))
      id = errorID + "NotFile";
      msg = "Specified filename is invalid: " + FileNames(k);

      throw(MException(id, msg))

    end  % if
    if matlab.desktop.editor.EditorUtils.isLiveCodeFile(FileNames(k)) && endsWith(FileNames(k), ".m")
      TrueOrFalse(k) = true;
    end  % if
  end  % for
end  % if

% Use the same vector shape as the input.
if iscolumn(FileNames)
  TrueOrFalse = TrueOrFalse';
end  % if
end  % function
