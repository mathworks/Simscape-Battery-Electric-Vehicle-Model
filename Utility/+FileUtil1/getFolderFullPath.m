function FolderFullPath = getFolderFullPath(FolderName, NameValuePair)
% Return full path to the specified folder name.
%
% This function searches the specified folder name in MATLAB paths
% and returns the full path to it.
%
% If two or more matches were found, the first one is returned.
% Use WarningOnMultipleMatch=true to get a warning for multiple match.
% By default, this function simply returns the first match.
%
% isfolder() takes either a full path or a relative path where
% relative path must start from the current working folder.
% This function searches the specified folder on any MATLAB paths.

% Copyright 2023-2025 The MathWorks, Inc.

arguments (Input)
  FolderName string {mustBeTextScalar}
  NameValuePair.WarningOnMultipleMatch (1,1) logical = false
end  % arguments

arguments (Output)
  FolderFullPath (1,1) string
end  % arguments

errorID = "getFolderFullPath:";

if FolderName == ""
  id = errorID + "InvalidFolderName";
  msg = CodeUtil1.i18n("Empty folder name is not allowed.");

  throw(MException(id, msg))

end  % if

% Discover full paths.
if startsWith(FolderName, "+")
  % Use what.
  % Omit the leading + and search using what, which does case insensitive search.
  target_name = extractAfter(FolderName, 1);
  result = what(target_name);
  found_paths = string({result(:).path}');

else
  % Use path.
  all_paths = string(path);
  all_paths = split(all_paths, ";");
  logical_index = endsWith(all_paths, FolderName);
  if all(logical_index == 0)
    % Folder was not found. Error check is done in the next if block.
    found_paths = "";
  else
    found_paths = all_paths(logical_index);
  end  % if

end  % if

if numel(found_paths) == 0 || (isscalar(found_paths) && found_paths == "")
  id = errorID + "FolderNotFound";
  msg = CodeUtil1.i18n("Folder was not found: ") + FolderName;

  throw(MException(id, msg))

end  % if

if ischar(found_paths) || (isstring(found_paths) && isscalar(found_paths))
  % Only one file was found.
  FolderFullPath = string(found_paths);

  return

else
  % There are two or more matches. Return the first match.
  FolderFullPath = string(found_paths{1});

  if NameValuePair.WarningOnMultipleMatch
    id = errorID + "TwoOrMoreMatches";
    msg = CodeUtil1.i18n("There are two or more matches: ") + numel(found_paths);

    warning(id, msg)

    return

  end  % if
end  % if
end  % function
