function App = FileSearchApp(NameValuePair)
% App for searching a folder tree for the specified file name.
%
% Open the app without any options and the app uses the default values.
%
%   FileSearchApp
%
% Use search options to customize the app's initial states.
% See the NameValuePair options in the code below for available options.
% Example:
%
%   FileSearchApp(SearchFileName="buildfile*.m", TopFolder=pwd)

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  NameValuePair.SearchFileName (1,1) string = "buildfile*.m"
  NameValuePair.TopFolder (1,1) string {mustBeFolder} = pwd
end  % arguments

arguments (Output)
  App SearchUtil1.FileSearchAppMain {mustBeScalarOrEmpty}
end  % arguments

app_main = SearchUtil1.FileSearchAppMain( ...
  SearchFileName = NameValuePair.SearchFileName, ...
  TopFolder = NameValuePair.TopFolder );

app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
