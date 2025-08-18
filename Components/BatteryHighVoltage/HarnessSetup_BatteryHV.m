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

%% Parameters for testing

% Negative value for charing.
testParam.CRate = -0.1;

testParam.LoadCurrent = simscape.Value(0, "A");

testParam.NominalCapacity = simscape.Value(60, "kWh");

testParam.NominalVoltage = simscape.Value(340, "V");

testParam.NominalCharge = HighVoltageBatteryTool1.getAmpereHourRating( ...
  Capacity = testParam.NominalCapacity, ...
  Voltage = testParam.NominalVoltage, ...
  StateOfCharge = 1.0 );  % SOC=1 to get the nominal value.

%% Battery parameters

% ==================
% Parameters used by
% - Basic battery
% - System-level battery, simple
% - System-level battery
% - System-level battery, tabled-based

batteryHV.nominalCapacity_kWh = value(testParam.NominalCapacity, "kWh");

batteryHV.nominalVoltage_V = value(testParam.NominalVoltage, "V");

batteryHV.nominalCharge_Ahr = value(testParam.NominalCharge, "Ah");

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
