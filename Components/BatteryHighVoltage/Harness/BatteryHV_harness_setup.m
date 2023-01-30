%% Model parameters for high voltage battery harness model
% This script is run automatically when harness model opens.
%
% This scriprt loads variables in the base workspace for the following battery models. 
% - Basic battery model
% - System-level battery model, simple
% - System-level battery model
% - System-level battery model, tabled-based
%
% If you edit this file, make sure to run this to update variables
% in the base workspace before running simulation.

% Copyright 2022-2023 The MathWorks, Inc.

%% Bus definitions

defineBus_HighVoltage

%% Battery parameters

% ==================
% Parameters used by
% - Basic battery
% - System-level battery, simple
% - System-level battery
% - System-level battery, tabled-based

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

% ==================
% Parameters used by
% - System-level battery, simple
% - System-level battery

% Voltage is 90 % of the nominal when SOC is 50 %.
batteryHV.measuredVoltage_V = batteryHV.nominalVoltage_V * 0.9;
batteryHV.measuredCharge_Ahr = batteryHV.nominalCharge_Ahr * 0.5;

% This represents the entire battery pack.
% Table-based battery block uses another parameter.
batteryHV.ThermalMass_J_per_K = 10e3;

% ==================
% Parameters used by
% - System-level battery

% More thermal model parameters
% These parameters are used when thermal model is enabled
% in the Battery block from Simscape Electrical.
batteryHV.measurementTemperature_K = 273.15 + 25;
batteryHV.secondMeasurementTemperature_K = 273.15 + 0;
batteryHV.secondNominalVoltage_V = batteryHV.nominalVoltage_V * 0.95;
batteryHV.secondInternalResistance_Ohm = batteryHV.internalResistance_Ohm * 2;
batteryHV.secondMeasuredVoltage_V = batteryHV.nominalVoltage_V * 0.9;

% ==================
% Parameters used by
% - Table-based battery

batteryHV.NumCellsInSeries = 106;
batteryHV.NumStringsInParallel = 1;
batteryHV.NumTotalCells = batteryHV.NumCellsInSeries * batteryHV.NumStringsInParallel;

% -----
% Tabled-Based Battery block.
% Parameters for a battery cell, representing the whole battery pack.

% State of charge ... independent variable 1
batteryHV.SOC_pct = 0 : 100;
batteryHV.SOC_normalized = 0 : 0.01 : 1;

% Temperature ... independent variable 2
batteryHV.Temperatures_degC = [0 25 60];

% Open-circuit voltage (cell voltage) as a function of SOC and temperature.
% This data must represent a cell.
% This is multiplied by Voltage-Controlled Voltage Source block in the model
% to represent pack's terminal voltage.
batteryHV.OpenCircuitVoltage_V = ...
  BatteryHV_buildOpenCircuitVoltageData( ...
     0, [ 0 2.8; 10 3.0; 15 3.1; 25 3.3; 75 3.4; 90 3.5; 100 3.6 ], ...
    25, [ 0 2.9; 10 3.1; 15 3.2; 25 3.4; 75 3.5; 90 3.6; 100 3.9 ], ...
    60, [ 0 3.0; 10 3.3; 15 3.4; 25 3.6; 75 3.7; 90 3.8; 100 4.15 ]);
% degC, [ SOC_1, OCV_1; SOC_2, OCV_2; ... ]

% Terminal resistance as a function of SOC and temperature.
% This data must represent a cell.
batteryHV.TerminalResistance_Ohm = ...
  BatteryHV_buildTerminalResistanceData( ...
     0, [ 0 0.47 ; 5 0.45  ; 15 0.218 ; 40 0.101 ; 80 0.086 ; 100 0.1   ], ...
    25, [ 0 0.17 ; 5 0.12  ; 15 0.072 ; 40 0.053 ; 80 0.044 ; 100 0.033 ], ...
    60, [ 0 0.13 ; 5 0.005 ; 15 0.04  ; 40 0.037 ; 80 0.03  ; 100 0.024 ]);
% degC, [ SOC_1, TR_1; SOC_2, TR_2; ... ]

% Ampere-hour rating.
% This must be the total charge, rather than a single cell,
% thus this is determined from battery pack specifications.
batteryHV.CellCharge_Ahr = batteryHV.nominalCharge_Ahr;

batteryHV.ThermalMassOfSingleCell_J_per_K = 100;
batteryHV.ThermalMassOfAllCells_J_per_K = ...
  batteryHV.ThermalMassOfSingleCell_J_per_K * batteryHV.NumTotalCells;

% -----
% Voltage-Controlled Voltage Source block
batteryHV.VoltageGain = -1 * batteryHV.NumCellsInSeries;

% -----
% Current-Controlled Current Source block
batteryHV.CurrentGain = (-1 * batteryHV.NumStringsInParallel) + 1;

%% Ambient parameters
% Included in the battery component for thermal simulation

batteryHV.ambientTemp_K = 273.15 + 20;

batteryHV.ambientMass_t = 10000;
batteryHV.ambientSpecificHeat_J_per_Kkg = 1000;

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
