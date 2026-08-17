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

% Mechanical
MotorDriveUnit.RotorInertia = simscape.Value(5*0.01^2, "kg*m^2");
MotorDriveUnit.RotorDamping = simscape.Value(1e-5, "N*m/(rad/s)");

% Thermal port
MotorDriveUnit.ThermalMass = simscape.Value(90, "kJ/K");

% Thermal system > Radiative Heat Transfer
MotorDriveUnit.RadiationArea = simscape.Value(1, "m^2");
MotorDriveUnit.RadiationCoefficient = simscape.Value(5e-10, "W/K^4/m^2");

% Thermal system > Thermal Mass
MotorDriveUnit.AmbientMass = simscape.Value(10000, "t");
MotorDriveUnit.AmbientSpecificHeat = simscape.Value(1000, "J/K/kg");

%% Initial conditions

initial.MotorDriveUnit_RotorAngularSpeed = simscape.Value(0, "rpm");

initial.AmbientTemperature = simscape.Value(273.15 + 20, "K");
