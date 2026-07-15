% Parameters for the abstract motor efficiency app and the Motor & Drive blocks.

% Copyright 2026 The MathWorks, Inc.

% Abstract Motor Efficiency app's parameters such as "Continuous max angular speed",
% "Continuous max torque", etc. can refer to base workspace variables.
%
% This script creates a variable of AbstractMotorEfficiencyAppParameters, which
% provides predefined fields for the app parameters and tab-completion for edit.
% The app can also read these fields with the "Get" button all at once.
MotorParams = bevutil1.app.AbstractMotorEfficiency.AbstractMotorEfficiencyAppParameters;

MotorParams.MaxAngularSpeedMode = "auto";
% MotorParams.MaxAngularSpeed = simscape.Value(12000, "rpm");

% -----------------------------------------------------------------------------
% Parameters for...
% - "Motor & Drive" block (Simscape Driveline)
% - "Motor & Drive (System level)" block (Simscape Electrical)

% Continuous operation maximum torque
MotorParams.MaxTorque = simscape.Value(260, "N*m");

% Continuous operation maximum power
MotorParams.MaxPower = simscape.Value(55, "kW");

% Motor and driver overall efficiency (percent)
MotorParams.OverallEfficiencyPercent = 95;

% Speed at which efficiency is measured
MotorParams.MeasuredAngularSpeed = simscape.Value(2000, "rpm");

% Torque at which efficiency is measured
MotorParams.MeasuredTorque = simscape.Value(50, "N*m");

% -----------------------------------------------------------------------------
% Parameters for the "Motor & Drive (System level)" block (Simscape Electrical).
% These parameters are implicitly 0 in the "Motor & Drive" block (Simscape Driveline).

% Iron losses at measurement speed
MotorParams.MeasuredIronLosses = simscape.Value(55, "W");

% Fixed losses independent of torque and speed
MotorParams.FixedLosses = simscape.Value(40, "W");

% Rotor damping coefficient
MotorParams.RotorDampingCoefficient = simscape.Value(0.05, "N*m/(rad/s)");

% -----------------------------------------------------------------------------
% Plot customization

MotorParams.PlotAutoRange = "on";

MotorParams.PlotAngularSpeedUpperBound = simscape.Value(12000, "rpm");
MotorParams.PlotTorqueUpperBound = simscape.Value(300, "N*m");

MotorParams.PlotContourLevelsPercent = [1, 60, 80, 90, 96, 99];
