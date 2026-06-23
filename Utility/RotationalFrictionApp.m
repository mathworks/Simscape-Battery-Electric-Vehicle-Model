function App = RotationalFrictionApp(NameValuePair)
% App for the rotational friction torque model
%
% For the information about the app, see the description file "RotationalFriction_Description".
%
% This is a wrapper function of the main app implementation.
% To change the default options and settings of the app,
% make a copy of this file and modify it.

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  NameValuePair.BlockPath (1,1) string = ""
  NameValuePair.ModelName (1,1) string = ""

  % The selection list must match that used in AppMain.
  NameValuePair.PlotTorqueUnit (1,1) string {mustBeMember(NameValuePair.PlotTorqueUnit, ["N*m", "lbf*ft"])} = "N*m"
  NameValuePair.PlotVelocityUnit (1,1) string {mustBeMember(NameValuePair.PlotVelocityUnit, ["rpm", "rad/s", "rev/s"])} = "rad/s"
end  % arguments

app_main = RotationalFriction1.RotationalFrictionAppMain( ...
  BlockPath = NameValuePair.BlockPath, ...
  ModelName = NameValuePair.ModelName, ...
  PlotTorqueUnit = NameValuePair.PlotTorqueUnit, ...
  PlotVelocityUnit = NameValuePair.PlotVelocityUnit );

% Override the "Source" hyperlink in the app to the app source code so that the link opens this file.
app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
