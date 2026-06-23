classdef AbstractMotorDataSet < handle
  % Data set for the abstract motor model for visualization.
  %
  % This class holds a complete data set required to visualize the
  % power conversion efficiency contour of the abstract motor model.
  %
  % The model is used by the following blocks.
  % - The "Motor & Drive" block in Simscape Driveline.
  % - The "Motor & Drive (System Level)" block in Simscape Electrical.

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

  % Copyright 2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "AbstractMotorDataSet:"
  end  % properties

  properties

    % "Simplified" for the "Motor & Drive" block in Simscape Driveline.
    % "Full" for the "Motor & Drive (System Level)" block in Simscape Electrical.
    MotorModelType (1,1) string {mustBeMember(MotorModelType, ["Simplified", "Full"])} = "Full"

    % Parameters of the target motor model
    ModelParams (1,1) AbstractMotor1.AbstractMotorModelParameters...
      = AbstractMotor1.AbstractMotorModelParameters(Initialization=true)

    % Block path to the target block in a model
    BlockPath (1,1) string = ""
    ModelName (1,1) string = ""

    PlotResolution (1,1) { mustBeInteger, mustBePositive } = 10

    % -------------------------------------------------------------------------
    % X axis - Angular speed

    % Plot upper bound of angular speed
    PlotAngularSpeedUpperBound simscape.Value ...
      {mustBeScalarOrEmpty, simscape.mustBeCommensurateUnit(PlotAngularSpeedUpperBound, "rad/s")} ...
      = simscape.Value(1, "rpm")

    % In the road vehicle applications, maximum motor speed is determined by
    % vehicle top speed, tire rolling radius, and reduction gear ratio.
    % The abstract motor model and the Motor & Drive block do not have
    % a parameter for the max speed.
    MaxAngularSpeed (1,1) simscape.Value ...
      {CodeUtil1.mustBeSimscapeValuePositiveOrNan, simscape.mustBeCommensurateUnit(MaxAngularSpeed, "rad/s")} ...
      = simscape.Value(nan, "rpm")

    % -------------------------------------------------------------------------
    % Y axis - Motor torque

    % Plot upper bound of torque
    PlotTorqueUpperBound simscape.Value ...
      {mustBeScalarOrEmpty, simscape.mustBeCommensurateUnit(PlotTorqueUpperBound, "N*m")} ...
      = simscape.Value(nan, "N*m")

    ShowTorqueEnvelope (1,1) matlab.lang.OnOffSwitchState = "on"

    % -------------------------------------------------------------------------
    % X-Y data

    % Contour levels need 3 or more points for lower bound, upper bound,
    % and one or more points in between.
    ContourLevelsPercent (1,:) double {mustBeNonnegative} = [0 50 99]

    ShowContourText (1,1) matlab.lang.OnOffSwitchState = "on"

    % =========================================================================
    % Computed data

    % Values of angular speed
    AngularSpeedValues (:,1) simscape.Value ...
      {mustBeVector, simscape.mustBeCommensurateUnit(AngularSpeedValues, "rad/s")} ...
      = simscape.Value([0, 1]', "rpm")

    % Values of torque
    TorqueValues (:,1) simscape.Value ...
      {mustBeVector, simscape.mustBeCommensurateUnit(TorqueValues, "N*m")} ...
      = simscape.Value([0, 0]', "N*m")

    EfficiencyPercentMeshData double = zeros(2, 2)

    TorqueEnvelopeValues (:,1) simscape.Value ...
      {mustBeVector, simscape.mustBeCommensurateUnit(TorqueEnvelopeValues, "N*m")} ...
      = simscape.Value([0, 0]', "N*m")

  end  % properties

  methods

    function DataSet = AbstractMotorDataSet(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.Initialization (1,1) logical = false
        NameValuePair.BlockPath (1,1) string = ""
      end  % arguments

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

        resetDataSet(DataSet)

      else
        % Set up a data set using the specified block in the specified model.

        load_system(DataSet.ModelName)

        mask_type = get_param(DataSet.BlockPath, "MaskType");
        if mask_type == "Motor & Drive"
          DataSet.MotorModelType = "Simplified";
        elseif mask_type == ("Motor & Drive" + newline + "(System Level)")
          DataSet.MotorModelType = "Full";
        else
          id = DataSet.errorID + "InvalidBlock";
          msg = CodeUtil1.i18n("Specified block is invalid: ") + DataSet.BlockPath;

          throw(MException(id, msg))

        end  % if

        DataSet.ModelParams.MaxTorque = ModelUtil1.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "torque_max");
        DataSet.ModelParams.MaxPower = ModelUtil1.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "power_max");
        DataSet.ModelParams.MeasuredEfficiencyPercent = ModelUtil1.getDoubleValueFromBlockParameter(DataSet.BlockPath, "eff");
        DataSet.ModelParams.MeasuredAngularSpeed = ModelUtil1.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "w_eff");
        DataSet.ModelParams.MeasuredTorque = ModelUtil1.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "T_eff");

        if DataSet.MotorModelType == "Full"
          DataSet.ModelParams.MeasuredIronLoss = ModelUtil1.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "Piron");
          DataSet.ModelParams.FixedLoss = ModelUtil1.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "Pbase");
          DataSet.ModelParams.RotorDamping = ModelUtil1.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "Lam");
        else
          % Simplified.
          DataSet.ModelParams.MeasuredIronLoss = simscape.Value(0, "W");
          DataSet.ModelParams.FixedLoss = simscape.Value(0, "W");
          DataSet.ModelParams.RotorDamping = simscape.Value(0, "N*m/(rad/s)");
        end  % if

        resetCommonSettings(DataSet)
      end  % if
    end  % function

    function resetDataSet(DataSet)
      %%

      DataSet.ModelParams.MaxTorque = simscape.Value(160, "N*m");
      DataSet.ModelParams.MaxPower = simscape.Value(55, "kW");

      DataSet.ModelParams.MeasuredEfficiencyPercent = 95;
      DataSet.ModelParams.MeasuredAngularSpeed = simscape.Value(2000, "rpm");
      DataSet.ModelParams.MeasuredTorque = simscape.Value(50, "N*m");

      if DataSet.MotorModelType == "Full"
        DataSet.ModelParams.MeasuredIronLoss = simscape.Value(55, "W");
        DataSet.ModelParams.FixedLoss = simscape.Value(40, "W");
        DataSet.ModelParams.RotorDamping = simscape.Value(0.05, "N*m/(rad/s)");
      else
        % Simplified.
        DataSet.ModelParams.MeasuredIronLoss = simscape.Value(0, "W");
        DataSet.ModelParams.FixedLoss = simscape.Value(0, "W");
        DataSet.ModelParams.RotorDamping = simscape.Value(0, "N*m/(rad/s)");
      end  % if

      resetCommonSettings(DataSet)

    end  % function

    function resetCommonSettings(DataSet)
      %%

      % Maximum angular speed is not a model parameter.
      DataSet.MaxAngularSpeed = simscape.Value(17000, "rpm");

      DataSet.ContourLevelsPercent = [1 60 80 90 92 94 96 97 98 99];
      DataSet.ShowContourText = "on";
      DataSet.ShowTorqueEnvelope = true;

      DataSet.PlotResolution = 500;

      DataSet.PlotAngularSpeedUpperBound = simscape.Value(18000, "rpm");

      DataSet.PlotTorqueUpperBound = simscape.Value(200, "N*m");

      updateDataSet(DataSet)

    end  % function

    function updateDataSet(DataSet)
      %%
      updateDerivedParameters(DataSet.ModelParams)

      plot_resolution = DataSet.PlotResolution;

      % contour_levels_pct = DataSet.ContourLevelsPercent;

      max_motor_speed_radps = value(DataSet.MaxAngularSpeed, "rad/s");  % Use rad/s.
      max_motor_torque_Nm = value(DataSet.ModelParams.MaxTorque, "N*m");
      max_motor_power_W = value(DataSet.ModelParams.MaxPower, "W");

      fixed_loss_W = value(DataSet.ModelParams.FixedLoss, "W");

      k_damp = value(DataSet.ModelParams.RotorDamping, "N*m/(rad/s)");

      % !attention: Speed should be non zero because it is used in the denominator to calculate torque envelope.
      w_radps_vec = linspace(1, max_motor_speed_radps, plot_resolution);

      trq_Nm_vec = linspace(0, max_motor_torque_Nm, plot_resolution)';

      measured_copper_loss_coeff = value(DataSet.ModelParams.MeasuredCopperLossCoefficient, "W/(N*m)^2");

      measured_iron_loss_coeff = value(DataSet.ModelParams.MeasuredIronLossCoefficient, "W/(rad/s)^2");  % Use rad/s.

      % =======================================================================
      % Calculations below are done in x-y mesh.
      [w_radps_mesh, trq_Nm_mesh] = meshgrid(w_radps_vec, trq_Nm_vec);

      % Fixed electrical loss
      fixed_loss_mesh = fixed_loss_W*ones(plot_resolution, plot_resolution);

      electrical_torque_mesh = abs(trq_Nm_mesh) - k_damp*w_radps_mesh;  % Steady state
      copper_loss_mesh = measured_copper_loss_coeff * electrical_torque_mesh.^2;  % Copper loss model

      iron_loss_mesh = measured_iron_loss_coeff * w_radps_mesh.^2;  % Iron loss model

      % Total electrical losses
      electrical_losses_mesh = fixed_loss_mesh + copper_loss_mesh + iron_loss_mesh;

      mech_power_mesh = trq_Nm_mesh .* w_radps_mesh;  % Mechanical power

      efficiency_percent_mesh = 100 * abs(mech_power_mesh) ./ (electrical_losses_mesh + abs(mech_power_mesh));

      torque_envelope = min(max_motor_power_W ./ w_radps_vec, max_motor_torque_Nm);

      % A mask matrix with 1 for valid, 0 for invalid regions.
      % This is multiplied to the efficiency matrix to set regions over the maximum torque to 0.
      valid_torque_region_mask = trq_Nm_mesh < torque_envelope;

      valid_speed_region_mask = w_radps_mesh < max_motor_speed_radps;

      % Apply the mask matrices.
      efficiency_percent_mesh = valid_torque_region_mask .* efficiency_percent_mesh;
      efficiency_percent_mesh = valid_speed_region_mask .* efficiency_percent_mesh;

      % -----------------------------------------------------------------------
      % Keep computed data.

      % !todo: Remove transpose when the "must be a vector" error is fixed.
      DataSet.TorqueEnvelopeValues = transpose(simscape.Value(torque_envelope, "N*m"));
      DataSet.AngularSpeedValues = transpose(simscape.Value(w_radps_vec, "rad/s"));

      DataSet.TorqueValues = simscape.Value(trq_Nm_vec, "N*m");
      DataSet.EfficiencyPercentMeshData = efficiency_percent_mesh;
    end  % function

  end  % methods
end  % classdef
