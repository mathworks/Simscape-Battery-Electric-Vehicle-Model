%% Model parameters for motor drive unit component
% This script is for the model using system-level motor and drive block
% without thermal model.
%
% If you edit this file, make sure to run this to update variables
% in the base workspace before running simulation.

% Copyright 2023 The MathWorks, Inc.

%% Connection Bus definitions

defineBus_HighVoltage
defineBus_Rotational

%% Motor drive unit parameters

motorDriveUnit.trqMax_Nm = 420;
motorDriveUnit.powerMax_kW = 220;
motorDriveUnit.responseTime_s = 0.02;

motorDriveUnit.rotorInertia_kg_m2 = 5*0.01^2;
motorDriveUnit.rotorDamping_Nm_per_radps = 1e-5;

% Single efficiency measurement
motorDriveUnit.efficiency_pct = 95;
motorDriveUnit.spd_eff_rpm = 2000;
motorDriveUnit.trq_eff_Nm = 50;
motorDriveUnit.ironLoss_W = 55;
motorDriveUnit.fixedLoss_W = 40;

motorDriveUnit.rotorInertia_kg_m2 = 5*0.01^2;
motorDriveUnit.rotorDamping_Nm_per_radps = 1e-5;

motorDriveUnit.ThermalMass_J_per_K = 90e3;

%% Ambient parameters
% Included in the motor drive unit component for thermal simulation.

motorDriveUnit.ambientTemp_K = 273.15 + 20;

motorDriveUnit.ambientMass_t = 10000;
motorDriveUnit.ambientSpecificHeat_J_per_Kkg = 1000;

motorDriveUnit.RadiationArea_m2 = 1;
motorDriveUnit.RadiationCoeff_W_per_K4m2 = 5e-10;

%% Initial conditions

initial.motorDriveUnit_RotorSpd_rpm = 0;

initial.motorDriveUnit_Temperature_K = motorDriveUnit.ambientTemp_K;
initial.ambientTemp_K = motorDriveUnit.ambientTemp_K;
