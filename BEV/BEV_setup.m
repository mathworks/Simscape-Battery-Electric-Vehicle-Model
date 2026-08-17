%% Model Parameters for the Battery Electric Vehicle (BEV) system model.
%
% This script defines parameters for the BEV model.
% Use this script to load default values.
% Override any of them elsewhere later as needed.
% 
% The BEV_system_model automatically runs this script in the PostLoadFcn callback.

% Copyright 2020-2026 The MathWorks, Inc.

%% Bus definitions

defineBus_HighVoltage
defineBus_Rotational

%% Common parameters

CommonParameter.Temperature = simscape.Value(273.15 + 20, "K");

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

batteryHV.ambientTemp_K = CommonParameter.Temperature.value("K");

batteryHV.ambientMass_t = 10000;
batteryHV.ambientSpecificHeat_J_per_Kkg = 1000;

batteryHV.RadiationArea_m2 = 1;
batteryHV.RadiationCoeff_W_per_K4m2 = 5e-10;

%% Motor drive unit parameters

MotorDriveUnit.MaxTorque = simscape.Value(420, "N*m");
MotorDriveUnit.MaxPower = simscape.Value(220, "kW");
MotorDriveUnit.ResponseTime = simscape.Value(20, "ms");

MotorDriveUnit.ElectricalEfficiencyPercent = 95;
MotorDriveUnit.MeasuredAngularSpeed = simscape.Value(2000, "rpm");
MotorDriveUnit.MeasuredTorque = simscape.Value(50, "N*m");
MotorDriveUnit.MeasuredIronLosses = simscape.Value(55, "W");
MotorDriveUnit.FixedLosses = simscape.Value(40, "W");

MotorDriveUnit.RotorInertia = simscape.Value(5*0.01^2, "kg*m^2");
MotorDriveUnit.RotorDamping = simscape.Value(1e-5, "N*m/(rad/s)");

% Used in the Status subsystem of the Basic model to output a constant temperature value.
% Not used in the BasicThermal model.
MotorDriveUnit.AmbientTemperature = CommonParameter.Temperature;

% Used in the BasicThermal model.
% Not used in the Basic model.
MotorDriveUnit.ThermalMass = simscape.Value(90, "kJ/K");
MotorDriveUnit.RadiationArea = simscape.Value(1, "m^2");
MotorDriveUnit.RadiationCoefficient = simscape.Value(5e-10, "W/K^4/m^2");
MotorDriveUnit.AmbientMass = simscape.Value(10000, "t");
MotorDriveUnit.AmbientSpecificHeat = simscape.Value(1000, "J/K/kg");

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
bevControl.MotorDriveUnit_trqMax_Nm = MotorDriveUnit.MaxTorque.value("N*m");

%% Inputs to the model

% Load the "Simple" drive pattern for the Lookup-Table-based subsystem.
loadLUTData_VehSpdRef_Simple

%% Initial conditions

initial.vehicle_speed_kph = 0;
initial.hvBattery_SOC_pct = 70;

initial.MotorDriveUnit_RotorAngularSpeed = simscape.Value(0, "rpm");

initial.MotorDriveUnit_Temperature = CommonParameter.Temperature;

initial.hvBattery_Charge_Ahr = ...
  BatteryHV_getAmpereHourRating( ...
    Voltage_V = batteryHV.nominalVoltage_V, ...
    Capacity_kWh = batteryHV.nominalCapacity_kWh, ...
    StateOfCharge_pct = initial.hvBattery_SOC_pct );

initial.hvBattery_Temperature_K = CommonParameter.Temperature.value("K");

initial.ambientTemp_K = CommonParameter.Temperature.value("K");
