function App = bevutil1_FileSearchApp(NameValuePair)
% App for searching a folder tree for the specified file name.
%
% Open the app without any options and the app uses the default values.
%
%   bevutil1_FileSearchApp
%
% Use search options to customize the app's initial states.
% Example:
%
%   bevutil1_FileSearchApp(SearchFileName="buildfile*.m", TopFolder=pwd)

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  NameValuePair.SearchFileName (1,1) string = "buildfile*.m"
  NameValuePair.TopFolder (1,1) string {mustBeFolder} = pwd
end  % arguments

arguments (Output)
  App bevutil1.SearchUtil.FileSearchAppMain {mustBeScalarOrEmpty}
end  % arguments

app_main = bevutil1.SearchUtil.FileSearchAppMain( ...
  SearchFileName = NameValuePair.SearchFileName, ...
  TopFolder = NameValuePair.TopFolder );

app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
