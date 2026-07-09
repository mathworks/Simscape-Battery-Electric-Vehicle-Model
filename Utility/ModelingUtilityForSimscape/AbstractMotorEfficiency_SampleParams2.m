% Parameters for the Motor & Drive blocks and the abstract motor efficiency app.

% Copyright 2026 The MathWorks, Inc.

% Abstract Motor Efficiency app's parameters such as "Continuous max angular speed",
% "Continuous max torque", etc. can use base workspace variables.
%
% This script creates a variable of AbstractMotorEfficiencyAppParameters, which
% provides predefined fields for the app parameters and tab-completion for edit.
% The app can also read these fields with the "Get" button all at once.
%
% Use a nested struct as an example.
Params.Motor = bev1mus.app.AbstractMotorEfficiency.AbstractMotorEfficiencyAppParameters;

% =============================================================================
% Maximum motor speed is not a parameter of the Motor & Drive blocks, but
% it is typically defined by higher-level system requirements.
% For example, in the road vehicle applications, the vehicle top speed and
% a few other vehicle specs determine the maximum motor speed.
% Below is an example.

Params.Motor.MaxAngularSpeedMode = "specify";

Params.Vehicle.TopSpeed = simscape.Value(180, "km/hr");
Params.Vehicle.TireRollingRadius = simscape.Value(0.3, "m");
Params.Vehicle.ReductionGearRatio = 1/10;

% To compute the revolutions per unit-time;
%   Use speed/(2*pi*R) if speed and R are of type double.
%   Use speed/R if speed and R are of type simscape.Value.
% Simscape does not require 2*pi in the formula if speed and R are simscape.Values.
% For more information, see the documentation.
% Units for Angular Velocity and Frequency
% https://www.mathworks.com/help/simscape/ug/units-for-angular-velocity-and-frequency.html
Params.Vehicle.MaxTireSpeed = convert(Params.Vehicle.TopSpeed / Params.Vehicle.TireRollingRadius, "rpm");

tmp_angular_speed = convert(Params.Vehicle.MaxTireSpeed / Params.Vehicle.ReductionGearRatio, "rpm");
% Use a nice value by rounding the value.
Params.Motor.MaxAngularSpeed = simscape.Value(round(value(tmp_angular_speed, "rpm"), -3), "rpm");
clearvars tmp_angular_speed

% -----------------------------------------------------------------------------
% Parameters for the following blocks
% - "Motor & Drive" block (Simscape Driveline)
% - "Motor & Drive (System level)" block (Simscape Electrical)

% Continuous operation maximum torque
Params.Motor.MaxTorque = simscape.Value(160, "N*m");

% Continuous operation maximum power
Params.Motor.MaxPower = simscape.Value(55, "kW");

% Motor and driver overall efficiency (percent)
Params.Motor.OverallEfficiencyPercent = 95;

% Speed at which efficiency is measured
Params.Motor.MeasuredAngularSpeed = simscape.Value(2000, "rpm");

% Torque at which efficiency is measured
Params.Motor.MeasuredTorque = simscape.Value(50, "N*m");

% -----------------------------------------------------------------------------
% Parameters for the "Motor & Drive (System level)" block (Simscape Electrical).
% These parameters are implicitly 0 in the "Motor & Drive" block (Simscape Driveline).

% Iron losses at measurement speed
Params.Motor.MeasuredIronLosses = simscape.Value(55, "W");

% Fixed losses independent of torque and speed
Params.Motor.FixedLosses = simscape.Value(40, "W");

% Rotor damping
Params.Motor.RotorDampingCoefficient = simscape.Value(0.05, "N*m/(rad/s)");

% -----------------------------------------------------------------------------
% Plot customization

Params.Motor.PlotAutoRange = "off";

% Use a nice value for the plot upper bound.
% For example, use 12000 rpm rather than 12345 rpm.
%
% Set upper bounds to 10 % more (and rounded) of the motor max spec values.
Params.Motor.PlotAngularSpeedUpperBound = simscape.Value(round(1.1*value(Params.Motor.MaxAngularSpeed, "rpm"), -3), "rpm");
Params.Motor.PlotTorqueUpperBound = simscape.Value(round(1.1*value(Params.Motor.MaxTorque, "N*m"), -2), "N*m");

Params.Motor.PlotContourLevelsPercent = [1, 60, 80, 90, 96, 99];
