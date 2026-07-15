classdef Vehicle1DForceDataSet
  % Data set for the visualization of the vehicle 1d force model.
  %
  % This class holds a complete data set required to visualize the
  % longitudinal vehicle forces for given road grades.
  %
  % Many parameters of this class are also used by the Longitudinal Vehicle block
  % in Simscape Driveline.
  %
  % This class assumes that "Parameterization Type" of the Longitudinal Vehicle block
  % is "Regular" and treats the road-load coefficients A and C as derived parameters
  % while this class treats the coefficient B as zero.
  %
  % Road grade is in percent. In Simscape, the unit for percent is 1.

  % Usage
  %
  % Calling this class without any options creates an instance without
  % initializing some properties.
  %
  % To create an instance ready for visualization, use Initialization=true.
  %
  % To create an instance initialized with parameters defined in
  % a block in a model, use the BlockPath option.

  % Design
  %
  % DataSet contains the following essential data.
  %
  % - Model parameters class
  % - Visualization parameters, such as plot range
  % - Computed data for visualization (vectors or matrices)
  %
  % DataSet can also contain the following optional data.
  %
  % - Block path and model name

  % Copyright 2024-2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "Vehicle1DForceDataSet:"
  end  % properties

  properties

    % Parameters of the target model
    ModelParams (1,1) bevutil1.app.Vehicle1DForce.Vehicle1DForceModelParameters

    % Block path to the target block in a model
    BlockPath (1,1) string = ""
    ModelName (1,1) string = ""

    % -------------------------------------------------------------------------
    % Visualization parameters

    PlotSpeedUpperBound (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(PlotSpeedUpperBound, "m/s"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "km/hr")

    PlotForceUpperBound (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(PlotForceUpperBound, "N"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "N")

    % Road grades (in percent) to plot force curves
    PlotGrades (1,:) double { bevutil1.CodeUtil.mustBeNonnegativeOrNan } = [nan, nan]

    % Power values to plot constant power contours
    PlotPowers (1,:) simscape.Value ...
      { simscape.mustBeCommensurateUnit(PlotPowers, "kW"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value([nan, nan], "kW")

    % -------------------------------------------------------------------------
    % Data for visualization

    NumSpeedPoints (1,1) { mustBePositive, mustBeInteger } = 1

    % Values of vehicle speed
    VehicleSpeedValues (:,1) simscape.Value ...
      { mustBeVector, simscape.mustBeCommensurateUnit(VehicleSpeedValues, "m/s") } ...
      = simscape.Value([0, 1]', "km/hr")

    % Values of vehicle force
    VehicleForceValues simscape.Value ...
      { simscape.mustBeCommensurateUnit(VehicleForceValues, "N") } ...
      = simscape.Value([0, 0]', "N")

    % Values of force at constant power
    ForceValuesAtConstantPower simscape.Value ...
      { simscape.mustBeCommensurateUnit(ForceValuesAtConstantPower, "N") } ...
      = simscape.Value([0, 0]', "N")

  end  % properties

  methods

    function DataSet = Vehicle1DForceDataSet(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.Initialization (1,1) logical = false
        NameValuePair.BlockPath (1,1) string = ""
      end  % arguments

      DataSet.ModelParams = bevutil1.app.Vehicle1DForce.Vehicle1DForceModelParameters;

      if NameValuePair.BlockPath ~= ""
        DataSet.BlockPath = NameValuePair.BlockPath;
        DataSet.ModelName = extractBefore(NameValuePair.BlockPath, "/");

        NameValuePair.Initialization = true;
      end  % if

      if not(NameValuePair.Initialization)

        return

      end  % if

      if DataSet.ModelName == ""
        % Set up a data set using default values.

        DataSet = resetDataSet(DataSet);

      else
        % Set up a data set using the specified block in the specified model.

        load_system(DataSet.ModelName)

        mask_type = get_param(DataSet.BlockPath, "MaskType");
        if mask_type ~= "Longitudinal Vehicle"
          id = DataSet.errorID + "InvalidBlock";
          msg = bevutil1.CodeUtil.i18n("Specified block is invalid: ") + DataSet.BlockPath;

          throw(MException(id, msg))

        end  % if

        veh_type = string(get_param(DataSet.BlockPath, "vehParamType"));
        if veh_type ~= string(sdl.enum.VehicleParameterizationType.Regular) ...
            && veh_type ~= "sdl.enum.VehicleParameterizationType.Regular"
          id = DataSet.errorID + "InvalidParameterization";
          msg = bevutil1.CodeUtil.i18n("Parameterization type must be Regular parameter set.");

          throw(MException(id, msg))

        end  % if

        DataSet.ModelParams.VehicleMass = bevutil1.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "M_vehicle");
        DataSet.ModelParams.TireRollingCoefficient = bevutil1.ModelUtil.getDoubleValueFromBlockParameter(DataSet.BlockPath, "C_tireroll");
        DataSet.ModelParams.AirDragCoefficient = bevutil1.ModelUtil.getDoubleValueFromBlockParameter(DataSet.BlockPath, "C_airdrag");
        DataSet.ModelParams.FrontalArea = bevutil1.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "A_front");
        DataSet.ModelParams.GravitationalAcceleration = bevutil1.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "g");

        % Dry air density is a private parameter in the Longitudinal Vehicle block.
        % !todo: Make the "Dry air density" parameter of the block public.
        DataSet.ModelParams.DryAirDensity = bevutil1.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "air_density");

        % B is always 0 for the "Regular" parameterization type. The Longitudinal Vehicle block does not expose B as a parameter,
        % so it must be explicitly set to 0 rather than read from the block.
        DataSet.ModelParams.RoadLoadB = simscape.Value(0, "N/(m/s)");

        DataSet = resetCommonSettings(DataSet);
      end  % if
    end  % function

    function DataSet = resetDataSet(DataSet)
      %%
      DataSet.ModelParams.VehicleMass = simscape.Value(1200, "kg");
      DataSet.ModelParams.TireRollingCoefficient = 0.0136;
      DataSet.ModelParams.AirDragCoefficient = 0.31;
      DataSet.ModelParams.FrontalArea = simscape.Value(2.3, "m^2");

      DataSet.ModelParams.GravitationalAcceleration = simscape.Value(9.81, "m/s^2");
      DataSet.ModelParams.DryAirDensity = simscape.Value(1.184, "kg/m^3");

      DataSet.ModelParams.RoadLoadB = simscape.Value(0, "N/(m/s)");

      DataSet.ModelParams.TopSpeed = simscape.Value(160, "km/hr");
      DataSet.ModelParams.MaxAcceleration = 0.4;
      DataSet.ModelParams.MaxClimbGradePercent = 5;

      DataSet = resetCommonSettings(DataSet);

    end  % function

    function DataSet = resetCommonSettings(DataSet)
      %%
      DataSet.NumSpeedPoints = 200;

      DataSet.PlotGrades = [0, 5, 10, 20, 35];
      DataSet.PlotPowers = simscape.Value([10, 50, 100, 150], "kW");
      DataSet.PlotSpeedUpperBound = simscape.Value(180, "km/hr");
      DataSet.PlotForceUpperBound = simscape.Value(11000, "N");

      DataSet = updateDataSet(DataSet);

    end  % function

    function DataSet = updateDataSet(DataSet)
      %%
      DataSet.ModelParams = updateDerivedParameters(DataSet.ModelParams);

      M_veh = DataSet.ModelParams.VehicleMass;

      g = DataSet.ModelParams.GravitationalAcceleration;

      A_rl = DataSet.ModelParams.RoadLoadA;
      B_rl = DataSet.ModelParams.RoadLoadB;
      C_rl = DataSet.ModelParams.RoadLoadC;

      grades_percent = DataSet.PlotGrades;
      angles_rad = simscape.Value(atan(grades_percent/100), "rad");

      num_x = DataSet.NumSpeedPoints;
      num_grades = numel(DataSet.PlotGrades);
      num_powers = numel(DataSet.PlotPowers);

      % X axis data points
      plot_speed_unit = string(unit(DataSet.PlotSpeedUpperBound));
      DataSet.VehicleSpeedValues = transpose(linspace(simscape.Value(1, plot_speed_unit), DataSet.PlotSpeedUpperBound, num_x));

      x_vec = DataSet.VehicleSpeedValues;
      F_roll_vec = A_rl + B_rl*x_vec;
      F_airdrag_vec = C_rl*x_vec.^2;

      grade_str = strings(1, num_grades);
      angle_str = strings(1, num_grades);

      % Longitudinal vehicle force at constant grade
      F_const_grade_mat = simscape.Value(zeros(num_x, num_grades), "N");
      for k = 1 : num_grades
        grade_str(k) = string(grades_percent(k)) + " %";
        angle_str(k) = round(value(angles_rad(k), "deg"), 1) + " deg";
        s = angles_rad(k);
        F_const_grade_mat(:, k) = F_roll_vec*cos(s) + F_airdrag_vec + M_veh*g*sin(s);
      end  % for
      DataSet.VehicleForceValues = F_const_grade_mat;

      % Force at constant power
      F_const_power_mat = simscape.Value(zeros(num_x, num_powers), "N");
      for k = 1 : num_powers
        F_const_power_mat(:, k) = DataSet.PlotPowers(k) ./ x_vec;
      end  % for
      DataSet.ForceValuesAtConstantPower = F_const_power_mat;

    end  % function

  end  % methods
end  % classdef
