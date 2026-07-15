classdef Vehicle1DForceAppParameters
  % Properties for app parameters.
  %
  % Use this class to conveniently define struct fields that are used as app parameters.
  % See the app description for an example use.

  % Copyright 2026 The MathWorks, Inc.

  properties

    % -------------------------------------------------------------------------
    % Model parameters

    VehicleMass (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(VehicleMass, "kg"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(1200, "kg")

    TireRollingCoefficient (1,1) double { bevutil1.CodeUtil.mustBePositiveOrNan } = 0.0136

    AirDragCoefficient (1,1) double { bevutil1.CodeUtil.mustBePositiveOrNan } = 0.31

    FrontalArea (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(FrontalArea, "m^2"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(2.3, "m^2")

    GravitationalAcceleration (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(GravitationalAcceleration, "m/s^2"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(9.81, "m/s^2")

    DryAirDensity (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(DryAirDensity, "kg/m^3"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(1.184, "kg/m^3")

    RoadLoadB (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(RoadLoadB, "N/(m/s)"), bevutil1.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(0, "N/(m/s)")

    TopSpeed (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(TopSpeed, "m/s"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(160, "km/hr")

    MaxClimbGradePercent (1,1) double { mustBeNonnegative } = 5

    MaxAcceleration (1,1) double { bevutil1.CodeUtil.mustBePositiveOrNan } = 0.4

    % -------------------------------------------------------------------------
    % Plot customization

    PlotSpeedUpperBound (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(PlotSpeedUpperBound, "m/s"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(180, "km/hr")

    PlotForceUpperBound (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(PlotForceUpperBound, "N"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(11000, "N")

    PlotGrades (1,:) double { bevutil1.CodeUtil.mustBeNonnegativeOrNan } = [0, 5, 10, 20, 35]

    PlotPowers (1,:) simscape.Value ...
      { simscape.mustBeCommensurateUnit(PlotPowers, "kW"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value([10, 50, 100, 150], "kW")

  end  % properties
end  % classdef
