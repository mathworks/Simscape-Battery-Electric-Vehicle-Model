function data = BatteryHVDetailed_getParamsMultiModule(nvpairs)
%% Parameters for Detailed High Voltage Multi-Module Battery
% In this script, the battery is assumed to consist of two packs
% with the same parameters.

% Copyright 2020-2022 The MathWorks, Inc.

arguments
  nvpairs.NumParallelCellsInStringPerPack {mustBeInteger, mustBePositive} = 2
  nvpairs.NumSeriesStringsPerPack {mustBeInteger, mustBePositive} = 18
end

Nparallel_pack = nvpairs.NumParallelCellsInStringPerPack;
Nseries_pack = nvpairs.NumSeriesStringsPerPack;

%% Parameters for pack 1

pack1 = BatteryHVDetailed_getParamsCommon( ...
  NumParallelCellsInString = Nparallel_pack, ...
  NumSeriesStrings = Nseries_pack );

%% Parameter for pack 2

pack2 = BatteryHVDetailed_getParamsCommon( ...
  NumParallelCellsInString = Nparallel_pack, ...
  NumSeriesStrings = Nseries_pack );

%% Parameters outside of the above packs

% Coolant flow rate
other.batteryCoolantFlwR = 0.1;

% Coolant temperature
other.batteryCoolantFlwT = -10;

% Ambient temperature
other.AmbTemp_K = 273.15 + 20;

% Battery cell charge
other.cellCharge_Ahr = 10;

other.minVolt = min(min(pack1.batteryEm_LUT));

% Number of parallel cells in a stringin pack
other.batteryNp = pack1.batteryNp + pack2.batteryNp;

% Number of series connected strings in pack
other.batteryNs = pack1.batteryNs + pack2.batteryNs;

% Number of cells for all packs
Ncells_all = pack1.battery_N_cells + pack2.battery_N_cells;
other.battery_N_cells = Ncells_all;

% battery pack current rating
other.batteryPackAhr_ini = ...
  max( max(pack1.initial_batteryCharge_Ahr), ...
       max(pack2.initial_batteryCharge_Ahr) ) ...
  * pack1.batteryNp * 2;
other.batteryCharge_Ahr = other.batteryPackAhr_ini;

%% Parameters for a Look-Up Table in the Controller
% Used in the Charge Discharge Constraint subsystem.

bevControl.batteryCharge_Ahr = other.batteryCharge_Ahr;

% State of charge table breakpoints S
bevControl.batterySOC_LUT = [0 0.1 0.25 0.5 0.75 0.9 1]';

% Temperature table breakpoints T
bevControl.batteryTemp_LUT = [278 293 313];

% Max C-rate for given Temp and SoC
bevControl.cRate = [
    0    0    0
    1    2    2
    2    2    3
    2    3    4
    2    3    4
    3    4    5
    4    5    6 ];

%% Additional information
% Not required by the high voltage battery component, but included because useful.

powerRating_pack1_kW = ...
  median(pack1.initial_batteryCharge_Ahr) * pack1.battery_N_cells * 6 ...
  * median(median(pack1.batteryEm_LUT));

powerRating_pack2_kW = ...
  median(pack2.initial_batteryCharge_Ahr) * pack2.battery_N_cells * 6 ...
    * median(median(pack2.batteryEm_LUT));

info.PowerRating_pack1_kW = powerRating_pack1_kW;
info.PowerRating_pack2_kW = powerRating_pack2_kW;
info.PowerRating_kW = powerRating_pack1_kW + powerRating_pack2_kW;

%% Initial conditions

other.battery_SOC_init = pack1.battery_SOC_init;

%%
data.pack1 = pack1;
data.pack2 = pack2;
data.other = other;
data.bevControl = bevControl;
data.info = info;
end  % function
