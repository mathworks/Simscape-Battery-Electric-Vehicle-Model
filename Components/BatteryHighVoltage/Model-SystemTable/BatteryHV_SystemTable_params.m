%% Model parameters for high voltage battery component
% This script contains parameters required by the following model only.
% - System-level battery model, table-based
%
% If you edit this file, make sure to run this to update variables
% in the base workspace before running simulation.

% Copyright 2023 The MathWorks, Inc.

%% Bus definitions

defineBus_HighVoltage

%% Battery parameters

% === High voltage battery pack ===
% System-level specifications

batteryHV.nominalVoltage_V = 340;

batteryHV.nominalCapacity_kWh = 60;

batteryHV.nominalCharge_Ahr = ...
  BatteryHV_getAmpereHourRating( ...
    Voltage_V = batteryHV.nominalVoltage_V, ...
    Capacity_kWh = batteryHV.nominalCapacity_kWh, ...
    StateOfCharge_pct = 100 );

% Table-based battery has terminal resistance parameter as a lookup table,
% but this is used to approximately compute the I-squared R loss.
batteryHV.internalResistance_Ohm = 0.01;

batteryHV.NumCellsInSeries = 106;
batteryHV.NumStringsInParallel = 1;

batteryHV.NumTotalCells = batteryHV.NumCellsInSeries * batteryHV.NumStringsInParallel;

% --- Tabled-Based Battery block ---
% Parameters for a battery cell block, representing the whole battery pack.

% State of charge ... independent variable 1
batteryHV.SOC_pct = 0 : 100;
batteryHV.SOC_normalized = 0 : 0.01 : 1;

% Temperature ... independent variable 2
batteryHV.Temperatures_degC = [0 25 60];

% Open-circuit voltage (cell voltage) as a function of SOC and temperature.
% This data must represent a cell.
% This should be multiplied by Voltage-Controlled Voltage Source block in the model.
tmpdata = HighVoltageBatteryTool1.refineOCVData( ...
  Temperature = simscape.Value(batteryHV.Temperatures_degC, "degC"), ...
  SOC = [0; 0.1; 0.15; 0.25; 0.75; 0.9; 1], ...
  SOCInterval = 0.01, ...
  OCV = simscape.Value( ...
  [2.8, 2.9, 3.0; 3.0, 3.1, 3.3; 3.1, 3.2, 3.4; 3.3, 3.4, 3.6; 3.4, 3.5, 3.7; 3.5, 3.6, 3.8; 3.6, 3.9, 4.15], ...
  "V") );
batteryHV.OpenCircuitVoltage_V = value(tmpdata.OCV);
clear tmpdata

% Terminal resistance as a function of SOC and temperature.
% This data must represent a cell.
tmpdata = HighVoltageBatteryTool1.refineTerminalResistanceData( ...
  Temperature = simscape.Value(batteryHV.Temperatures_degC, "degC"), ...
  SOC = [0; 0.05; 0.15; 0.4; 0.8; 1], ...
  SOCInterval = 0.01, ...
  TerminalResistance = simscape.Value( ...
  [0.47 0.17 0.13; 0.45 0.12 0.005; 0.218 0.072 0.04; 0.101 0.053 0.037; 0.086 0.044 0.03; 0.1 0.033 0.024], ...
  "Ohm") );
batteryHV.TerminalResistance_Ohm = value(tmpdata.TerminalResistance);
clear tmpdata

% Ampere-hour rating.
% This must be the total charge, rather than a single cell,
% thus this is determined from battery pack specifications.
batteryHV.CellCharge_Ahr = batteryHV.nominalCharge_Ahr;

batteryHV.ThermalMassOfSingleCell_J_per_K = 100;
batteryHV.ThermalMassOfAllCells_J_per_K = ...
  batteryHV.ThermalMassOfSingleCell_J_per_K * batteryHV.NumTotalCells;

% --- Voltage-Controlled Voltage Source ---
batteryHV.VoltageGain = -1 * batteryHV.NumCellsInSeries;

% --- Current-Controlled Current Source ---
batteryHV.CurrentGain = (-1 * batteryHV.NumStringsInParallel) + 1;

% === Ambient parameters ===
% Included in the battery component for thermal simulation

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
