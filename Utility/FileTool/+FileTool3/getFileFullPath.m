function FileFullPath = getFileFullPath(FileName, NameValuePair)
%% Return full path to the specified file name.
% This function searches the specified file name in MATLAB paths, including
% MATLAB Project paths if a project is loaded, and returns the full path to it.
%
% This function is a wrapper of the which command with the "-all" option.
% The which returns a charactor vector or a cell array of charactor vectors.
% This function returns a string.
%
% If two or more matches are found, an error is issued by default.
% To allow multiple matches, set true to WarningOnMultipleMatch and
% this function returns the first match.
%
% By default, this function errors out if the spaecified file was not found.
% Use this behavior if the target file must exist.
% Set true to ReturnIfNotFound to get an empty string if the target file was not found.
%
% isfile() takes either a full path or a relative path where
% relative path must start from the current working folder.
% This function searches the specified file on any MATLAB paths.

% Copyright 2023-2025 The MathWorks, Inc.

arguments (Input)
  FileName {mustBeTextScalar} = ""
  NameValuePair.WarningOnMultipleMatch (1,1) logical = false
  NameValuePair.ReturnIfNotFound (1,1) logical = false
end  % arguments

arguments (Output)
  FileFullPath (1,1) string
end  % arguments

errorID = "getFileFullPath:";

if FileName == ""
  id = errorID + "InvalidFileName";
  msg = CodeTool1.i18n("Empty file name is not allowed.");

  throw(MException(id, msg))

end  % if

% Discover full paths.
found_paths = string(which(FileName, "-all"));

if numel(found_paths) == 0 || (isscalar(found_paths) && found_paths == "")
  if NameValuePair.ReturnIfNotFound
    FileFullPath = "";

    return

  end  % if

  id = errorID + "FileNotFound";
  msg = CodeTool1.i18n("File was not found: ") + FileName;

  throw(MException(id, msg))

end  % if

if ischar(found_paths) || (isstring(found_paths) && isscalar(found_paths))
  % Only one file was found.
  FileFullPath = string(found_paths);

  return

else
  % There were two or more matches.

  id = errorID + "TwoOrMoreMatches";
  msg = CodeTool1.i18n("There are two or more matches: ") + numel(found_paths);

  if NameValuePair.WarningOnMultipleMatch
    warning(id, msg)
    % Return the first match.
    FileFullPath = string(found_paths{1});

    return

  end  % if

  throw(MException(id, msg))

end  % if
end  % function
