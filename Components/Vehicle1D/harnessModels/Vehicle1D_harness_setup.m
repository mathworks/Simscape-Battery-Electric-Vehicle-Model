%% Setup Script for Simple 1D Vehicle
% This script is run automatically when harness model opens.
% If you edit this file, make sure to run this to update variables
% before running harness model for simulation.

% Copyright 2020-2022 The MathWorks, Inc.

%% Input signals

vehSigBuilder = Vehicle1D_InputSignalBuilder;

% ### Select input signal pattern
%vehicleInputData = Constant(vehSigBuilder);
vehicleInputData = DriveAxle(vehSigBuilder);

vehicle_InputSignals = vehicleInputData.Signals;
vehicle_InputBus = vehicleInputData.Bus;

t_end = vehicleInputData.Options.StopTime_s;

%% Block parameters

vehicle.mass_kg = 1790;
vehicle.tireRollingRadius_m = 0.3;
vehicle.roadLoadA_N = 175;
vehicle.roadLoadB_N_per_kph = 0;
vehicle.roadLoadC_N_per_kph2 = 0.032;
vehicle.roadLoad_gravAccel_m_per_s2 = 9.81;

gearTrain.friction_Nm_per_rpm = 0.01;

gearTrain.inertia_kg_m2 = 161.1;  % 1790*0.3^2==161.1
% r = 0.3 m --> r^2 = 0.09 m^2
% M = 1200 kg --> M*r^2 = 108 kg*m^2
% M = 1600 kg --> M*r^2 = 144 kg*m^2
% M = 2000 kg --> M*r^2 = 180 kg*m^2

smoothing.vehicle_speedThreshold_kph = 1;
smoothing.vehicle_axleSpeedThreshold_rpm = 1;

%% Initial conditions

initial.vehicle_speed_kph = 0;
