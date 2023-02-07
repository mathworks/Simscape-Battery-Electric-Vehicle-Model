%% Parameters for Motor Drive Unit component
%
% If you edit this file, make sure to run this to update variables
% in the base workspace before running simulation.

% Copyright 2021-2023 The MathWorks, Inc.

%% Connection Bus definitions

defineBus_HighVoltage
defineBus_Rotational

%% Motor drive unit parameters

motorDriveUnit.trqMax_Nm = 420;
motorDriveUnit.powerMax_kW = 220;
motorDriveUnit.responseTime_s = 0.02;

motorDriveUnit.efficiency_pct = 95;
motorDriveUnit.spd_eff_rpm = 2000;
motorDriveUnit.trq_eff_Nm = 50;

motorDriveUnit.rotorInertia_kg_m2 = 5*0.01^2;

motorDriveUnit.rotorDamping_Nm_per_radps = 1e-5;

%% Ambient parameters

% The "Basic" model does not simulate temperature dynamics.
% This is used just to provide a constant value for signal logging.
motorDriveUnit.ambientTemp_K = 273.15 + 20;

%% Initial conditions

initial.motorDriveUnit_Temperature_K = motorDriveUnit.ambientTemp_K;
initial.ambientTemp_K = motorDriveUnit.ambientTemp_K;

initial.motorDriveUnit_RotorSpd_rpm = 0;
