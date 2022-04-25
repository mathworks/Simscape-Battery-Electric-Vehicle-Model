%% Model Parameters for BEV Drive Cycle Basic Model

% Copyright 2020-2022 The MathWorks, Inc.

%% Ambient

% Used when thermal model is enabled. Default setting does not use this.
ambient.temp_K = 273.15 + 20;

%% Vehicle

vehicle.mass_kg = 1600;
vehicle.tireRollingRadius_m = 0.3;

vehicle.roadLoadA_N = 100;
vehicle.roadLoadB_N_per_kph = 0;
vehicle.roadLoadC_N_per_kph2 = 0.035;
vehicle.roadLoad_gravAccel_m_per_s2 = 9.81;

smoothing.vehicle_speedThreshold_kph = 1;
smoothing.vehicle_axleSpeedThreshold_rpm = 1;

initial.vehicle_speed_kph = 0;

%% High Voltage Battery
batteryHV.nominalCapacity_kWh = 4;
batteryHV.voltagePerCell_V = 3.7;  % Open Circuit Voltage. 3.5V to 3.7V assuming Lithium-ion
batteryHV.packVoltage_V = 350;
batteryHV.batteryPackAhr_ini = ...
  batteryHV.nominalCapacity_kWh / batteryHV.packVoltage_V * 1000;
batteryHV.internal_R_Ohm = 0.01;
batteryHV.AmbTemp=293.15; % Kelvin

initial.hvBatterySOC_pct = 70;
initial.hvBatteryCharge_Ah = batteryHV.batteryPackAhr_ini * initial.hvBatterySOC_pct/100;

%% Reduction Gear
bevGear.gearRatio = 7.0;
bevGear.efficiency = 0.98;

%% Motor Drive Unit
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

% Used when thermal model is enabled. Default setting does not use this.
motorDrive.AmbTemp_K = ambient.temp_K;

%% Controller & Environment

bevControl.MotorSpdRef_tireRadius_m = vehicle.tireRollingRadius_m;
bevControl.MotorSpdRef_reductionGearRaio = bevGear.gearRatio;

bevControl.MotorSpdRef_Ki = 15;
bevControl.MotorSpdRef_Kp = 15;
