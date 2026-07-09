function Folders = searchFolders(FolderName, NameValuePair)
% Search for the specified folder under the specified folder and its subfolders.
%
% The FolderName argument can be specific such as ".buildtool" or
% a pattern such as "test-result*".
%
% By default, current folder is the top folder of search.
% Use the TopFolder option to specify a custom top folder.
%
% Example: Search for test-result* folders in the Simscape foundation library.
% 
%   bev1mus.SearchUtil.searchFolder("test-result*", TopFolder=pwd)

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  FolderName (1,1) string
  NameValuePair.TopFolder (1,1) string {mustBeFolder} = pwd
end  % arguments

arguments (Output)
  Folders (:,1) string
end  % arguments

errorID = "searchFolders:";

if FolderName == ""
  id = errorID + "EmptyFolderNameNotAllowed";
  msg = bev1mus.CodeUtil.i18n("Empty folder name is not allowed.");

  throw(MException(id, msg))

end  % if

glob = matlab.buildtool.io.FileCollection.fromPaths(fullfile(NameValuePair.TopFolder, "**", FolderName));

Folders = string(glob.paths');

logical_index = isfolder(Folders);

Folders = Folders(logical_index);

end  % function
