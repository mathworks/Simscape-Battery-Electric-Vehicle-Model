%% Model parameters for high voltage battery component
% For the basic battery

% Copyright 2022-2023 The MathWorks, Inc.

%% Bus

defineBus_HighVoltage

%% Battery specifications

batteryHV.nominalVoltage_V = 350;

batteryHV.internalResistance_Ohm = 0.01;

batteryHV.nominalCapacity_kWh = 4;

% Open Circuit Voltage. 3.5V to 3.7V assuming Lithium-ion
batteryHV.voltagePerCell_V = 3.7;

batteryHV.nominalCharge_Ahr = ...
  BatteryHV_getAmpereHourRating( ...
    Voltage_V = batteryHV.nominalVoltage_V, ...
    Capacity_kWh = batteryHV.nominalCapacity_kWh, ...
    StateOfCharge_pct = 100 );

% This is required by the Battery Status block but
% does not affect any simulation behavior in the basic battery.
ambient.temp_K = 273.15 + 20;

%% Initial conditions

initial.hvBattery_SOC_pct = 70;

initial.hvBattery_Charge_Ahr = ...
  BatteryHV_getAmpereHourRating( ...
    Voltage_V = batteryHV.nominalVoltage_V, ...
    Capacity_kWh = batteryHV.nominalCapacity_kWh, ...
    StateOfCharge_pct = initial.hvBattery_SOC_pct );
