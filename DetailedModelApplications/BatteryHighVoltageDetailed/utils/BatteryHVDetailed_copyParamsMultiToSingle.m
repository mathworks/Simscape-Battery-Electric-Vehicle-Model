function dst = BatteryHVDetailed_copyParamsMultiToSingle(src)
%% Model Parameters for Detailed Battery Module

% Copyright 2020-2022 The MathWorks, Inc.

% Coolant flow rate
dst.batteryCoolantFlwR = src.pack1.batteryCoolantFlwR;

% Coolant temperature
dst.batteryCoolantFlwT = src.pack1.batteryCoolantFlwT;

dst.AmbTemp_K = src.pack1.AmbTemp_K;

%%
% Number of parallel cells in a string
dst.batteryNp = src.pack1.batteryNp * 2;

% Number of series connected strings
dst.batteryNs = src.pack1.batteryNs * 6;

% Number of cells per module
dst.battery_N_cells = dst.batteryNp * dst.batteryNs;

% [kg] Cell mass
dst.batteryCell_mass = src.pack1.batteryCell_mass;

% [J/kg/K] Cell specific heat
dst.batteryCell_cp = src.pack1.batteryCell_cp;

%%

% State of charge table breakpoints S
dst.batterySOC_LUT = src.pack1.batterySOC_LUT;

% Temperature table breakpoints T
dst.batteryTemp_LUT = src.pack1.batteryTemp_LUT;

% Battery cell capacity
dst.batteryCharge_Ahr = src.pack1.batteryCharge_Ahr;

% [V] Em open-circuit voltage vs SOC rows and T columns
dst.batteryEm_LUT = src.pack1.batteryEm_LUT;

% [Ohm] R0 resistance vs SOC rows and T columns
dst.batteryR0_LUT = src.pack1.batteryR0_LUT;

% [Ohm] R1 Resistance vs SOC rows and T columns
dst.batteryR1_LUT = src.pack1.batteryR1_LUT;

% [F] C1 Capacitance vs SOC rows and T columns
dst.batteryC1_LUT = src.pack1.batteryC1_LUT;

%%

dst.batteryTau1_LUT = dst.batteryR1_LUT .* dst.batteryC1_LUT;

dst.batteryCoolantHTC = zeros(3, 6, dst.battery_N_cells);

% Battery cell (through-plane) thermal conductivity [W/mK]
dst.batteryThermal_K1 = src.pack1.batteryThermal_K1;

% Battery cell (in-plane) thermal conductivity [W/mK]
dst.batteryThermal_K2 = src.pack1.batteryThermal_K2;

%%

% Battery cell height [m]
dst.batteryCell_H = src.pack1.batteryCell_H;

% Battery cell thickness [m]
dst.batteryCell_T = src.pack1.batteryCell_T;

% Battery cell width [m]
dst.batteryCell_W = src.pack1.batteryCell_W;

% Battery module accessory resistance (Ohm)
dst.battery_extR = src.pack1.battery_extR;

%%

dst.batteryCoolant_flow = src.pack1.batteryCoolant_flow;

% Max C-rate for given Temp and SoC
dst.cRate = src.pack1.cRate;

%% Initial conditions

dst.battery_T_degC_init = src.pack1.battery_T_degC_init;

dst.battery_SOC_init = src.pack1.battery_SOC_init;

% Initial cell capacities
dst.batteryModuleCellR0_ini = ones(1, dst.battery_N_cells);

% Initial cell SOCs
dst.batteryModuleCellSOC_ini = dst.battery_SOC_init * ones(1, dst.battery_N_cells);

% Initial cell temperatures (K)
dst.batteryModuleCellT_ini = (dst.battery_T_degC_init + 273.15) * ones(1, dst.battery_N_cells);

% External heat flux for cells (W)
dst.batteryModuleExtHeat = zeros(1, dst.battery_N_cells);

% Initial cell resistances
dst.batteryModuleCellAhr_ini = ones(1, dst.battery_N_cells);

% Initial charge
dst.initial_batteryCharge_Ahr = dst.batteryCharge_Ahr * dst.batteryNp;

end  % function
