classdef Vehicle1DModelParameters < handle
  % Parameters of the vehicle-1d model.

  % This class defines parameters for Vehicle1D Performance App.
  % Many parameters of this class are also used in Longitudinal Vehicle block.
  %
  % This class assumes that Parameterization Type of Longitudinal Vehicle block
  % is Regular and treats the road-load coefficients A and C as derived parameters
  % while it treats the road-load coefficient B as zero.

  % This class does not automatically update A and C when
  % parameters on which A or C depends are modified.
  % To keep A or C up to date, you must manually call
  % UpdateRoadLoadA or UpdateRoadLoadC in your code, respectively.
  %
  % Road grade is in percent. In Simscape, the unit for percent is 1.

  % Copyright 2024-2026 The MathWorks, Inc.

  properties

    % =========================================================================
    % Parameters corresponding to the Longitudinal Vehicle block.

    VehicleMass (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(VehicleMass, "kg"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "kg")

    TireRollingCoefficient (1,1) double { CodeUtil1.mustBePositiveOrNan } = nan

    AirDragCoefficient (1,1) double { CodeUtil1.mustBePositiveOrNan } = nan

    FrontalArea (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(FrontalArea, "m^2"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "m^2")

    GravitationalAcceleration (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(GravitationalAcceleration, "m/s^2"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "m/s^2")

    % Air density is a private parameter in the Longitudinal Vehicle block.
    AirDensity (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(AirDensity, "kg/m^3"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "kg/m^3")

    % If the Parameterization type is Regular parameter set,
    % the road-load parameter B is set to 0 and not editable nor derived.
    RoadLoadB (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(RoadLoadB, "N/(m/s)"), CodeUtil1.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(nan, "N/(m/s)")

    % =========================================================================
    % Additional parameters for vehicle performance.
    % They are not in the Longitudinal Vehicle block.

    TopSpeed (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(TopSpeed, "m/s"),  CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "km/hr")

    % Max acceleration (or, max G-force,) a_max, is a unitless front factor of
    % mass times gravitational acceleration: a_max * M * g
    MaxAcceleration (1,1) double { CodeUtil1.mustBePositiveOrNan } = nan

    MaxClimbGradePercent (1,1) double { mustBeNonnegative } = 0

    % =========================================================================
    % Derived parameters

    RoadLoadA (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(RoadLoadA, "N"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "N")

    RoadLoadC (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(RoadLoadC, "N/(m/s)^2"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "N/(m/s)^2")

    % (maximum force) == (max acceleration) * (vehicle mass) * (gravitational acceleration)
    MaxForce (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(MaxForce, "N"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "N")

    MaxClimbPower (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(MaxClimbPower, "kW"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "kW")

  end  % properties

  methods

    function ModelParams = Vehicle1DModelParameters(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.Initialization (1,1) logical = false
      end  % arguments

      if not(NameValuePair.Initialization)

        return

      end  % if

      ModelParams.VehicleMass = simscape.Value(1800, "kg");
      ModelParams.TireRollingCoefficient = 0.0136;
      ModelParams.AirDragCoefficient = 0.31;
      ModelParams.FrontalArea = simscape.Value(2.36, "m^2");

      ModelParams.GravitationalAcceleration = simscape.Value(9.81, "m/s^2");

      ModelParams.AirDensity = simscape.Value(1.184, "kg/m^3");

      ModelParams.RoadLoadB = simscape.Value(0, "N/(m/s)");

      ModelParams.TopSpeed = simscape.Value(160, "km/hr");

      ModelParams.MaxAcceleration = 0.4;

      ModelParams.MaxClimbGradePercent = 5;

      updateDerivedParameters(ModelParams)

    end  % function

    function updateDerivedParameters(ModelParams)
      %%
      C_roll = ModelParams.TireRollingCoefficient;
      M_veh = ModelParams.VehicleMass;
      g = ModelParams.GravitationalAcceleration;
      ModelParams.RoadLoadA = convert(C_roll * M_veh * g, "N");

      C_drag = ModelParams.AirDragCoefficient;
      A_front = ModelParams.FrontalArea;
      d_air = ModelParams.AirDensity;
      ModelParams.RoadLoadC = convert((1/2) * C_drag * A_front * d_air, "N/(m/s)^2");

      a_max = ModelParams.MaxAcceleration;
      max_force = a_max * M_veh * g;
      ModelParams.MaxForce = convert(max_force, "N");

      A_rl = ModelParams.RoadLoadA;
      B_rl = ModelParams.RoadLoadB;
      C_rl = ModelParams.RoadLoadC;
      v_max = ModelParams.TopSpeed;
      road_grade_max_pct = ModelParams.MaxClimbGradePercent;
      road_angle_max = simscape.Value(atan(road_grade_max_pct/100), "rad");
      F_max = (A_rl + B_rl*v_max)*cos(road_angle_max) + C_rl*v_max^2 + M_veh*g*sin(road_angle_max);
      P_max = F_max * v_max;
      ModelParams.MaxClimbPower = convert(P_max, "kW");

    end  % function

  end  % methods
end  % classdef
