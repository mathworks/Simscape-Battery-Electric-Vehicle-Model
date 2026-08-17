function App = bevutil1_RotationalFrictionTorqueApp(NameValuePair)
% App for visualizing the torque curve of the rotational friction torque model.
%
% This is a wrapper function of the main app implementation.
% To change the default options and settings of the app,
% make a copy of this file and modify it.

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  NameValuePair.AppParameterFileName (1,1) string = ""
  NameValuePair.AppParameterStructName (1,1) string = ""

  NameValuePair.BlockPath (1,1) string = ""
  NameValuePair.ModelName (1,1) string = ""
end  % arguments

app_main = bevutil1.app.RotationalFrictionTorque.RotationalFrictionTorqueAppMain( ...
  AppParameterFileName = NameValuePair.AppParameterFileName, ...
  AppParameterStructName = NameValuePair.AppParameterStructName, ...
  BlockPath = NameValuePair.BlockPath, ...
  ModelName = NameValuePair.ModelName );

% Override the "Source" hyperlink in the app to open this file.
app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
