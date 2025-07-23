%% Model parameters for motor drive unit component
% This script is for the model using tabulated motor and drive block
% without thermal model.
% Enabling thermal model requires two parameter sets for electrical losses
% that are measured at different temperatures, such as at 25 degC and 125 degC.
%
% If you edit this file, make sure to run this to update variables
% in the base workspace before running simulation.

% Copyright 2023 The MathWorks, Inc.

%% Connection Bus definitions

defineBus_HighVoltage
defineBus_Rotational

%% Motor drive unit parameters

motorDriveUnit.trqMax_Nm = 420;
motorDriveUnit.powMax_kW = 220;
motorDriveUnit.responseTime_s = 0.02;

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

motorDriveUnit.rotorInertia_kg_m2 = 5*0.01^2;

motorDriveUnit.rotorDamping_Nm_per_radps = 1e-5;

%% Ambient parameters
% Included in the motor drive unit component for thermal simulation.
% Used when thermal model is enabled. Default setting does not use this.
% Note that two parameter sets of loss data
% measured at different temperatures are required
% if tabulated loss is used.

motorDriveUnit.ambientTemp_K = 273.15 + 20;

motorDriveUnit.ambientMass_t = 10000;
motorDriveUnit.ambientSpecificHeat_J_per_Kkg = 1000;

motorDriveUnit.RadiationArea_m2 = 1;
motorDriveUnit.RadiationCoeff_W_per_K4m2 = 5e-10;

%% Initial conditions

initial.motorDriveUnit_Temperature_K = motorDriveUnit.ambientTemp_K;
initial.ambientTemp_K = motorDriveUnit.ambientTemp_K;

initial.motorDriveUnit_RotorSpd_rpm = 0;
