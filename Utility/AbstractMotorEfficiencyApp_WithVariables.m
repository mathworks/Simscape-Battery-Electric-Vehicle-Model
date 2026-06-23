function App = AbstractMotorEfficiencyApp_WithVariables
% App for visualizing the power conversion efficiency of the abstract motor model.

% Copyright 2026 The MathWorks, Inc.

arguments (Output)
  App struct {mustBeScalarOrEmpty}
end  % arguments

% Load parameters in the base workspace.
evalin("base", "SampleParams_AbstractMotor")

motor_app = AbstractMotor1.AbstractMotorEfficiencyAppMain( ...
  BlockPath="", ModelName="", PlotTorqueUnit="N*m", PlotAngularSpeedUnit="rpm" );

% Set up the "Source" hyperlink in the app to open this file.
motor_app.Window.HeaderUI.AppSourceName = mfilename;

% -----------------------------------------------------------------------------
% model parameters

motor_app.MaxAngularSpeedUI.ValueText = "MotorDrive.MaxSpeed";
motor_app.MaxTorqueUI.ValueText = "MotorDrive.MaxTorque";
motor_app.MaxPowerUI.ValueText = "MotorDrive.MaxPower";

motor_app.MeasuredEfficiencyPercentUI.ValueText = "MotorDrive.MeasuredEfficiencyPercent";
motor_app.MeasuredAngularSpeedUI.ValueText = "MotorDrive.MeasuredAngularSpeed";
motor_app.MeasuredTorqueUI.ValueText = "MotorDrive.MeasuredTorque";

motor_app.MeasuredIronLossUI.ValueText = "MotorDrive.MeasuredIronLoss";
motor_app.FixedLossUI.ValueText = "MotorDrive.FixedLoss";
motor_app.RotorDampingUI.ValueText = "MotorDrive.RotorDamping";

% -----------------------------------------------------------------------------
% visualization parameters

motor_app.ContoursUI.ValueText = "[1, 80, 92, 97, 99]";

speed_sscval = motor_app.MaxAngularSpeedUI.SimscapeValue;
motor_app.PlotAngularSpeedUpperBoundUI.ValueText = round(value(speed_sscval), -3, TieBreaker="plusinf");
motor_app.PlotAngularSpeedUpperBoundUI.UnitText = unit(speed_sscval);

motor_app.PlotTorqueUpperBoundUI.SimscapeValue = motor_app.MaxTorqueUI.SimscapeValue;

% Update the plot using the above visualization settings.
motor_app.UpdatePlot();
% -----------------------------------------------------------------------------
if nargout > 0
  App = motor_app;
end  % if
end  % function
