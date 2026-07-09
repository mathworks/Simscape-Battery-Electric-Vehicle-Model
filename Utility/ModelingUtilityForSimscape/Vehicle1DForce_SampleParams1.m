% Parameters for the Longitudinal Vehicle block and the Vehicle1D Force app.

% Copyright 2026 The MathWorks, Inc.

% This script creates a variable of Vehicle1DForceAppParameters, which
% provides predefined fields for the app parameters and tab-completion for edit.
% The app can also read these fields with the "Get" button all at once.
VehicleParams1 = bev1mus.app.Vehicle1DForce.Vehicle1DForceAppParameters;

VehicleParams1.VehicleMass = simscape.Value(5000, "lbm");
VehicleParams1.TireRollingCoefficient = 0.014;
VehicleParams1.AirDragCoefficient = 0.33;
VehicleParams1.FrontalArea = simscape.Value(2.5, "m^2");

VehicleParams1.GravitationalAcceleration = simscape.Value(9.81, "m/s^2");
VehicleParams1.DryAirDensity = simscape.Value(1.184, "kg/m^3");

VehicleParams1.RoadLoadB = simscape.Value(0, "N/(m/s)");

VehicleParams1.TopSpeed = simscape.Value(160, "km/hr");
VehicleParams1.MaxClimbGradePercent = 5;
VehicleParams1.MaxAcceleration = 0.38;

VehicleParams1.PlotSpeedUpperBound = simscape.Value(180, "km/hr");
VehicleParams1.PlotForceUpperBound = simscape.Value(10000, "N");
VehicleParams1.PlotGrades = [0, 5, 10, 20, 35];
VehicleParams1.PlotPowers = simscape.Value([10, 50, 100], "kW");
