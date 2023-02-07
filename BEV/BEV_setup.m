%% Model Parameters for Battery Electric Vehicle System Model

% Copyright 2020-2023 The MathWorks, Inc.

%% Connection Bus definitions

defineBus_HighVoltage
defineBus_Rotational

%% Ambient

% Used when thermal model is enabled. Default setting does not use this.
ambient.temp_K = 273.15 + 20;

%% Vehicle

vehicle.mass_kg = 2400;
vehicle.tireRollingRadius_m = 0.35;

vehicle.roadLoadA_N = 330;
vehicle.roadLoadB_N_per_kph = 0;
vehicle.roadLoadC_N_per_kph2 = 0.0511;
% C=0.0511  ->  20.67 kWh/100km

vehicle.roadLoad_gravAccel_m_per_s2 = 9.81;

smoothing.vehicle_speedThreshold_kph = 1;
smoothing.vehicle_axleSpeedThreshold_rpm = 1;

initial.vehicle_speed_kph = 0;

%% High Voltage Battery
% For simplicity, load parameters for three high-voltage battery components at once.

BatteryHV_harness_setup

%{
%---
% Basic Battery (isothermal)

batteryHV.nominalVoltage_V = 340;
batteryHV.internalResistance_Ohm = 0.01;
batteryHV.nominalCapacity_kWh = 60;
% batteryHV.voltagePerCell_V = 3.7;  % Open Circuit Voltage. 3.5V to 3.7V assuming Lithium-ion
batteryHV.nominalCharge_Ahr = ...
  batteryHV.nominalCapacity_kWh / batteryHV.nominalVoltage_V * 1000;

% Initial conditions
initial.hvBattery_SOC_pct = 70;
initial.hvBattery_Charge_Ahr = batteryHV.nominalCharge_Ahr * initial.hvBattery_SOC_pct/100;

%---
% For Thermal HV Battery 1 (Battery block from Driveline)

batteryHV.measuredCharge_Ahr = batteryHV.nominalCharge_Ahr * 0.5;
batteryHV.measuredVoltage_V = batteryHV.nominalVoltage_V * 0.9;
batteryHV.RadiationArea_m2 = 1;
batteryHV.RadiationCoeff_W_per_K4m2 = 3e-9;
batteryHV.thermalMass_kJ_per_K = 0.1;

initial.hvBattery_Temperature_K = ambient.temp_K;

ambient.mass_t = 10000;
ambient.SpecificHeat_J_per_Kkg = 1000;

initial.ambientTemp_K = ambient.temp_K;

%---
% For Thermal HV Battery 2 (Battery block from Electrical)

batteryHV.measurementTemperature_K = 273.15 + 25;
batteryHV.secondMeasurementTemperature_K = 273.15 + 0;
batteryHV.secondNominalVoltage_V = batteryHV.nominalVoltage_V * 0.95;
batteryHV.secondInternalResistance_Ohm = batteryHV.internalResistance_Ohm * 2;
batteryHV.secondMeasuredVoltage_V = batteryHV.nominalVoltage_V * 0.9;
%}

%% Reducer

reducer.GearRatio = 9.1;

reducer.Efficiency_normalized = 0.98;

smoothing.Reducer_PowerThreshold_W = 1;

%% Motor Drive Unit

MotorDriveUnit_harness_setup

%{
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
%}

%% Controller & Environment

motorDrive.simplePmsmDrv_trqMax_Nm = motorDriveUnit.trqMax_Nm;


bevControl.MotorSpdRef_tireRadius_m = vehicle.tireRollingRadius_m;
bevControl.MotorSpdRef_reductionGearRaio = reducer.GearRatio;

bevControl.MotorSpdRef_Ki = 15;
bevControl.MotorSpdRef_Kp = 15;
