function data = BatteryHVDetailed_getParamsCommon(nvpairs)
%% Model Parameters for the Detailed High Voltage Battery component
% Use this function to set default values for the parameters of the detailed battery.
%
% The single-module approximation version of the detailed battery has
% the batteryHV_single struct variable in the block parameters.
% To set values to it, use this function as follows.
%
%   batteryHV_single = BatteryHVDetailed_params_Common;
%
% To load parameters for the multi-module version of the detailed battery,
% the BatteryHVDetailed_params_MultiModule function is used.

% Copyright 2020-2022 The MathWorks, Inc.

arguments
  nvpairs.NumParallelCellsInString {mustBeInteger, mustBePositive} = 2
  nvpairs.NumSeriesStrings {mustBeInteger, mustBePositive} = 18
end

N_parallel = nvpairs.NumParallelCellsInString;
N_series = nvpairs.NumSeriesStrings;
N_cells = N_parallel * N_series;

% Number of parallel cells in a string
data.batteryNp = N_parallel;

% Number of series connected strings
data.batteryNs = N_series;

% Number of cells per module
data.battery_N_cells = N_cells;

% Ambient temperature
data.AmbTemp_K = 273.15 + 20;

% Coolant flow rate
data.batteryCoolantFlwR = 0.1;

% Coolant temperature
data.batteryCoolantFlwT = -10;

% Battery cell charge
data.cellCharge_Ahr = 10;

% State of charge table breakpoints S
data.batterySOC_LUT = [0 0.1 0.25 0.5 0.75 0.9 1]';

% Temperature table breakpoints T
data.batteryTemp_LUT = [278 293 313];

% Max C-rate for given Temp and SoC
data.cRate = [
    0    0    0
    1    2    2
    2    2    3
    2    3    4
    2    3    4
    3    4    5
    4    5    6];

data.battery_T_degC_init = 30;

data.battery_SOC_init = 0.95;

% [kg] Cell mass
data.batteryCell_mass = 0.125;

% Battery cell height [m]
data.batteryCell_H = 0.2;

% Battery cell thickness [m]
data.batteryCell_T = 0.012;

% Battery cell width [m]
data.batteryCell_W = 0.12;

% Battery Module ascessory resistance (Ohm)
data.battery_extR = 0;

data.batteryCoolant_flow = [.01, .02, .03, .04, .05, .06];

% Battery cell (through-plane) thermal conductivity [W/mK]
data.batteryThermal_K1 = 0.8;

% Battery cell (in-plane) thermal conductivity [W/mK]
data.batteryThermal_K2 = 800;

% [J/kg/K] Cell specific heat
data.batteryCell_cp = 795;

% [V] Em open-circuit voltage vs SOC rows and T columns
data.batteryEm_LUT = [
    3.4966    3.5057    3.5148
    3.5519    3.5660    3.5653
    3.6183    3.6337    3.6402
    3.7066    3.7127    3.7213
    3.9131    3.9259    3.9376
    4.0748    4.0777    4.0821
    4.1923    4.1928    4.1930];
data.minVolt = min(min(data.batteryEm_LUT));

% [Ohm] R0 resistance vs SOC rows and T columns
data.batteryR0_LUT = [
    0.0117    0.0085    0.0090
    0.0110    0.0085    0.0090
    0.0114    0.0087    0.0092
    0.0107    0.0082    0.0088
    0.0107    0.0083    0.0091
    0.0113    0.0085    0.0089
    0.0116    0.0085    0.0089];

% [Ohm] R1 Resistance vs SOC rows and T columns
data.batteryR1_LUT = [
    0.0109    0.0029    0.0013
    0.0069    0.0024    0.0012
    0.0047    0.0026    0.0013
    0.0034    0.0016    0.0010
    0.0033    0.0023    0.0014
    0.0033    0.0018    0.0011
    0.0028    0.0017    0.0011];

% [F] C1 Capacitance vs SOC rows and T columns
data.batteryC1_LUT = [
    1913.6    12447    30609
    4625.7    18872    32995
    23306     40764    47535
    10736     18721    26325
    18036     33630    48274
    12251     18360    26839
    9022.9    23394    30606];
data.batteryTau1_LUT = data.batteryR1_LUT .* data.batteryC1_LUT;

% Heat transfer coefficient
data.batteryCoolantHTC = zeros(3, 6, N_cells);

% Cell-to-cell capacity variation (-)
data.batteryModuleCellR0_ini = ones(1, N_cells);

% Cell-to-cell initial SOC variation (-)
data.batteryModuleCellSOC_ini = data.battery_SOC_init * ones(1, N_cells);

% Cell-to-cell initial temperature variation (K)
data.batteryModuleCellT_ini = (data.battery_T_degC_init + 273.15) * ones(1, N_cells);

% Cell-to-cell external heat flux variation (W)
data.batteryModuleExtHeat = zeros(1, N_cells);

% Cell-to-cell resistance variation (-) for Module
data.batteryModuleCellAhr_ini = ones(1, N_cells);

% Control Parameter
data.batteryCharge_Ahr = data.cellCharge_Ahr * N_parallel;
data.initial_batteryCharge_Ahr = data.cellCharge_Ahr * N_parallel;

%% For multi-module version only

% Heat transfer coefficient on module top
data.batteryModuleTopHTC = 1;

% Heat transfer coefficient on module bottom
data.batteryModuleBottomHTC = zeros(3, 6, N_cells);

end  % function
