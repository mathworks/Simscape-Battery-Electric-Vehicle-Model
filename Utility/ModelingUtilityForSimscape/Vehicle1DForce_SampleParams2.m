% Parameters for Longitudinal Vehicle block and Vehicle1D Force app

% Copyright 2026 The MathWorks, Inc.

Params.Vehicle = bevutil1.app.Vehicle1DForce.Vehicle1DForceAppParameters;

Params.Vehicle.VehicleMass = simscape.Value(1600, "kg");
Params.Vehicle.TireRollingCoefficient = 0.014;
Params.Vehicle.AirDragCoefficient = 0.33;
Params.Vehicle.FrontalArea = simscape.Value(2.5, "m^2");

Params.Vehicle.GravitationalAcceleration = simscape.Value(9.81, "m/s^2");
Params.Vehicle.DryAirDensity = simscape.Value(1.184, "kg/m^3");

Params.Vehicle.RoadLoadB = simscape.Value(0, "N/(m/s)");

Params.Vehicle.TopSpeed = simscape.Value(160, "km/hr");
Params.Vehicle.MaxClimbGradePercent = 5;
Params.Vehicle.MaxAcceleration = 0.38;

Params.Vehicle.PlotSpeedUpperBound = simscape.Value(180, "km/hr");
Params.Vehicle.PlotForceUpperBound = simscape.Value(10000, "N");
Params.Vehicle.PlotGrades = [0, 5, 10, 20, 35];
Params.Vehicle.PlotPowers = simscape.Value([10, 50, 100], "kW");
