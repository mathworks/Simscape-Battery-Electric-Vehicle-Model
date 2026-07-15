function App = bevutil1_Vehicle1DForceApp(NameValuePair)
% App for visualizing the longitudinal force of a road-vehicle.
%
% This is a wrapper function of the main app implementation.
% To change the default options and settings of the app,
% make a copy of this file and modify the copy.

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  NameValuePair.AppParameterFileName (1,1) string = ""
  NameValuePair.AppParameterStructName (1,1) string = ""

  NameValuePair.BlockPath (1,1) string = ""
  NameValuePair.ModelName (1,1) string = ""
end  % arguments

app_main = bevutil1.app.Vehicle1DForce.Vehicle1DForceAppMain( ...
  AppParameterFileName = NameValuePair.AppParameterFileName, ...
  AppParameterStructName = NameValuePair.AppParameterStructName, ...
  BlockPath = NameValuePair.BlockPath, ...
  ModelName = NameValuePair.ModelName );

% Set up the "Source" hyperlink in the app to open this file.
app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
