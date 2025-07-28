function FileFullPath = getFileFullPath(FileName, NameValuePair)
%% Return full path to the specified file name.
% This function searches the specified file name in MATLAB paths, including
% MATLAB Project paths if a project is loaded, and returns the full path to it.
%
% If two or more matches are found, an error is issued by default.
% To allow multiple matches, set true to WarningOnMultipleMatch and
% this function returns the first match.
%
% isfile() takes either a full path or a relative path where
% relative path must start from the current working folder.
% This function searches the specified file on any MATLAB paths.

% Copyright 2023-2025 The MathWorks, Inc.

arguments (Input)

  FileName {mustBeTextScalar} = ""

  NameValuePair.WarningOnMultipleMatch (1,1) logical = false

end  % arguments

arguments (Output)
  FileFullPath (1,1) string
end  % arguments

errorID = "getFileFullPath:";

if FileName == ""
  id = errorID + "InvalidFileName";
  msg = "Empty file name is not allowed.";

  throw(MException(id, msg))

end  % if

% Discover full paths.
found_paths = string(which(FileName, "-all"));

if numel(found_paths) == 0 || (isscalar(found_paths) && found_paths == "")
  id = errorID + "FileNotFound";
  msg = "File was not found: " + FileName;

  throw(MException(id, msg))

end  % if

if ischar(found_paths) || (isstring(found_paths) && isscalar(found_paths))
  % Only one file was found.
  FileFullPath = string(found_paths);

  return

else
  % There were two or more matches.

  id = errorID + "TwoOrMoreMatches";
  msg = "There are two or more matches: " + numel(found_paths);

  if NameValuePair.WarningOnMultipleMatch
    warning(id, msg)
    % Return the first match.
    FileFullPath = string(found_paths{1});

    return

  end  % if

  throw(MException(id, msg))

end  % if
end  % function
