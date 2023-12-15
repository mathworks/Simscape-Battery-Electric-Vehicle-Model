%% Model parameters for high voltage battery component
% This script contains parameters required by the following model only.
% - System-level battery model, simple
%
% If you edit this file, make sure to run this to update variables
% in the base workspace before running simulation.

% Copyright 2022-2023 The MathWorks, Inc.

%% Bus definitions

defineBus_HighVoltage

%% Battery parameters

batteryHV.nominalVoltage_V = 340;

batteryHV.nominalCapacity_kWh = 60;

batteryHV.nominalCharge_Ahr = ...
  BatteryHV_getAmpereHourRating( ...
    Voltage_V = batteryHV.nominalVoltage_V, ...
    Capacity_kWh = batteryHV.nominalCapacity_kWh, ...
    StateOfCharge_pct = 100 );

batteryHV.internalResistance_Ohm = 0.01;

% Voltage is 90 % of the nominal when SOC is 50 %.
batteryHV.measuredVoltage_V = batteryHV.nominalVoltage_V * 0.9;
batteryHV.measuredCharge_Ahr = batteryHV.nominalCharge_Ahr * 0.5;

batteryHV.ThermalMass_J_per_K = 300;

%% Ambient parameters
% Included in the battery component for thermal simulation

batteryHV.ambientTemp_K = 273.15 + 20;

batteryHV.ambientMass_t = 10000;
batteryHV.ambientSpecificHeat_J_per_Kkg = 1000;

batteryHV.RadiationArea_m2 = 1;
batteryHV.RadiationCoeff_W_per_K4m2 = 5e-10;

%% Initial conditions

initial.hvBattery_SOC_pct = 70;

initial.hvBattery_Charge_Ahr = ...
  BatteryHV_getAmpereHourRating( ...
    Voltage_V = batteryHV.nominalVoltage_V, ...
    Capacity_kWh = batteryHV.nominalCapacity_kWh, ...
    StateOfCharge_pct = initial.hvBattery_SOC_pct );

initial.hvBattery_Temperature_K = batteryHV.ambientTemp_K;

initial.ambientTemp_K = batteryHV.ambientTemp_K;
