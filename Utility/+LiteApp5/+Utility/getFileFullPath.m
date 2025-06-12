function FileFullPath = getFileFullPath(FileName)
%% Returns full path to the given file name.
% This function searches the specified file name in MATLAB paths
% and returns the full path to it.
% If two or more matches were found, the first one is returned.
%
% If a MATLAB project is loaded, project paths are added to MATLAB paths.
% Thus the search covers project paths too.
%
% isfile() takes either a full path or a relative path where
% relative path must start from the current working folder.
% This function searches the specified file on any MATLAB paths.

% Copyright 2023-2025 The MathWorks, Inc.

arguments (Input)
  FileName {mustBeTextScalar} = ""
end  % arguments

arguments (Output)
  FileFullPath (1,1) string
end  % arguments

errorID = "getFileFullPath:";

if FileName == ""
  id = errorID + "InvalidFileName";
  msg = LiteApp5.Utility.i18n("Empty file name is not allowed.");

  throw(MException(id, msg))

end  % if

% Discover full paths.
found_paths = string(which(FileName));

if numel(found_paths) == 0 || (isscalar(found_paths) && found_paths == "")
  id = errorID + "FileNotFound";
  msg = LiteApp5.Utility.i18n("File was not found: ") + FileName;

  throw(MException(id, msg))

end  % if

if ischar(found_paths) || (isstring(found_paths) && isscalar(found_paths))
  % Only one file was found.
  FileFullPath = string(found_paths);

  return

else
  % There are two or more matches.
  FileFullPath = string(found_paths{1});

  return

end  % if
end  % function
