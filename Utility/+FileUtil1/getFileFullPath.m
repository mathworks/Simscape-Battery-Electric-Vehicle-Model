function FileFullPath = getFileFullPath(FileName, NameValuePair)
% Return full path to the specified file name in MATLAB path.
%
% This function searches the specified name in MATLAB path and returns the full path to it.
% To search a file in a folder tree rather than in MATLAB path, 
% use the searchFiles of the Search Utility.
%
% This function is a wrapper of the which command with the "-all" option.
% The which returns a character vector or a cell array of character vectors.
% This function returns a string text or a column vector of string texts.
%
% By default, this function errors out if the specified file was not found.
% Use this behavior if the target file must exist.
% Use ReturnIfNotFound=true to get an empty string if the target file was not found.
%
% If two or more matches were found, an error is issued by default.
% To get multiple matches, use ReturnMultipleMatches=true.
% Use WarningOnMultipleMatch=true and
% this function issues a warning and returns the matches.
%
% This function can take a name within a namespace. For example,
%   getFileFullPath("myNamespace.myFunction")
% returns the full path to the "myFunction.m" file in the "myNamespace" folder.
%
% isfile() takes either a full path or a relative path where
% relative path must start from the current working folder.
% This function searches the specified file on any MATLAB paths.

% Copyright 2023-2026 The MathWorks, Inc.

arguments (Input)
  FileName string {mustBeTextScalar}
  NameValuePair.ReturnMultipleMatches (1,1) logical = false
  NameValuePair.WarningOnMultipleMatch (1,1) logical = false
  NameValuePair.ReturnIfNotFound (1,1) logical = false
end  % arguments

arguments (Output)
  FileFullPath (:,1) string
end  % arguments

errorID = "getFileFullPath:";

if FileName == ""
  id = errorID + "InvalidFileName";
  msg = CodeUtil1.i18n("Empty file name is not allowed.");

  throw(MException(id, msg))

end  % if

% Discover full paths.
found_paths = string( which(FileName, "-all"));

if numel(found_paths) == 0 || (isscalar(found_paths) && found_paths == "")
  % The specified file was not found.
  if NameValuePair.ReturnIfNotFound
    FileFullPath = "";

    return

  end  % if

  id = errorID + "FileNotFound";
  msg = CodeUtil1.i18n("File was not found: ") + FileName;

  throw(MException(id, msg))

end  % if

FileFullPath = found_paths;

if ischar(FileFullPath) || (isstring(FileFullPath) && isscalar(FileFullPath))
  % Only one file was found.

  return

else
  % Multiple matches.
  id = errorID + "TwoOrMoreMatches";
  msg = CodeUtil1.i18n("There are two or more matches: ") + numel(FileFullPath);
  if NameValuePair.WarningOnMultipleMatch
    warning(id, msg)

    return

  end  % if
  if NameValuePair.ReturnMultipleMatches

    return

  end  % if

  throw(MException(id, msg))

end  % if
end  % function
