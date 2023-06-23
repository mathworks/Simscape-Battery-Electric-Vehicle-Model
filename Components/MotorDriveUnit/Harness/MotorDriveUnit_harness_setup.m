%% Setup script for Motor Drive Unit harness model
%
% If you edit this file, make sure to run this to update variables
% in the base workspace before running simulation.

% Copyright 2021-2023 The MathWorks, Inc.

%% Connection Bus definitions

defineBus_HighVoltage
defineBus_Rotational

%% Motor & Drive block parameters

% ==================
% Parameters used by
% - Basic
% - Basic, thermal
% - System
% - System, tabulated losses
motorDriveUnit.trqMax_Nm = 420;
motorDriveUnit.powerMax_kW = 220;
motorDriveUnit.responseTime_s = 0.02;

motorDriveUnit.rotorInertia_kg_m2 = 5*0.01^2;
motorDriveUnit.rotorDamping_Nm_per_radps = 1e-5;

% ==================
% Parameters used by
% - Basic
% - Basic, thermal
% - System
motorDriveUnit.efficiency_pct = 95;
motorDriveUnit.spd_eff_rpm = 2000;
motorDriveUnit.trq_eff_Nm = 50;

% ==================
% Parameters used by
% - System
motorDriveUnit.ironLoss_W = 55;
motorDriveUnit.fixedLoss_W = 40;

% ==================
% Parameters used by
% - Basic, thermal
% - System
motorDriveUnit.ThermalMass_J_per_K = 90e3;

% ==================
% Parameters used by
% - System, tabulated losses

% Independent variables for loss table.
motorDriveUnit.spdVec_rpm = [100, 450, 800, 1150, 1500];
motorDriveUnit.trqVec_Nm = [10, 45, 80, 115, 150];

% Electrical losses as a function of speed and torque,
% f(speedVector, torqueVector)
motorDriveUnit.electricalLosses_W = ...
[ 16.02, 251,   872.8, 2230, 4998; ... min torque
  29.77, 262,   875.7, 2217, 4950; ...
  45.35, 281.2, 900,   2217, 4796; ...
  62.14, 299,   924.8, 2191, 4567; ...
  81.1,  320.9, 943.1, 2146, 4379];  % max torque
% min spd                    max spd

%% Ambient parameters

% ==================
% Parameters used by
% - Basic
% - Basic, thermal
% - System

motorDriveUnit.ambientTemp_K = 273.15 + 20;

% ==================
% Parameters used by
% - Basic, thermal
% - System

motorDriveUnit.ambientMass_t = 10000;
motorDriveUnit.ambientSpecificHeat_J_per_Kkg = 1000;

motorDriveUnit.RadiationArea_m2 = 1;
motorDriveUnit.RadiationCoeff_W_per_K4m2 = 5e-10;

%% Block parameters in harness model
% Parameters outisde of the model under test.

batteryHV.nominalVoltage_V = 340;
batteryHV.nominalCapacity_kWh = 60;
batteryHV.internalResistance_Ohm = 0.01;

%% Initial conditions

% Outside of the model under test
initial.loadInertiaSpd_rpm = 0;

initial.motorDriveUnit_RotorSpd_rpm = 0;

% ==================
% Parameters used by
% - Battery, thermal
% - System

initial.motorDriveUnit_Temperature_K = motorDriveUnit.ambientTemp_K;
initial.ambientTemp_K = motorDriveUnit.ambientTemp_K;
