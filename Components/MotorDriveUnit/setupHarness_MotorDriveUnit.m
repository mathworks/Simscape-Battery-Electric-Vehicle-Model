%% Setup script for Motor Drive Unit harness model
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

% Used in the Status subsystem of the Basic model to output a constant temperature value.
% Not used in the BasicThermal model.
MotorDriveUnit.AmbientTemperature = simscape.Value(273.15 + 20, "K");

% Used in the BasicThermal model.
% Not used in the Basic model.
MotorDriveUnit.ThermalMass = simscape.Value(90, "kJ/K");
MotorDriveUnit.RadiationArea = simscape.Value(1, "m^2");
MotorDriveUnit.RadiationCoefficient = simscape.Value(5e-10, "W/K^4/m^2");
MotorDriveUnit.AmbientMass = simscape.Value(10000, "t");
MotorDriveUnit.AmbientSpecificHeat = simscape.Value(1000, "J/K/kg");

%% Block parameters in the harness model
% Parameters outside of the model under test.

BatteryHV.NominalVoltage = simscape.Value(340, "V");
BatteryHV.TerminalResistance = simscape.Value(0.01, "Ohm");

% BatteryHV.NominalCapacity = simscape.Value(60, "kW*hr");

MechanicalLoad.Inertia = simscape.Value(9, "kg*m^2");

%% Initial conditions

initial.LoadInertia_AngularSpeed = simscape.Value(0, "rpm");

initial.MotorDriveUnit_RotorAngularSpeed = simscape.Value(0, "rpm");
initial.MotorDriveUnit_Temperature = simscape.Value(273.15 + 20, "K");

initial.AmbientTemperature = simscape.Value(273.15 + 20, "K");
