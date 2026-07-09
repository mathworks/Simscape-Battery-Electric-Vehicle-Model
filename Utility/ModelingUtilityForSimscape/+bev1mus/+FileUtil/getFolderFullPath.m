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
  msg = bev1mus.CodeUtil.i18n("Empty folder name is not allowed.");

  throw(MException(id, msg))

end  % if

% Discover full paths.
if startsWith(FolderName, "+")
  % FolderName is a namespace, for example, "+ns1", or fullfile("+ns1", "+ns2").
  % Use what. The leading "+" must be removed to pass it to what.
  % what does case insensitive search.

%{
x = what("bev1mus").path;

% struct array
y = dir(x);

z = struct2table(y);

% The table z has the name and folder columns (and others).
% For example,
%   z.folder is {'C:\path\to\+ns1'}
%   z.name is {'+componentA'}
% Thus, fullfile(z.folder, z.name) is the full path to the 2nd-depth namespace folder.
%   fullfile(z(1, :).folder, z(1,:).name) is {'C:\path\to\+ns1\+componentA'}
%

%}


  target_name = extractAfter(FolderName, 1);
  if contains(target_name, ("/"|"\"))
    target_name = extractBefore(target_name, ("/"|"\"));
  end  % if
  result = what(target_name);

  found_fullpaths = string({result(:).path}');

  if not(endsWith(found_fullpaths, FolderName))
    % FolderName

    glob = matlab.buildtool.io.FileCollection.fromPaths(fullfile(found_fullpaths, "**"));
    all_paths = string(glob.paths');
    % if isempty(paths)
    %   id = errorID + "FolderNotFound";
    %   msg = bev1mus.CodeUtil.i18n("Folder was not found: ") + FolderName;
    % 
    %   throw(MException(id, msg))
    % 
    % end  % if

    logical_index = endsWith(all_paths, FolderName);
    % if all(not(logical_index))
    %   id = errorID + "FolderNotFound";
    %   msg = bev1mus.CodeUtil.i18n("Folder was not found: ") + FolderName;
    % 
    %   throw(MException(id, msg))
    % 
    % end  % if
    found_fullpaths = all_paths(logical_index);
  end  % if

else
  % Use path.
  all_paths = string(path);
  all_paths = split(all_paths, ";");
  logical_index = endsWith(all_paths, FolderName);
  if all(logical_index == 0)
    % Folder was not found. Error check is done in the next if block.
    found_fullpaths = "";
  else
    found_fullpaths = all_paths(logical_index);
  end  % if

end  % if

if numel(found_fullpaths) == 0 || (isscalar(found_fullpaths) && found_fullpaths == "")
  id = errorID + "FolderNotFound";
  msg = bev1mus.CodeUtil.i18n("Folder was not found: ") + FolderName;

  throw(MException(id, msg))

end  % if

if ischar(found_fullpaths) || (isstring(found_fullpaths) && isscalar(found_fullpaths))
  % Only one file was found.
  FolderFullPath = string(found_fullpaths);

  return

else
  % There are two or more matches. Return the first match.
  FolderFullPath = string(found_fullpaths{1});

  if NameValuePair.WarningOnMultipleMatch
    id = errorID + "TwoOrMoreMatches";
    msg = bev1mus.CodeUtil.i18n("There are two or more matches: ") + numel(found_fullpaths);

    warning(id, msg)

    return

  end  % if
end  % if
end  % function
