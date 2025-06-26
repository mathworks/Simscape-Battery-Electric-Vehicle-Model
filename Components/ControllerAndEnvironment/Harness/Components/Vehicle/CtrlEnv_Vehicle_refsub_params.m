%% Parameters for Simple vehicle component

% Copyright 2020-2022 The MathWorks, Inc.

%% Model Parameters

bevPlant.AmbientTemperature_K = 273.15;

bevPlant.TireRollingRadius_m = 0.35;
bevPlant.ReductionGearRaio = 9.1;
bevPlant.VehicleWeight_kg = 2400;

bevPlant.MotorThermalMass_kg = 10;
bevPlant.MotorSpecificHeat_J_per_K_per_kg = 890;

bevPlant.BatteryThermalMass_kg = 400;
bevPlant.BatterySpecificHeat_J_per_K_per_kg = 1000;

%% Derived model parameters

bevPlant.VehicleInertia_kg_m2 = bevPlant.VehicleWeight_kg * bevPlant.TireRollingRadius_m^2;

%% Initial conditions

initial.VehicleSpeed_kph = 0;

initial.MotorTemperature_K = bevPlant.AmbientTemperature_K;
initial.MotorAmbientTemperature_K = bevPlant.AmbientTemperature_K;

initial.BatteryTemperature_K = bevPlant.AmbientTemperature_K;
initial.BatteryAmbientTemperature_K = bevPlant.AmbientTemperature_K;

%% Derived initial conditions

initial.vehicleInertiaSpd_rpm = ...
  CtrlEnv_Vehicle_getMotorSpeedFromVehicleSpeed( ...
    VehicleSpeed_kph = initial.VehicleSpeed_kph, ...
    TireRollingRadius_m = bevPlant.TireRollingRadius_m, ...
    GearRatio = bevPlant.ReductionGearRaio );
