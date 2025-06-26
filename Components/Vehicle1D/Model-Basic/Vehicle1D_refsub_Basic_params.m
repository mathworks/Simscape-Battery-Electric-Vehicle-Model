%% Parameters for Vehicle1D Component

% Copyright 2020-2022 The MathWorks, Inc.

%% Bus definitions

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

%% Initial conditions

initial.vehicle_speed_kph = 0;
