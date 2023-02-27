function params = BatteryHV_getBatteryPackParameters(nvpairs)
%% Computes paramters for high voltage battery pack from 
% This function takes the following information
%
% - Pack nominal capacity (kWh)
% - Pack terminal voltage (V)
% - Cell voltage (V)
% - Cell charge (Ah)
%
% and computes the following data characterising the battery
%
% - Cell capacity (kWh)
% - Pack nominal charge (Ahr)
% - Number of cells in series
% - Charge in single string (Ahr)
% - Number of strings in parallel
% - Number of total cells
%
% and additionally the following data to help validate calculation result
%
% - Simulated capacity (kWh)
% - Difference between specified and simulated capacities (kWh)
% - Simulated terminal voltage (V)
% - Difference in specified and simulated terminal voltage (V)
%
% Arguments of this function have default values.
% You can run this function without any arguments to test that it works.

% Copyright 2023 The MathWorks, Inc.

arguments

  % Battery pack capacity
  nvpairs.PackNominalCapacity_kWh = 50;

  % Battery pack terminal voltage
  nvpairs.PackTerminalVoltage_V = 360;

  % Battery cell voltage
  % Open Circuit Voltage. 3.5V to 3.7V assuming Lithium-ion
  nvpairs.CellVoltage_V = 3.6;

  % Battery cell ampere-hour rating
  %nvpairs.CellCharge_Ahr = 3.153;
  nvpairs.CellCharge_Ahr = 4.8;

end

packNominalCapacity_kWh = nvpairs.PackNominalCapacity_kWh;
packTerminalVoltage_V = nvpairs.PackTerminalVoltage_V;
cellVoltage_V = nvpairs.CellVoltage_V;
cellCharge_Ahr = nvpairs.CellCharge_Ahr;
% initialStateOfCharge_pct = nvpairs.InitialStateOfCharge_pct;

cellCapacity_kWh = cellVoltage_V * cellCharge_Ahr / 1000;

% Battery pack ampere-hour rating
packNominalCharge_Ahr = packNominalCapacity_kWh / packTerminalVoltage_V * 1000;

% Number of cells connected in series to form a cell string
NumCellsInSeries = ceil(packTerminalVoltage_V / cellVoltage_V);
assert(NumCellsInSeries > 1)

% Ampere-hour rating of a cell string is equivalent to that of a cell.
stringCharge_Ahr = cellCharge_Ahr;

% Number of cell strings connected in parallel to form a pack
NumStringsInParallel = ceil(packNominalCharge_Ahr / stringCharge_Ahr);
assert(NumStringsInParallel >= 1)

% Number of all cells in a pack
NumTotalCells = NumCellsInSeries * NumStringsInParallel;

simulatedCapacity_kWh = cellCapacity_kWh * NumTotalCells;
diffCapacity_kWh = simulatedCapacity_kWh - packNominalCapacity_kWh;

simulatedTerminalVoltage_V = NumCellsInSeries * cellVoltage_V;
diffTerminalVoltage_V = simulatedTerminalVoltage_V - packTerminalVoltage_V;

params.PackNominalCapacity_kWh = nvpairs.PackNominalCapacity_kWh;
params.PackTerminalVoltage_V = nvpairs.PackTerminalVoltage_V;
params.CellVoltage_V = nvpairs.CellVoltage_V;
params.CellCharge_Ahr = nvpairs.CellCharge_Ahr;

params.CellCapacity_kWh = cellCapacity_kWh;
params.PackNominalCharge_Ahr = packNominalCharge_Ahr;
params.NumCellsInSeries = NumCellsInSeries;
params.StringCharge_Ahr = stringCharge_Ahr;
params.NumStringsInParallel = NumStringsInParallel;
params.NumTotalCells = NumTotalCells;
params.SimulatedCapacity_kWh = simulatedCapacity_kWh;
params.DiffCapacity_kWh = diffCapacity_kWh;
params.SimulatedTerminalVoltage_V = simulatedTerminalVoltage_V;
params.DiffTerminalVoltage_V = diffTerminalVoltage_V;

end  % function
