%% Model Parameters for BEV Drive Cycle Basic Model

% Copyright 2020 The MathWorks, Inc.

%% Vehicle
%Vehicle1DBasicParams
%-{
vehicle.vehMass_kg = 1600;
vehicle.tireRollingRadius_cm = 30;
vehicle.roadLoadA_N = 100;
vehicle.roadLoadB_N_per_kph = 0;
vehicle.roadLoadC_N_per_kph2 = 0.035;
%}

%% High Voltage Battery
%BatteryHVBasicParams
%-{
battery.voltage_V = 350;
battery.internal_R_Ohm = 0.002;
%}

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
  % adjust the max motor speed

%% Driver & Environment

bevMotorSpdRef.tireRadius_cm = vehicle.tireRollingRadius_cm;
bevMotorSpdRef.reductionGearRaio = bevGear.gearRatio;
