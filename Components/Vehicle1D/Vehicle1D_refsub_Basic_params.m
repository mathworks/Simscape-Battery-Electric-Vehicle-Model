%% Parameters for Vehicle1D Component

% Copyright 2020-2022 The MathWorks, Inc.

%% Bus definitions

defineBus_Rotational

%% Vehicle block parameters

vehicle.mass_kg = 2400;
vehicle.tireRollingRadius_m = 0.3;
vehicle.roadLoadA_N = 350;
vehicle.roadLoadB_N_per_kph = 0;
vehicle.roadLoadC_N_per_kph2 = 0.66;
vehicle.roadLoad_gravAccel_m_per_s2 = 9.81;

smoothing.vehicle_speedThreshold_kph = 1;
smoothing.vehicle_axleSpeedThreshold_rpm = 1;

%% Initial conditions

initial.vehicle_speed_kph = 0;
