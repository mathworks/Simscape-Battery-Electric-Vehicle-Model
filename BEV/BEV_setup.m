%% Model Parameters for Battery Electric Vehicle System Model
% This is automatically run in the PostLoadFcn callback of BEV_system_model
% and sets referenced subsystems.
% Note that the callback is not PreLoadFcn but PostLoadFcn
% because the model needs to be loaded before setting referenced subsystems.
%
% Informational messages from disp are turned off to prevent
% the warnings/diagnostics from appearing when the model is opened.

% Copyright 2020-2023 The MathWorks, Inc.

%% Bus definitions

defineBus_HighVoltage
defineBus_Rotational

%% Vehicle block parameters

vehicle.mass_kg = 2400;
vehicle.tireRollingRadius_m = 0.34;

vehicle.tireRollingCoeff = 0.0136;
vehicle.airDragCoeff = 0.31;
vehicle.frontalArea_m2 = 0.9 * 1.921 * 1.624;
vehicle.gravAccel_m_per_s2 = 9.81;

smoothing.vehicle_speedThreshold_kph = 1;
smoothing.vehicle_axleSpeedThreshold_rpm = 1;

%% Battery parameters

batteryHV.nominalVoltage_V = 340;

batteryHV.nominalCapacity_kWh = 60;

batteryHV.nominalCharge_Ahr = ...
  BatteryHV_getAmpereHourRating( ...
    Voltage_V = batteryHV.nominalVoltage_V, ...
    Capacity_kWh = batteryHV.nominalCapacity_kWh, ...
    StateOfCharge_pct = 100 );

batteryHV.internalResistance_Ohm = 0.01;

batteryHV.ThermalMass_J_per_K = 10e3;

% Voltage is 90 % of the nominal when SOC is 50 %.
batteryHV.measuredVoltage_V = batteryHV.nominalVoltage_V * 0.9;
batteryHV.measuredCharge_Ahr = batteryHV.nominalCharge_Ahr * 0.5;

% More thermal model parameters
% These parameters are used when thermal model is enabled
% in the Battery block from Simscape Electrical.
batteryHV.measurementTemperature_K = 273.15 + 25;
batteryHV.secondMeasurementTemperature_K = 273.15 + 0;
batteryHV.secondNominalVoltage_V = batteryHV.nominalVoltage_V * 0.95;
batteryHV.secondInternalResistance_Ohm = batteryHV.internalResistance_Ohm * 2;
batteryHV.secondMeasuredVoltage_V = batteryHV.nominalVoltage_V * 0.9;

% Ambient parameters for battery thermal simulation

batteryHV.ambientTemp_K = 273.15 + 20;

batteryHV.ambientMass_t = 10000;
batteryHV.ambientSpecificHeat_J_per_Kkg = 1000;

batteryHV.RadiationArea_m2 = 1;
batteryHV.RadiationCoeff_W_per_K4m2 = 5e-10;

%% Motor drive unit parameters

motorDriveUnit.trqMax_Nm = 420;
motorDriveUnit.powerMax_kW = 220;
motorDriveUnit.responseTime_s = 0.02;

motorDriveUnit.rotorInertia_kg_m2 = 5*0.01^2;
motorDriveUnit.rotorDamping_Nm_per_radps = 1e-5;

% Single efficiency measurement
motorDriveUnit.efficiency_pct = 95;
motorDriveUnit.spd_eff_rpm = 2000;
motorDriveUnit.trq_eff_Nm = 50;
motorDriveUnit.ironLoss_W = 55;
motorDriveUnit.fixedLoss_W = 40;

motorDriveUnit.rotorInertia_kg_m2 = 5*0.01^2;
motorDriveUnit.rotorDamping_Nm_per_radps = 1e-5;

motorDriveUnit.ThermalMass_J_per_K = 90e3;

% Ambient parameters for the thermal simulation of  motor drive unit.

motorDriveUnit.ambientTemp_K = 273.15 + 20;

motorDriveUnit.ambientMass_t = 10000;
motorDriveUnit.ambientSpecificHeat_J_per_Kkg = 1000;

motorDriveUnit.RadiationArea_m2 = 1;
motorDriveUnit.RadiationCoeff_W_per_K4m2 = 5e-10;

%% Reducer parameters

reducer.GearRatio = 9.1;

reducer.Efficiency_normalized = 0.98;

smoothing.Reducer_PowerThreshold_W = 1;

%% BEV controller parameters

% Parameters for converting vehicle speed to motor speed
bevControl.MotorSpdRef_tireRollingRadius_m = vehicle.tireRollingRadius_m;
bevControl.MotorSpdRef_reductionGearRaio = 9.1;

% PI controller gains for motor torque control
bevControl.MotorSpdRef_Ki = 15;
bevControl.MotorSpdRef_Kp = 15;

% Bounds for torque command
bevControl.MotorDriveUnit_trqMax_Nm = motorDriveUnit.trqMax_Nm;

%% Initial conditions

initial.vehicle_speed_kph = 0;
initial.motorDriveUnit_RotorSpd_rpm = 0;
initial.hvBattery_SOC_pct = 70;

initial.hvBattery_Charge_Ahr = ...
  BatteryHV_getAmpereHourRating( ...
    Voltage_V = batteryHV.nominalVoltage_V, ...
    Capacity_kWh = batteryHV.nominalCapacity_kWh, ...
    StateOfCharge_pct = initial.hvBattery_SOC_pct );

initial.hvBattery_Temperature_K = batteryHV.ambientTemp_K;

initial.ambientTemp_K = batteryHV.ambientTemp_K;

initial.motorDriveUnit_Temperature_K = motorDriveUnit.ambientTemp_K;
initial.ambientTemp_K = motorDriveUnit.ambientTemp_K;
