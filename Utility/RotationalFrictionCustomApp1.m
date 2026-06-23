function App = RotationalFrictionCustomApp1(NameValuePair)
% Example customization of the rotational friction app
%
% This is a customized version of the RotationalFrictionApp.
% This app runs a parameter definition script to load parameters in the base workspace.
% Then the app is configured to use the workspace variables for the friction model parameters.
% Parameters are defined as simscape.Value object.
% The app directly uses simscape.Value objects in the edit fields for parameters.

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  NameValuePair.ParameterScriptFullPath (1,1) string {mustBeFile} = FileUtil1.getFileFullPath("SampleParams_RotationalFriction.m")

  % Specify units used in the parameter file.
  % The selection list must match that used in AppMain.
  NameValuePair.PlotTorqueUnit (1,1) string {mustBeMember(NameValuePair.PlotTorqueUnit, ["N*m", "lbf*ft"])} = "lbf*ft"
  NameValuePair.PlotVelocityUnit (1,1) string {mustBeMember(NameValuePair.PlotVelocityUnit, ["rpm", "rad/s", "rev/s"])} = "rev/s"
end  % arguments

% Run the set-up script to load parameters in the base workspace.
[~, script_name, ~] = fileparts(NameValuePair.ParameterScriptFullPath);
evalin("base", script_name)

% Launch the app.
app_main = RotationalFriction1.RotationalFrictionAppMain( ...
  PlotTorqueUnit = NameValuePair.PlotTorqueUnit, ...
  PlotVelocityUnit = NameValuePair.PlotVelocityUnit );

% Set the Source hyperlink in the app to this file.
% By default, it opens the app main source file.
app_main.Window.HeaderUI.AppSourceName = mfilename;

% Enable the Update button, which disables auto-update.
% By default, the button is disabled and auto-update is enabled.
app_main.PlotButtonUI.ButtonEnable = true;

% -----------------------------------------------------------------------------
% Set up the model parameters in the app using the base workspace variables.
% The base workspace variables must be loaded by the script.

app_main.BreakawayTorqueUI.ValueText = "friction.BreakawayTorque";
updateInfoAndUnitUIs(app_main.BreakawayTorqueUI)

app_main.BreakawayVelocityUI.ValueText = "friction.BreakawayVelocity";
updateInfoAndUnitUIs(app_main.BreakawayVelocityUI)

app_main.CoulombTorqueUI.ValueText = "friction.CoulombTorque";
updateInfoAndUnitUIs(app_main.CoulombTorqueUI)

app_main.ViscousCoefficientUI.ValueText = "friction.ViscousCoefficient";
updateInfoAndUnitUIs(app_main.ViscousCoefficientUI)

% -----------------------------------------------------------------------------

if nargout > 0
  App = app_main;
end  % if
end  % function
