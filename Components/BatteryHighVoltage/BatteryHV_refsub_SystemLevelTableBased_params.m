%% Model parameters for high voltage battery component
% For the table-based system-level battery.
%
% If you edit this file, make sure to run this to update variables
% before running harness model for simulation.

% Copyright 2023 The MathWorks, Inc.

%% Bus definitions

defineBus_HighVoltage

%% Block parameters

% Tesla Model 3
% - Battery pack: 50 kWh, 360 V
% - Battery cell "2170": 3.6 V, 4.8 Ah (13.7 Wh)

%batteryHV.nominalVoltage_V = 350;
batteryHV.nominalVoltage_V = 360;

batteryHV.internalResistance_Ohm = 0.01;

%batteryHV.nominalCapacity_kWh = 4;
batteryHV.nominalCapacity_kWh = 50;

% Open Circuit Voltage. 3.5 V to 3.7 V assuming Lithium-ion
%batteryHV.voltagePerCell_V = 3.7;
batteryHV.voltagePerCell_V = 3.6;

batteryHV.cellCharge_Ahr = 4.8;

batteryHV.nominalCharge_Ahr = ...
  BatteryHV_getAmpereHourRating( ...
    Voltage_V = batteryHV.nominalVoltage_V, ...
    Capacity_kWh = batteryHV.nominalCapacity_kWh, ...
    StateOfCharge_pct = 100 );

tmp = BatteryHV_getBatteryPackParameters( ...
  PackNominalCapacity_kWh = batteryHV.nominalCapacity_kWh, ...
  PackTerminalVoltage_V = batteryHV.nominalVoltage_V, ...
  CellVoltage_V = batteryHV.voltagePerCell_V, ...
  CellCharge_Ahr = batteryHV.cellCharge_Ahr );

batteryHV.NumCellsInSeries = tmp.NumCellsInSeries; 
batteryHV.NumStringsInParallel = tmp.NumStringsInParallel;

% Ambient

%ambient.temp_K = 273.15 + 20;
%ambient.mass_t = 10000;
%ambient.SpecificHeat_J_per_Kkg = 1000;
batteryHV.ambientMass_t = 10000;
batteryHV.ambientSpecificHeat_J_per_Kkg = 1000;
batteryHV.ambientTemp_K = 273.15 + 20;

batteryHV.RadiationArea_m2 = 1;
batteryHV.RadiationCoeff_W_per_K4m2 = 5e-10;

%% Initial conditions

initial.hvBattery_SOC_pct = 70;

initial.hvBattery_SOC_normalized = initial.hvBattery_SOC_pct / 100;

initial.hvBattery_Charge_Ahr = ...
  BatteryHV_getAmpereHourRating( ...
    Voltage_V = batteryHV.nominalVoltage_V, ...
    Capacity_kWh = batteryHV.nominalCapacity_kWh, ...
    StateOfCharge_pct = initial.hvBattery_SOC_pct );

initial.hvBattery_Temperature_K = batteryHV.ambientTemp_K;

initial.ambientTemp_K = batteryHV.ambientTemp_K;
