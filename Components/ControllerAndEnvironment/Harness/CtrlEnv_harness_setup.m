%% Setup script for Controller and Environment component
% This script is run automatically when harness model opens.
% If you edit this file, make sure to run this to update variables
% before running harness model for simulation.

% Copyright 2023 The MathWorks, Inc.

%% Controller & Environment

% Parameters for converting vehicle speed to motor speed
bevControl.MotorSpdRef_tireRollingRadius_m = 0.34;
bevControl.MotorSpdRef_reductionGearRaio = 9.1;

% PI controller gains
bevControl.MotorSpdRef_Ki = 15;
bevControl.MotorSpdRef_Kp = 15;

% Bounds for torque commands
bevControl.MotorDriveUnit_trqMax_Nm = 420;

%% Simple vehicle
% Outside of the model under Test

% Model Parameters

bevPlant.AmbientTemperature_K = 273.15;

bevPlant.VehicleWeight_kg = 2400;

bevPlant.TireRollingRadius_m = bevControl.MotorSpdRef_tireRollingRadius_m;
bevPlant.ReductionGearRaio = bevControl.MotorSpdRef_reductionGearRaio;

bevPlant.MotorThermalMass_kg = 10;
bevPlant.MotorSpecificHeat_J_per_K_per_kg = 890;

bevPlant.BatteryThermalMass_kg = 400;
bevPlant.BatterySpecificHeat_J_per_K_per_kg = 1000;

% Derived model parameters

bevPlant.VehicleInertia_kg_m2 = bevPlant.VehicleWeight_kg * bevPlant.TireRollingRadius_m^2;

% Initial conditions

initial.VehicleSpeed_kph = 0;

initial.MotorTemperature_K = bevPlant.AmbientTemperature_K;
initial.MotorAmbientTemperature_K = bevPlant.AmbientTemperature_K;

initial.BatteryTemperature_K = bevPlant.AmbientTemperature_K;
initial.BatteryAmbientTemperature_K = bevPlant.AmbientTemperature_K;

% Derived initial conditions

initial.vehicleInertiaSpd_rpm = ...
  CtrlEnv_Vehicle_getMotorSpeedFromVehicleSpeed( ...
    VehicleSpeed_kph = initial.VehicleSpeed_kph, ...
    TireRollingRadius_m = bevPlant.TireRollingRadius_m, ...
    GearRatio = bevPlant.ReductionGearRaio );
