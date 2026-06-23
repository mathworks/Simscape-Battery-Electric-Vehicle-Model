% Parameters for the abstract motor model

% Copyright 2026 The MathWorks, Inc.

% -----------------------------------------------------------------------------
% Parameters for...
% - "Motor & Drive" block (Simscape Driveline)
% - "Motor & Drive (System level)" block (Simscape Electrical)

% Continuous operation maximum torque
MotorDrive.MaxTorque = simscape.Value(160, "N*m");

% Continuous operation maximum power
MotorDrive.MaxPower = simscape.Value(55, "kW");

% Motor and driver overall efficiency (percent)
MotorDrive.MeasuredEfficiencyPercent = 95;

% Speed at which efficiency is measured
MotorDrive.MeasuredAngularSpeed = simscape.Value(2000, "rpm");

% Torque at which efficiency is measured
MotorDrive.MeasuredTorque = simscape.Value(50, "N*m");

% -----------------------------------------------------------------------------
% Parameters for the "Motor & Drive (System level)" block (Simscape Electrical).
% These parameters are implicitly 0 in the "Motor & Drive" block (Simscape Driveline).

% Iron losses at measurement speed
MotorDrive.MeasuredIronLoss = simscape.Value(55, "W");

% Fixed losses independent of torque and speed
MotorDrive.FixedLoss = simscape.Value(40, "W");

% Rotor damping
MotorDrive.RotorDamping = simscape.Value(0.05, "N*m/(rad/s)");

% -----------------------------------------------------------------------------
% Maximum motor speed is not a parameter of the Motor & Drive blocks, but
% it is typically defined by higher-level system requirements.
% For example, in the road vehicle applications, the vehicle top speed and
% a few other vehicle specs determine the maximum motor speed.
% Below is an example.

MotorDrive.VehicleTopSpeed = simscape.Value(180, "km/hr");
MotorDrive.TireRollingRadius = simscape.Value(0.3, "m");
MotorDrive.ReductionGearRatio = 1/10;

% To compute the revolutions per unit-time;
%   Use speed/(2*pi*R) if speed and R are of type double.
%   Use speed/R if speed and R are of type simscape.Value.
% Simscape does not require 2*pi in the formula if speed and R are simscape.Values.
% For more information, see the documentation.
% Units for Angular Velocity and Frequency
% https://www.mathworks.com/help/simscape/ug/units-for-angular-velocity-and-frequency.html
MotorDrive.MaxTireSpeed = convert(MotorDrive.VehicleTopSpeed / MotorDrive.TireRollingRadius, "rpm");

% "Motor" is implied for MaxSpeed. (It is consistent with MaxTorque and MaxPower.)
MotorDrive.MaxSpeed = convert(MotorDrive.MaxTireSpeed / MotorDrive.ReductionGearRatio, "rpm");
