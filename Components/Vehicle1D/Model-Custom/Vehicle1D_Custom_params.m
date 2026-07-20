%% Parameters for Vehicle1D Component

% Copyright 2026 The MathWorks, Inc.

%% Bus definitions

defineBus_Rotational

%% Vehicle block parameters

VehicleParams = bevutil1.app.Vehicle1DForce.Vehicle1DForceModelParameters(Initialization=true);

VehicleParams.VehicleMass = simscape.Value(1800, "kg");
VehicleParams.TireRollingCoefficient = 0.0136;
VehicleParams.AirDragCoefficient = 0.31;
VehicleParams.FrontalArea = simscape.Value(2.36, "m^2");

VehicleParams.GravitationalAcceleration = simscape.Value(9.81, "m/s^2");
VehicleParams.DryAirDensity = simscape.Value(1.184, "kg/m^3");

VehicleParams.RoadLoadB = simscape.Value(0, "N/(m/s)");

VehicleParams.TopSpeed = simscape.Value(160, "km/hr");
VehicleParams.MaxAcceleration = 0.4;
VehicleParams.MaxClimbGradePercent = 5;

VehicleParams = updateDerivedParameters(VehicleParams);

% -----------------------------------------------------------------------------
vehicle.mass_kg = VehicleParams.VehicleMass.value("kg");

vehicle.tireRollingRadius_m = 0.34;

vehicle.roadLoadA_N = VehicleParams.RoadLoadA.value("N");
vehicle.roadLoadB_N_per_kph = VehicleParams.RoadLoadB.value("N/kph");
vehicle.roadLoadC_N_per_kph2 = VehicleParams.RoadLoadC.value("N/kph^2");

vehicle.tireRollingCoeff = VehicleParams.TireRollingCoefficient;
vehicle.airDragCoeff = VehicleParams.AirDragCoefficient;
vehicle.frontalArea_m2 = VehicleParams.FrontalArea.value("m^2");
vehicle.gravAccel_m_per_s2 = VehicleParams.GravitationalAcceleration.value("m/s^2");

smoothing.vehicle_speedThreshold_kph = 1;
smoothing.vehicle_axleSpeedThreshold_rpm = 1;

%% Initial conditions

initial.vehicle_speed_kph = 0;
