classdef AbstractMotorEfficiencyDataSet
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
    errorID (1,1) string = "AbstractMotorEfficiencyDataSet:"
  end  % properties

  properties

    % "Simplified" for the "Motor & Drive" block in Simscape Driveline.
    % "Full" for the "Motor & Drive (System Level)" block in Simscape Electrical.
    MotorModelType (1,1) string {mustBeMember(MotorModelType, ["Simplified", "Full"])} = "Full"

    % Parameters of the target motor model
    ModelParams (1,1) bev1mus.app.AbstractMotorEfficiency.AbstractMotorEfficiencyModelParameters

    % Block path to the target block in a model
    BlockPath (1,1) string = ""
    ModelName (1,1) string = ""

    PlotResolution (1,1) { mustBeInteger, mustBePositive } = 10

    PlotAutoRange (1,1) matlab.lang.OnOffSwitchState = "on"

    % -------------------------------------------------------------------------
    % X axis - Angular speed

    MaxAngularSpeedMode (1,1) string {mustBeMember(MaxAngularSpeedMode, ["auto", "specify"])} = "auto"

    % MaxAngularSpeedRate is ignored if MaxAngularSpeedMode is "specify".
    % MaxAngularSpeedRate is used to determine the maximum angular speed if MaxAngularSpeedMode is "auto".
    %
    % The maximum power P is divided by a value of the max motor torque T multiplied by this rate k,
    % which yields the maximum angular speed w; w = P/(k*T).
    % For example, if k=0.25, the max speed is a speed at 25 % of the max torque on the max power curve.
    MaxAngularSpeedRate (1,1) double { mustBeInRange(MaxAngularSpeedRate, 0, 1) } = 0  %#ok<MUSTINRANGE>

    % Plot upper bound of angular speed
    PlotAngularSpeedUpperBound simscape.Value ...
      {mustBeScalarOrEmpty, simscape.mustBeCommensurateUnit(PlotAngularSpeedUpperBound, "rad/s")} ...
      = simscape.Value(1, "rpm")

    % MaxAngularSpeed is ignored if MaxAngularSpeedMode is "auto".
    % MaxAngularSpeed is used if MaxAngularSpeedMode is "specify".
    %
    % In the road vehicle applications, maximum motor speed is determined by
    % vehicle top speed, tire rolling radius, and reduction gear ratio.
    % The abstract motor model and the Motor & Drive block do not have
    % a parameter for the max speed.
    MaxAngularSpeed (1,1) simscape.Value ...
      {bev1mus.CodeUtil.mustBeSimscapeValuePositiveOrNan, simscape.mustBeCommensurateUnit(MaxAngularSpeed, "rad/s")} ...
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
    PlotContourLevelsPercent (1,:) double {mustBeNonnegative} = [0 50 99]

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

    function DataSet = AbstractMotorEfficiencyDataSet(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.Initialization (1,1) logical = false
        NameValuePair.BlockPath (1,1) string = ""
      end  % arguments

      DataSet.ModelParams = bev1mus.app.AbstractMotorEfficiency.AbstractMotorEfficiencyModelParameters;

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
        if mask_type == "Motor & Drive"
          DataSet.MotorModelType = "Simplified";
        elseif mask_type == ("Motor & Drive" + newline + "(System Level)")
          DataSet.MotorModelType = "Full";
        else
          id = DataSet.errorID + "InvalidBlock";
          msg = bev1mus.CodeUtil.i18n("Specified block is invalid: ") + DataSet.BlockPath;

          throw(MException(id, msg))

        end  % if

        DataSet.ModelParams.MaxTorque = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "torque_max");
        DataSet.ModelParams.MaxPower = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "power_max");
        DataSet.ModelParams.OverallEfficiencyPercent = bev1mus.ModelUtil.getDoubleValueFromBlockParameter(DataSet.BlockPath, "eff");
        DataSet.ModelParams.MeasuredAngularSpeed = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "w_eff");
        DataSet.ModelParams.MeasuredTorque = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "T_eff");

        if DataSet.MotorModelType == "Full"
          DataSet.ModelParams.MeasuredIronLosses = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "Piron");
          DataSet.ModelParams.FixedLosses = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "Pbase");
          DataSet.ModelParams.RotorDampingCoefficient = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "Lam");
        else
          % Simplified.
          DataSet.ModelParams.MeasuredIronLosses = simscape.Value(0, "W");
          DataSet.ModelParams.FixedLosses = simscape.Value(0, "W");
          DataSet.ModelParams.RotorDampingCoefficient = simscape.Value(0, "N*m/(rad/s)");
        end  % if

        DataSet = resetCommonSettings(DataSet);
      end  % if
    end  % function

    function DataSet = resetDataSet(DataSet)
      %%

      DataSet.ModelParams.MaxTorque = simscape.Value(160, "N*m");
      DataSet.ModelParams.MaxPower = simscape.Value(55, "kW");

      DataSet.ModelParams.OverallEfficiencyPercent = 95;
      DataSet.ModelParams.MeasuredAngularSpeed = simscape.Value(2000, "rpm");
      DataSet.ModelParams.MeasuredTorque = simscape.Value(50, "N*m");

      if DataSet.MotorModelType == "Full"
        DataSet.ModelParams.MeasuredIronLosses = simscape.Value(55, "W");
        DataSet.ModelParams.FixedLosses = simscape.Value(40, "W");
        DataSet.ModelParams.RotorDampingCoefficient = simscape.Value(0.05, "N*m/(rad/s)");
      else
        % Simplified.
        DataSet.ModelParams.MeasuredIronLosses = simscape.Value(0, "W");
        DataSet.ModelParams.FixedLosses = simscape.Value(0, "W");
        DataSet.ModelParams.RotorDampingCoefficient = simscape.Value(0, "N*m/(rad/s)");
      end  % if

      DataSet = resetCommonSettings(DataSet);

    end  % function

    function DataSet = resetCommonSettings(DataSet)
      %%

      DataSet.MaxAngularSpeedMode = "auto";
      DataSet.MaxAngularSpeedRate = 0.25;

      DataSet.PlotContourLevelsPercent = [1 60 80 90 92 94 96 97 98 99];
      DataSet.ShowContourText = "on";
      DataSet.ShowTorqueEnvelope = "on";

      DataSet.PlotResolution = 500;
      DataSet.PlotAutoRange = "on";
      DataSet.PlotAngularSpeedUpperBound = simscape.Value(18000, "rpm");
      DataSet.PlotTorqueUpperBound = simscape.Value(200, "N*m");

      DataSet = updateDataSet(DataSet);

    end  % function

    function DataSet = updateDataSet(DataSet)
      %%
      DataSet.ModelParams = updateDerivedParameters(DataSet.ModelParams);

      plot_resolution = DataSet.PlotResolution;

      % -----------------------------------------------------------------------
      % power

      max_motor_power_W = value(DataSet.ModelParams.MaxPower, "W");

      % -----------------------------------------------------------------------
      % torque

      max_motor_torque_value_in_Nm = value(DataSet.ModelParams.MaxTorque, "N*m");

      trq_Nm_vec = transpose(linspace(0, max_motor_torque_value_in_Nm, plot_resolution));
      DataSet.TorqueValues = simscape.Value(trq_Nm_vec, "N*m");

      % -----------------------------------------------------------------------
      % angular speed

      if DataSet.MaxAngularSpeedMode == "auto"
        max_motor_speed_value_in_radps = max_motor_power_W / (DataSet.MaxAngularSpeedRate * max_motor_torque_value_in_Nm);
        DataSet.MaxAngularSpeed = convert(simscape.Value(max_motor_speed_value_in_radps, "rad/s"), "rpm");
      else
        % MaxAngularSpeedMode is "specify".
        % Max angular speed is not a model parameter.
        max_motor_speed_value_in_radps = value(DataSet.MaxAngularSpeed, "rad/s");
      end  % if

      % !attention: Speed should avoid zero because it is used in the denominator when calculating torque envelope.
      w_radps_vec = linspace(1, max_motor_speed_value_in_radps, plot_resolution);
      DataSet.AngularSpeedValues = transpose(simscape.Value(w_radps_vec, "rad/s"));

      % -----------------------------------------------------------------------
      contour_levels = DataSet.PlotContourLevelsPercent;
      if numel(contour_levels) <= 2
        id = DataSet.errorID + "NotEnoughElements";
        msg = bev1mus.CodeUtil.i18n("Contour levels must have 3 or more elements.");

        throw(MException(id, msg))

      end  % if

      % -----------------------------------------------------------------------

      fixed_losses_W = value(DataSet.ModelParams.FixedLosses, "W");

      k_damp = value(DataSet.ModelParams.RotorDampingCoefficient, "N*m/(rad/s)");

      measured_copper_loss_coeff = value(DataSet.ModelParams.MeasuredCopperLossCoefficient, "W/(N*m)^2");

      measured_iron_loss_coeff = value(DataSet.ModelParams.MeasuredIronLossCoefficient, "W/(rad/s)^2");  % Use rad/s.

      % =======================================================================
      % Calculations below are done in x-y mesh.
      [w_radps_mat, trq_Nm_mat] = meshgrid(w_radps_vec, trq_Nm_vec);

      % Fixed electrical loss
      fixed_losses_mat = fixed_losses_W*ones(plot_resolution, plot_resolution);

      electrical_torque_mat = abs(trq_Nm_mat) + k_damp*w_radps_mat;  % Steady state
      copper_losses_mat = measured_copper_loss_coeff * electrical_torque_mat.^2;  % Copper loss model

      iron_losses_mat = measured_iron_loss_coeff * w_radps_mat.^2;  % Iron loss model

      % Total electrical losses
      electrical_losses_mat = fixed_losses_mat + copper_losses_mat + iron_losses_mat;

      mech_power_mat = trq_Nm_mat .* w_radps_mat;  % Mechanical power

      efficiency_percent_mat = 100 * abs(mech_power_mat) ./ (electrical_losses_mat + abs(mech_power_mat));

      torque_envelope_vec_in_Nm = min(max_motor_power_W ./ w_radps_vec, max_motor_torque_value_in_Nm);
      % !todo: Remove transpose when the "must be a vector" error is fixed.
      DataSet.TorqueEnvelopeValues = transpose(simscape.Value(torque_envelope_vec_in_Nm, "N*m"));

      % A mask matrix with 1 for valid, 0 for invalid regions.
      % This is multiplied to the efficiency matrix to set regions over the maximum torque to 0.
      valid_torque_region_mask = trq_Nm_mat < torque_envelope_vec_in_Nm;

      valid_speed_region_mask = w_radps_mat < max_motor_speed_value_in_radps;

      % Apply the mask matrices.
      efficiency_percent_mat = valid_torque_region_mask .* efficiency_percent_mat;
      efficiency_percent_mat = valid_speed_region_mask .* efficiency_percent_mat;
      DataSet.EfficiencyPercentMeshData = efficiency_percent_mat;
    end  % function

  end  % methods
end  % classdef
