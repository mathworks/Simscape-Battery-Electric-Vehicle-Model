%% Model Parameters for BEV Drive Cycle with detail battery module

% Copyright 2020-2021 The MathWorks, Inc.
% Data for the two battery packs, HV1 and HV2, in parallel are same
% To run scenarios with different parameter values, run the script again

%% Vehicle
%Vehicle1DBasicParams
%-{
vehicle.vehMass_kg = 1600;
vehicle.tireRollingRadius_cm = 30;
vehicle.roadLoadA_N = 100;
vehicle.roadLoadB_N_per_kph = 0.05;
vehicle.roadLoadC_N_per_kph2 = 0.035;
vehicle.roadGrade=0;
%}

%% High Voltage Battery

batteryHV.batteryCoolantFlwR=0.1; % Coolant flow rate
batteryHV.batteryCoolantFlwT=300; % Coolant temperature
batteryHV.AmbTemp=293.15;

%% Battery Pack 
%In case the Multi module parameter is already loaded
%Single module battery copies the data from multi module battery pack
if exist('batteryHV1','var')
    batteryHV.batteryNp = batteryHV1.batteryNp*2;                          % Number of parallel cells in a string
    batteryHV.batteryNs = batteryHV1.batteryNs*6;                         % Number of series connected strings
    batteryHV.battery_N_cells = batteryHV.batteryNp*batteryHV.batteryNs; % Number of cells per module
    batteryHV.batteryCell_mass = batteryHV1.batteryCell_mass; % [kg] Cell mass
    batteryHV.batteryCell_cp = batteryHV1.batteryCell_cp; % [J/kg/K] Cell specific heat
    %
    batteryHV.batterySOC_LUT = batteryHV1.batterySOC_LUT;   % State of charge table breakpoints S
    batteryHV.batteryTemp_LUT = batteryHV1.batteryTemp_LUT;          % Temperature table breakpoints T
    batteryHV.batteryCapacity_LUT = batteryHV1.batteryCapacity_LUT; % Battery cell capacity at different (T) points [Ahr]
    batteryHV.batteryEm_LUT = batteryHV1.batteryEm_LUT; % [V] Em open-circuit voltage vs SOC rows and T columns
    batteryHV.batteryR0_LUT = batteryHV1.batteryR0_LUT; % [Ohm] R0 resistance vs SOC rows and T columns
    batteryHV.batteryR1_LUT = batteryHV1.batteryR1_LUT; % [Ohm] R1 Resistance vs SOC rows and T columns
    batteryHV.batteryC1_LUT = batteryHV1.batteryC1_LUT ; % [F] C1 Capacitance vs SOC rows and T columns
    %
    batteryHV.batteryTau1_LUT = batteryHV.batteryR1_LUT.*batteryHV.batteryC1_LUT;
    % batteryHV.batteryCoolant_flow=[.01, .02, .03, .04, .05, .06];
    batteryHV.batteryCoolantHTC=zeros(3, 6, batteryHV.battery_N_cells);
    % batteryHV.batteryModuleTopHTC = 1; % Heat transfer coefficient on module top
    batteryHV.batteryThermal_K1 =batteryHV1.batteryThermal_K1;  % Battery cell (through-plane) thermal conductivity [W/mK]
    batteryHV.batteryThermal_K2 = batteryHV1.batteryThermal_K2;  % Battery cell (in-plane) thermal conductivity [W/mK]
    %
    batteryHV.batteryCell_H = batteryHV1.batteryCell_H;   % Battery cell height [m]
    batteryHV.batteryCell_T = batteryHV1.batteryCell_T; % Battery cell thic.kness [m]
    batteryHV.batteryCell_W = batteryHV1.batteryCell_W ;  % Battery cell width [m]
    %
    batteryHV.battery_T_init   = batteryHV1.battery_T_init;
    batteryHV.battery_SOC_init = batteryHV1.battery_SOC_init;
    batteryHV.battery_extR = batteryHV1.battery_extR;       % Battery Module ascessory resistance (Ohm)
    batteryHV.batteryModuleCellR0_ini  = ones(1,batteryHV.battery_N_cells);                   % Cell-to-cell capacity variation (-)
    batteryHV.batteryModuleCellSOC_ini = batteryHV.battery_SOC_init*ones(1,batteryHV.battery_N_cells);  % Cell-to-cell initial SOC variation (-)
    batteryHV.batteryModuleCellT_ini = (batteryHV.battery_T_init+273)*ones(1,batteryHV.battery_N_cells);% Cell-to-cell initial temperature variation (K)
    batteryHV.batteryModuleExtHeat = zeros(1,batteryHV.battery_N_cells);                      % Cell-to-cell external heat flux variation (W)
    batteryHV.batteryModuleCellAhr_ini = ones(1,batteryHV.battery_N_cells);                  % Cell-to-cell resistance variation (-) for Module
    %
    batteryHV.batteryCoolant_flow=batteryHV1.batteryCoolant_flow;  %battery coolant flow
    
