function App = bev1mus_FolderSearchApp(NameValuePair)
% App for searching a folder tree for the specified folder name.
%
% Open the app without any options and the app uses the default values.
%
%   bev1mus_FolderSearchApp
%
% Use search options to customize the app's initial states.
% Example:
%
%   bev1mus_FolderSearchApp(SearchFolderName="test-result", TopFolder=pwd)

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  NameValuePair.SearchFolderName (1,1) string = "test-result"
  NameValuePair.TopFolder (1,1) string {mustBeFolder} = pwd
end  % arguments

arguments (Output)
  App bev1mus.SearchUtil.FolderSearchAppMain {mustBeScalarOrEmpty}
end  % arguments

app_main = bev1mus.SearchUtil.FolderSearchAppMain( ...
  SearchFolderName = NameValuePair.SearchFolderName, ...
  TopFolder = NameValuePair.TopFolder );

app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
