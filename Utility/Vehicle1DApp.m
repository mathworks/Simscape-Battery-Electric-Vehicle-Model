function App = Vehicle1DApp(NameValuePair)
% App for visualizing the longitudinal force of a road-vehicle.
%
% This is a wrapper function of the main app implementation.
% To change the default options and settings of the app,
% make a copy of this file and modify it.

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  NameValuePair.BlockPath (1,1) string = ""
  NameValuePair.ModelName (1,1) string = ""
end  % arguments

% Use the app_main object to programmatically modify the app at start up.
app_main = Vehicle1D1.Vehicle1DAppMain( ...
  BlockPath = NameValuePair.BlockPath, ...
  ModelName = NameValuePair.ModelName );

% Set up the "Source" hyperlink in the app to open this file.
app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