else
    batteryHV.batteryNp = 4;                          % Number of parallel cells in a string
    batteryHV.batteryNs = 108;                         % Number of series connected strings
    batteryHV.battery_N_cells = batteryHV.batteryNp*batteryHV.batteryNs; % Number of cells per module
    batteryHV.batteryCell_mass = 0.125; % [kg] Cell mass
    batteryHV.batteryCell_cp = 795; % [J/kg/K] Cell specific heat
    %
    batteryHV.batterySOC_LUT = [0 0.1 0.25 0.5 0.75 0.9 1]';   % State of charge table breakpoints S
    batteryHV.batteryTemp_LUT = [278 293 313];          % Temperature table breakpoints T
    batteryHV.batteryCapacity_LUT = [10 10 10]; % Battery cell capacity at different (T) points [Ahr]
    batteryHV.batteryEm_LUT = [
        3.4966    3.5057    3.5148
        3.5519    3.5660    3.5653
        3.6183    3.6337    3.6402
        3.7066    3.7127    3.7213
        3.9131    3.9259    3.9376
        4.0748    4.0777    4.0821
        4.1923    4.1928    4.1930]; % [V] Em open-circuit voltage vs SOC rows and T columns
    batteryHV.batteryR0_LUT = [
        0.0117    0.0085    0.0090
        0.0110    0.0085    0.0090
        0.0114    0.0087    0.0092
        0.0107    0.0082    0.0088
        0.0107    0.0083    0.0091
        0.0113    0.0085    0.0089
        0.0116    0.0085    0.0089]; % [Ohm] R0 resistance vs SOC rows and T columns
    batteryHV.batteryR1_LUT = [
        0.0109    0.0029    0.0013
        0.0069    0.0024    0.0012
        0.0047    0.0026    0.0013
        0.0034    0.0016    0.0010
        0.0033    0.0023    0.0014
        0.0033    0.0018    0.0011
        0.0028    0.0017    0.0011]; % [Ohm] R1 Resistance vs SOC rows and T columns
    batteryHV.batteryC1_LUT = [
        1913.6    12447    30609
        4625.7    18872    32995
        23306     40764    47535
        10736     18721    26325
        18036     33630    48274
        12251     18360    26839
        9022.9    23394    30606]; % [F] C1 Capacitance vs SOC rows and T columns
    %
    batteryHV.batteryTau1_LUT = batteryHV.batteryR1_LUT.*batteryHV.batteryC1_LUT;
    batteryHV.batteryCoolant_flow=[.01, .02, .03, .04, .05, .06];
    batteryHV.batteryCoolantHTC=zeros(3, 6, batteryHV.battery_N_cells);
    batteryHV.batteryThermal_K1 = 0.8;  % Battery cell (through-plane) thermal conductivity [W/mK]
    batteryHV.batteryThermal_K2 = 800;  % Battery cell (in-plane) thermal conductivity [W/mK]
    batteryHV.batteryCoolantFlwR=0.1; % Coolant flow rate
    batteryHV.batteryCoolantFlwT=-10; % Coolant temperature
    %
    batteryHV.batteryCell_H = 0.2;   % Battery cell height [m]
    batteryHV.batteryCell_T = 0.012; % Battery cell thic.kness [m]
    batteryHV.batteryCell_W = 0.12;  % Battery cell width [m]
    %
    batteryHV.battery_T_init   = 30;
    batteryHV.battery_SOC_init = 0.95;
    batteryHV.battery_extR = 0;       % Battery Module ascessory resistance (Ohm)
    batteryHV.batteryModuleCellR0_ini  = ones(1,batteryHV.battery_N_cells);                   % Cell-to-cell capacity variation (-)
    batteryHV.batteryModuleCellSOC_ini = batteryHV.battery_SOC_init*ones(1,batteryHV.battery_N_cells);  % Cell-to-cell initial SOC variation (-)
    batteryHV.batteryModuleCellT_ini = (batteryHV.battery_T_init+273)*ones(1,batteryHV.battery_N_cells);% Cell-to-cell initial temperature variation (K)
    batteryHV.batteryModuleExtHeat = zeros(1,batteryHV.battery_N_cells);                      % Cell-to-cell external heat flux variation (W)
    batteryHV.batteryModuleCellAhr_ini = ones(1,batteryHV.battery_N_cells);                  % Cell-to-cell resistance variation (-) for Module
    
    %Control Parameter
    batteryHV.batteryPackAhr_ini = max(batteryHV.batteryCapacity_LUT)...
        *batteryHV.batteryNp;
    
    batteryHV.minVolt = min( min(batteryHV.batteryEm_LUT));
    
    
    batteryHV.cRate  = [
        0    0    0
        1    2    2
        2    2    3
        2    3    4
        2    3    4
        3    4    5
        4    5    6]; % mac c rate for given Temp and SoC
    
end



%% Reduction Gear
bevGear.gearRatio = 7.0;
bevGear.efficiency = 0.98;

%% Motor Drive
motorDrive.simplePmsmDrv_trqMax_Nm = 360;
motorDrive.simplePmsmDrv_powMax_W = 150e+3;
motorDrive.simplePmsmDrv_timeConst_s = 0.02;

motorDrive.simplePmsmDrv_spdVec_rpm = [100, 450, 800, 1150, 1500];
motorDrive.simplePmsmDrv_trqVec_Nm = [10, 45, 80, 115, 150];
motorDrive.simplePmsmDrv_LossTbl_W = ...
    [ 16.02, 251,   872.8, 2230, 4998; ...
    29.77, 262,   875.7, 2217, 4950; ...
    45.35, 281.2, 900,   2217, 4796; ...
    62.14, 299,   924.8, 2191, 4567; ...
    81.1,  320.9, 943.1, 2146, 4379];

motorDrive.simplePmsmDrv_rotorInertia_kg_m2 = 3.93*0.01^2;
motorDrive.simplePmsmDrv_rotorDamping_Nm_per_radps = 1e-5;
motorDrive.simplePmsmDrv_initialRotorSpd_rpm = 0;

motorDrive.spdCtl_trqMax_Nm = motorDrive.simplePmsmDrv_trqMax_Nm;

motorDrive.gearRatioCompensation = 3/bevGear.gearRatio;
motorDrive.AmbTemp=293.15;
motorDrive.ThermalMass=12000;
% adjust the max motor speed

%% Driver & Environment

bevMotorSpdRef.tireRadius_cm = vehicle.tireRollingRadius_cm;
bevMotorSpdRef.reductionGearRaio = bevGear.gearRatio;

