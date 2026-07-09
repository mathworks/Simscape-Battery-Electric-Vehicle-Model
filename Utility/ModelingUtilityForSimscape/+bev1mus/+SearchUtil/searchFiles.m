function Files = searchFiles(Filename, NameValuePair)
% Search for the specified file under the specified folder and its subfolders.
%
% The Filename argument can be specific such as "test-result.xml" or
% a pattern such as "*.ssc".
%
% By default, current folder is the top folder of search.
% Use the TopFolder option to specify a custom top folder.
%
% Example: Search for *.ssc files in the Simscape foundation library.
% 
%   bev1mus.SearchUtil.searchFile("*.ssc", TopFolder=fullfile(matlabroot, "toolbox", "physmod", "simscape", "library", "m", "+foundation"))

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  Filename (1,1) string
  NameValuePair.TopFolder (1,1) string {mustBeFolder} = pwd
end  % arguments

arguments (Output)
  Files (:,1) string
end  % arguments

errorID = "searchFiles:";

if Filename == ""
  id = errorID + "EmptyFilenameNotAllowed";
  msg = bev1mus.CodeUtil.i18n("Empty filename is not allowed.");

  throw(MException(id, msg))

end  % if

glob = matlab.buildtool.io.FileCollection.fromPaths(fullfile(NameValuePair.TopFolder, "**", Filename));

Files = string(glob.paths');

logical_index = isfile(Files);

Files = Files(logical_index);

end  % function
