classdef RotationalFrictionTorqueDataSet
  % Data set for the visualization of the rotational friction torque model.
  %
  % This class holds a complete data set required to visualize the rotational friction model, which
  % is used by the Rotational Friction block in Simscape.

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

  % Copyright 2025-2026 The MathWorks, Inc.

  properties (Access=private, Constant)
    errorID (1,1) string = "RotationalFrictionTorqueDataSet:"
  end  % properties
  properties

    % Parameters of the torque model
    ModelParams (1,1) bevutil1.app.RotationalFrictionTorque.RotationalFrictionTorqueModelParameters

    % Block path to the target block in a model
    BlockPath (1,1) string = ""
    ModelName (1,1) string = ""

    % -------------------------------------------------------------------------
    % Visualization parameters

    % Switch to show or hide Stribeck torque plot
    ShowStribeckTorque (1,1) matlab.lang.OnOffSwitchState = "on"

    % Switch to show or hide Coulomb torque plot
    ShowCoulombTorque (1,1) matlab.lang.OnOffSwitchState = "on"

    % Switch to show or hide viscous torque plot
    ShowViscousTorque (1,1) matlab.lang.OnOffSwitchState = "on"

    % Physical unit of angular speed for visualization (X axis)
    PlotAngularVelocityUnit simscape.Unit ...
      { simscape.mustBeCommensurateUnit(PlotAngularVelocityUnit, "rad/s") } ...
      = simscape.Unit("rad/s")

    % Physical unit of torque for visualization (Y axis)
    PlotTorqueUnit simscape.Unit ...
      { simscape.mustBeCommensurateUnit(PlotTorqueUnit, "N*m") } ...
      = simscape.Unit("N*m")

    % -------------------------------------------------------------------------
    % Data for visualization

    % Number of values of angular speed (X axis)
    NumVelocityValues { mustBeInteger, mustBePositive } = 200

    % Values of angular speed (X axis)
    VelocityValues (:,1) simscape.Value ...
      { mustBeVector, simscape.mustBeCommensurateUnit(VelocityValues, "rad/s") } ...
      = simscape.Value([-1, 1]', "rad/s")

    % Minimum value of angular speed data
    VelocityMin simscape.Value ...
      { mustBeScalarOrEmpty, simscape.mustBeCommensurateUnit(VelocityMin, "rad/s") } ...
      = simscape.Value(-1, "rad/s")

    % Maximum value of angular speed data
    VelocityMax simscape.Value ...
      { mustBeScalarOrEmpty, simscape.mustBeCommensurateUnit(VelocityMax, "rad/s") } ...
      = simscape.Value(1, "rad/s")

    % Data set of torque (Y axis)
    TorqueValues (:,1) simscape.Value ...
      { mustBeVector, simscape.mustBeCommensurateUnit(TorqueValues, "N*m") } ...
      = simscape.Value([0, 0]', "N*m")

    % Data set of Stribeck torque (Y axis)
    StribeckTorqueValues simscape.Value ...
      { mustBeVector, simscape.mustBeCommensurateUnit(StribeckTorqueValues, "N*m") } ...
      = simscape.Value([0, 0]', "N*m")

    % Data set of Coulomb torque (Y axis)
    CoulombTorqueValues simscape.Value ...
      { mustBeVector, simscape.mustBeCommensurateUnit(CoulombTorqueValues, "N*m") } ...
      = simscape.Value([0, 0]', "N*m")

    % Data set of viscous torque (Y axis)
    ViscousTorqueValues simscape.Value ...
      { mustBeVector, simscape.mustBeCommensurateUnit(ViscousTorqueValues, "N*m") } ...
      = simscape.Value([0, 0]', "N*m")

  end  % properties

  methods

    function DataSet = RotationalFrictionTorqueDataSet(NameValuePair)
      %%
      arguments (Input)
        NameValuePair.Initialization (1,1) logical = false
        NameValuePair.BlockPath (1,1) string = ""
      end  % arguments

      DataSet.ModelParams = bevutil1.app.RotationalFrictionTorque.RotationalFrictionTorqueModelParameters;

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
        if mask_type ~= "Rotational Friction"
          id = DataSet.errorID + "InvalidBlock";
          msg = bevutil1.CodeUtil.i18n("Specified block is invalid: ") + DataSet.BlockPath;

          throw(MException(id, msg))

        end  % if

        DataSet.ModelParams.BreakawayTorque = bevutil1.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "brkwy_trq");
        DataSet.ModelParams.BreakawayVelocity = bevutil1.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "brkwy_vel");
        DataSet.ModelParams.CoulombTorque = bevutil1.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "Col_trq");
        DataSet.ModelParams.ViscousCoefficient = bevutil1.ModelUtil.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "visc_coef");

        DataSet = resetCommonSettings(DataSet);
      end  % if
    end  % function

    function DataSet = resetDataSet(DataSet)
      %%
      DataSet.ModelParams.BreakawayTorque = simscape.Value(25, "N*m");
      DataSet.ModelParams.BreakawayVelocity = simscape.Value(0.1, "rad/s");
      DataSet.ModelParams.CoulombTorque = simscape.Value(20, "N*m");
      DataSet.ModelParams.ViscousCoefficient = simscape.Value(0.001, "N*m*s/rad");

      DataSet = resetCommonSettings(DataSet);

    end  % function

    function DataSet = resetCommonSettings(DataSet)
      %%
      DataSet.NumVelocityValues = 200;

      DataSet.PlotAngularVelocityUnit = "rad/s";
      DataSet.PlotTorqueUnit = "N*m";

      DataSet = updateDataSet(DataSet);

    end  % function

    function DataSet = updateDataSet(DataSet)
      %%
      DataSet.ModelParams = updateDerivedParameters(DataSet.ModelParams);

      % Determine the plot range in x-axis (velocity) from the friction model.
      threshold_velocity = value(DataSet.ModelParams.StribeckThresholdVelocity);
      velocity_hi = floor(5 * threshold_velocity);
      if velocity_hi < 1
        velocity_hi = 5 * threshold_velocity;
      end
      upper_bound = simscape.Value(velocity_hi, unit(DataSet.ModelParams.StribeckThresholdVelocity));
      lower_bound = -upper_bound;
      velocity_values = transpose(linspace(lower_bound, upper_bound, DataSet.NumVelocityValues));

      DataSet.VelocityValues = velocity_values;
      DataSet.VelocityMin = lower_bound;
      DataSet.VelocityMax = upper_bound;

      coeff = DataSet.ModelParams.ViscousCoefficient;
      DataSet.ViscousTorqueValues = coeff * velocity_values;  % !friction-model

      trq_c = DataSet.ModelParams.CoulombTorque;
      th_c = DataSet.ModelParams.CoulombThresholdVelocity;
      DataSet.CoulombTorqueValues = trq_c * tanh(velocity_values ./ th_c);  % !friction-model

      scale_s = DataSet.ModelParams.StribeckScaledTorque;
      th_s = DataSet.ModelParams.StribeckThresholdVelocity;
      DataSet.StribeckTorqueValues = ...
        scale_s * (velocity_values ./ th_s .* exp(-(velocity_values ./ th_s).^2));  % !friction-model

      DataSet.TorqueValues = ...
        DataSet.StribeckTorqueValues + DataSet.CoulombTorqueValues + DataSet.ViscousTorqueValues;  % !friction-model

    end  % function

  end  % methods
end  % classdef
