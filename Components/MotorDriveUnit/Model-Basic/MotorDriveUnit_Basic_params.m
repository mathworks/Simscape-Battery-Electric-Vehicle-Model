%% Parameters for Motor Drive Unit component
% If you edit this file, make sure to run this to update variables
% in the base workspace before running simulation.

% Copyright 2021-2026 The MathWorks, Inc.

%% Connection Bus definitions

defineBus_HighVoltage
defineBus_Rotational

%% Motor drive unit parameters

MotorDriveUnit.MaxTorque = simscape.Value(420, "N*m");
MotorDriveUnit.MaxPower = simscape.Value(220, "kW");
MotorDriveUnit.ResponseTime = simscape.Value(20, "ms");

MotorDriveUnit.ElectricalEfficiencyPercent = 95;
MotorDriveUnit.MeasuredAngularSpeed = simscape.Value(2000, "rpm");
MotorDriveUnit.MeasuredTorque = simscape.Value(50, "N*m");
MotorDriveUnit.MeasuredIronLosses = simscape.Value(55, "W");
MotorDriveUnit.FixedLosses = simscape.Value(40, "W");

MotorDriveUnit.RotorInertia = simscape.Value(5*0.01^2, "kg*m^2");
MotorDriveUnit.RotorDamping = simscape.Value(1e-5, "N*m/(rad/s)");

% Used in the Status subsystem, but has no effect on the simulation.
MotorDriveUnit.AmbientTemperature = simscape.Value(273.15 + 20, "K");

%% Initial conditions

initial.MotorDriveUnit_RotorAngularSpeed = simscape.Value(0, "rpm");
