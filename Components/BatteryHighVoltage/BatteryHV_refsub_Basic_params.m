%% Model parameters for high voltage battery component
% This script contains parameters required by the following model only.
% - Basic battery model
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

% This is required by the Battery Status block but
% does not affect any simulation behavior in the basic battery model.
batteryHV.ambientTemp_K = 273.15 + 20;

%% Initial conditions

initial.hvBattery_SOC_pct = 70;

initial.hvBattery_Charge_Ahr = ...
  BatteryHV_getAmpereHourRating( ...
    Voltage_V = batteryHV.nominalVoltage_V, ...
    Capacity_kWh = batteryHV.nominalCapacity_kWh, ...
    StateOfCharge_pct = initial.hvBattery_SOC_pct );
