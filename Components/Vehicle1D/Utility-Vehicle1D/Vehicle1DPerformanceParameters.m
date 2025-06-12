classdef Vehicle1DPerformanceParameters
  % This class defines parameters for Vehicle1D Performance Design App.
  % Many parameters of this class are also used in Longitudinal Vehicle block.
  %
  % This is a value class, not a handle class.
  %
  % This class assumes that Parameterization Type of Longitudinal Vehicle block
  % is Regular, and treats road-load coefficients A and C as derived parameters.

  % However, this class does not automatically update A and C when
  % parameters on which A or C depends are modified.
  % To keep A or C up to date, you must manually call
  % UpdateRoadLoadA or UpdateRoadLoadC in your code, respectively.
  %
  % Road grade is in percent. In Simscape, the unit for percent is 1.

  % Copyright 2024-2025 The MathWorks, Inc.

  properties (Access=private)
    errorID (1,1) string = "Vehicle1DPerformanceParameters:"
  end  % properties

  properties

    VehicleParameterizationType (1,1) sdl.enum.VehicleParameterizationType ...
      = sdl.enum.VehicleParameterizationType.Regular

    % -------------------------------------------------------------------------
    % Vehicle

    VehicleMass (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(VehicleMass, "kg"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(1800, "kg")

    TireRollingRadius (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(TireRollingRadius, "m"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(0.3, "m")  % not used

    TireRollingCoefficient (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(TireRollingCoefficient, "1"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(0.0136, "1")

    AirDragCoefficient (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(AirDragCoefficient, "1"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(0.31, "1")

    FrontalArea (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(FrontalArea, "m^2"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(2.36, "m^2")

    % -------------------------------------------------------------------------
    % Environment

    GravitationalAcceleration (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(GravitationalAcceleration, "m/s^2"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(9.81, "m/s^2")

    AirDensity (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(AirDensity, "kg/m^3"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(1.184, "kg/m^3")

    % -------------------------------------------------------------------------
    % Road-load

    RoadLoadA (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(RoadLoadA, "N"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(240.15, "N")

    RoadLoadB (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(RoadLoadB, "N/(m/s)"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValueNonnegative } ...
      = simscape.Value(0, "N/(m/s)")

    RoadLoadC (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(RoadLoadC, "N/(m/s)^2"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(0.4331, "N/(m/s)^2")

    % -------------------------------------------------------------------------
    % Performance

    TopSpeed (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(TopSpeed, "m/s"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(160, "km/hr")

    % G-force, a_max, which is a unitless front factor of mass times gravitational acceleration.
    % a_max * M * g;
    MaximumAcceleration (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(MaximumAcceleration, "1"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(0.4, "1")

    MaximumForce (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(MaximumForce, "N"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(10000, "N")

    % percent
    MaximumClimbGrade (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(MaximumClimbGrade, "1"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValueNonnegative } ...
      = simscape.Value(5, "1")

    MaximumClimbPower (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(MaximumClimbPower, "kW"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(1, "kW")

    % -------------------------------------------------------------------------
    % Preset

    Preset (1,1) string {mustBeMember(Preset, ["", "Small car", "Medium car", "Large SUV"])}

    % -------------------------------------------------------------------------
    % Plot customization

    % Road grades to plot force curves
    PlotGrades (1,:) simscape.Value { ...
      simscape.mustBeCommensurateUnit(PlotGrades, "1"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValueNonnegative } ...
      = simscape.Value([0, 5, 30], "1")

    PlotAngles (1,:) simscape.Value { ...
      simscape.mustBeCommensurateUnit(PlotAngles, "1"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValueNonnegative } ...
      = simscape.Value([0, 2.9, 16.7], "deg")

    % Power values to plot constant power contours
    PlotPowers (1,:) simscape.Value { ...
      simscape.mustBeCommensurateUnit(PlotPowers, "kW"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value([10, 50, 100, 150], "kW")

    PlotForceUpperBound (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(PlotForceUpperBound, "N"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(11000, "N")

    PlotSpeedUpperBound (1,1) simscape.Value { ...
      simscape.mustBeCommensurateUnit(PlotSpeedUpperBound, "m/s"), ...
      LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive } ...
      = simscape.Value(180, "km/hr")

    PlotForceUnit (1,1) simscape.Unit { ...
      simscape.mustBeCommensurateUnit(PlotForceUnit, "N") } = "N"

    PlotSpeedUnit (1,1) simscape.Unit { ...
      simscape.mustBeCommensurateUnit(PlotSpeedUnit, "m/s") } = "km/hr"

    % Data for plot

    NumSpeedPoints (1,1) {mustBePositive, mustBeInteger} = 100
    x_max (1,1) double = 180

    % Shade for the maximum power curve
    vel_climb
    F_climb

  end  % properties

  %%
  methods

    function Param = update_states(Param)
      %%

      M_veh = Param.VehicleMass;
      C_roll = Param.TireRollingCoefficient;
      C_drag = Param.AirDragCoefficient;
      A_front = Param.FrontalArea;

      g = Param.GravitationalAcceleration;
      d_air = Param.AirDensity;

      A_rl = convert(C_roll * M_veh * g, "N");
      Param.RoadLoadA = A_rl;

      B_rl = Param.RoadLoadB;

      C_rl = convert((1/2) * C_drag * A_front * d_air, "N/(m/s)^2");
      Param.RoadLoadC = C_rl;

      v_top = Param.TopSpeed;
      a_max = Param.MaximumAcceleration;

      % Maximum driving force
      F_max = a_max * M_veh * g;
      val_F = ceil(value(F_max, "N"));
      Param.MaximumForce = simscape.Value(val_F, "N");

      grade_max = Param.MaximumClimbGrade;
      angle_max = simscape.Value(atan(grade_max/100), "rad");

      % Vehicle force at top speed
      Force_top = (A_rl + B_rl*v_top)*cos(angle_max) + C_rl*v_top^2 + M_veh*g*sin(angle_max);

      Power_top = Force_top * v_top;
      val_P = ceil(value(Power_top, "kW"));
      Param.MaximumClimbPower = simscape.Value(val_P, "kW");

      grades_percent = Param.PlotGrades;
      angles = simscape.Value(atan(grades_percent/100), "rad");
      Param.PlotAngles = convert(angles, "deg");

      % -----------------------------------------------------------------------

      numX = numel(Param.NumSpeedPoints);
      num_grades = numel(Param.PlotGrades);
      num_powers = numel(Param.PlotPowers);

      % X axis data points
      vehicle_speed_data = linspace(simscape.Value(1, Param.PlotSpeedUnit), Param.PlotSpeedUpperBound, numX)';

      F_roll = A_rl + B_rl*vehicle_speed_data;
      F_airdrag = C_rl*vehicle_speed_data.^2;

      grade_str = strings(1, num_grades);
      angle_str = strings(1, num_grades);

      % Longitudinal vehicle force at constant grade
      F_const_grade = simscape.Value(zeros(numX, num_grades), "N");
      for idx = 1 : num_grades
        grade_str(idx) = string(value(grades_percent(idx), "1")) + " %";
        angle_str(idx) = round(value(angles(idx), "deg"), 1) + " deg";
        s = angles(idx);
        F_const_grade(:, idx) = (F_roll*cos(s) + F_airdrag) + M_veh*g*sin(s);
      end  % for

      % Longitudinal vehicle force at constant power
      F_const_power = simscape.Value(zeros(numX, num_powers), "N");
      for idx = 1 : num_powers
        F_const_power(:, idx) = Param.PlotPowers(idx) ./ vehicle_speed_data;
      end  % for

      % Shade for the maximum power
      vel_climb_increasing = linspace(simscape.Value(1, Param.PlotSpeedUnit), Param.PlotSpeedUpperBound, numX)';
      F_climb_increasing = convert(Param.MaximumClimbPower ./ vel_climb_increasing, Param.PlotForceUnit);
      vel_climb_flip = flipud(vel_climb_increasing);
      F_climb_flip = Param.PlotForceUpperBound * ones(numel(vel_climb_flip), 1);
      Param.vel_climb = [vel_climb_increasing; vel_climb_flip];
      Param.F_climb = [F_climb_increasing; F_climb_flip];

      Param.x_max = value(Param.PlotSpeedUpperBound, Param.PlotSpeedUnit);

    end  % function

    function Param = Vehicle1DPerformanceParameters
      %%
      % Update derived parameters, road-load coefficients A and C.
      % This is assuming that the parameterization type is Regular.
      Param = UpdateRoadLoadA(Param);
      Param = UpdateRoadLoadC(Param);
      Param = UpdateMaximumClimbPower(Param);
      Param = UpdateMaximumForce(Param);
    end  % function

    function Param = UpdateRoadLoadA(Param)
      %%
      C_r = Param.TireRollingCoefficient;
      M_v = Param.VehicleMass;
      g = Param.GravitationalAcceleration;
      Param.RoadLoadA = convert(C_r * M_v * g, "N");
    end  % function

    function Param = UpdateRoadLoadC(Param)
      %%
      C_d = Param.AirDragCoefficient;
      A_f = Param.FrontalArea;
      d = Param.AirDensity;
      Param.RoadLoadC = convert((1/2) * C_d * A_f * d, "N/(m/s)^2");
    end  % function

    function Param = UpdateMaximumClimbPower(Param)
      %%
      A = Param.RoadLoadA;
      B = Param.RoadLoadB;
      C = Param.RoadLoadC;
      vmax = Param.TopSpeed;
      M = Param.VehicleMass;
      g = Param.GravitationalAcceleration;
      grade_pct = Param.MaximumClimbGrade;
      angle = simscape.Value(atan(grade_pct/100), "rad");
      F = (A + B*vmax)*cos(angle) + C*vmax^2 + M*g*sin(angle);
      P = F * vmax;
      val_P = ceil(value(P, "kW"));
      Param.MaximumClimbPower = simscape.Value(val_P, "kW");
    end  % function

    function Param = UpdateMaximumForce(Param)
      %%
      a_max = Param.MaximumAcceleration;
      M_v = Param.VehicleMass;
      g = Param.GravitationalAcceleration;
      max_force = a_max * M_v * g;
      val_F = ceil(value(max_force, "N"));
      Param.MaximumForce = simscape.Value(val_F, "N");
    end  % function

    function ParamString = Stringify(Param)
      %%
      arguments (Output)
        ParamString (1,1) string
      end  % arguments
      names_str = string(properties(Param));
      max_name_len = max(strlength(names_str));
      num_names = numel(names_str);
      line_str = strings(num_names, 1);
      for idx = 1 : num_names
        name_str = names_str(idx);
        if string(class(Param.(name_str))) == "simscape.Value"
          val_str = join(string(value(Param.(name_str))), ", ");
          unit_str = string(unit(Param.(name_str)));
          line_str(idx) = compose("%+"+max_name_len+"s: %s (%s)", name_str, val_str, unit_str);
        else
          % This branch implicitly assumes that the element is enum.
          val_str = string(Param.(name_str));
          if isscalar(val_str)
            line_str(idx) = compose("%+"+max_name_len+"s: %s", name_str, val_str);
          end  % if
        end
      end  % for
      ParamString = join(line_str, newline);
    end  % function

    function Param = getParametersFromBlock(Param, BlockPath)
      %%
      arguments (Input)
        Param
        BlockPath (1,1) string = ""
      end  % arguments

      arguments (Output)
        Param
      end  % arguments

      if BlockPath == ""
        id = Param.errorID + "getParametersFromBlock:InvalidBlockPath";
        msg = "Empty block path is not allowed.";

        throw(MException(id, msg))

      end  % if

      model_name = extractBefore(BlockPath, "/");
      if not(bdIsLoaded(model_name))
        load_system(model_name)
      end  % if

      try
        block_properties = LiteApp5.SimscapeUtility.buildPropertyDictionaryFromBlock(BlockPath);
      catch exception

        rethrow(exception)

      end  % try, catch

      % Full enum name is returned, e.g., "sdl.enum.VehicleParameterizationType.Regular".
      full_enum_name = block_properties("vehParamType");
      % Get the last part, which is the enum element name, e.g. "Regular".
      enum_element_name = extractAfter(full_enum_name,  asManyOfPattern(wildcardPattern + "."));

      if enum_element_name ~= "Regular"
        id = Param.errorID + "getParametersFromBlock:InvalidParameter";
        msg = LiteApp5.Utility.i18n("Only ""Regular"" Parameterization type for Longitudinal Vehicle block is supported.");

        throw(MException(id, msg))

      end  % if

      Param.VehicleParameterizationType = enum_element_name;

      function sscval = get_simscape_value(name)
        v = double(block_properties(name));
        if isnan(v)
          v = evalin("base", block_properties(name));
        end  % if
        u = block_properties(name + "_unit");
        sscval = simscape.Value(v, u);
      end  % function

      Param.VehicleMass = get_simscape_value("M_vehicle");
      % R_tireroll (tire rolling radius) is skipped.
      Param.TireRollingCoefficient = get_simscape_value("C_tireroll");
      Param.AirDragCoefficient = get_simscape_value("C_airdrag");
      Param.FrontalArea = get_simscape_value("A_front");
      Param.GravitationalAcceleration = get_simscape_value("g");
      Param.AirDensity = get_simscape_value("air_density");

    end  % function

    function setParametersToBlock(Param, BlockPath)
      %%
      % This function transfers the parameter settings to the target Longitudinal Vehicle block.
      %
      % - Parameterizationtype is set to "Regular".
      % - This function does not modify Tire rolling radius "R_tireroll" of the block.
      %
      % The road-load parameter B (as well as A and C) are ignored because
      % road-load parameters are not used when the Parameterization type is Regular.
      % !todo: Consider supporting "Road-load" parameterization type in addition to Regular.

      arguments (Input)
        Param
        BlockPath (1,1) string = ""
      end  % arguments

      if BlockPath == ""
        id = Param.errorID + "setParametersFromBlock:InvalidBlockPath";
        msg = "Empty block path is not allowed.";

        throw(MException(id, msg))

      end  % if

      model_name = extractBefore(BlockPath, "/");
      if not(bdIsLoaded(model_name))
        load_system(model_name)
      end  % if

      set_param(BlockPath, "vehParamType", "sdl.enum.VehicleParameterizationType.Regular");

      set_param(BlockPath, "M_vehicle", Param.VehicleMass);
      % R_tireroll (tire rolling radius) is skipped.
      set_param(BlockPath, "C_tireroll", Param.TireRollingCoefficient);
      set_param(BlockPath, "C_airdrag", Param.AirDragCoefficient);
      set_param(BlockPath, "A_front", Param.FrontalArea);
      set_param(BlockPath, "g", Param.GravitationalAcceleration);
      set_param(BlockPath, "air_density", Param.AirDensity);

    end  % function

  end  % methods

end  % classdef
