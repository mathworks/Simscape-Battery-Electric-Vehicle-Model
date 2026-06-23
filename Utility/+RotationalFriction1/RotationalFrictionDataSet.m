classdef RotationalFrictionDataSet < handle
  % Data set for the visualization of the rotational friction torque model.
  %
  % This class holds a data set for the rotational friction model, which is used
  % by the Rotational Friction block in Simscape.
  % Use this class for visualizing the torque model based on the specified model parameters.
  %
  % Call this class without any options, and an uninitialized instance of this class is created.
  %
  % To create an instance which is ready for making a plot of the torque model,
  % use the Initialize=true option.
  %
  % To create an instance initialized with parameters defined in a Rotational Friction block in a model,
  % specify the block path to the BlockPath option.

  % Copyright 2025-2026 The MathWorks, Inc.

  properties

    % Parameters of the rotational friction torque model
    ModelParams (1,1) RotationalFriction1.RotationalFrictionModelParameters = RotationalFriction1.RotationalFrictionModelParameters(Initialization=true)

    % Block path to the target Rotational Friction block in a model
    BlockPath (1,1) string = ""
    ModelName (1,1) string = ""

    % -------------------------------------------------------------------------
    % X axis - Angular speed

    % Physical unit of angular speed for visualization (X axis)
    PlotVelocityUnit simscape.Unit { simscape.mustBeCommensurateUnit(PlotVelocityUnit, "rad/s") } = simscape.Unit("rad/s")

    % Number of values of angular speed (X axis)
    NumVelocityValues { mustBeInteger, mustBePositive } = 200

    % Values of angular speed (X axis)
    VelocityValues (:,1) simscape.Value { mustBeVector, simscape.mustBeCommensurateUnit(VelocityValues, "rad/s") } = simscape.Value([-1, 1]', "rad/s")

    % Minimum value of angular speed data
    VelocityMin simscape.Value { mustBeScalarOrEmpty, simscape.mustBeCommensurateUnit(VelocityMin, "rad/s") } = simscape.Value(-1, "rad/s")

    % Maximum value of angular speed data
    VelocityMax simscape.Value { mustBeScalarOrEmpty, simscape.mustBeCommensurateUnit(VelocityMax, "rad/s") } = simscape.Value(1, "rad/s")

    % -------------------------------------------------------------------------
    % Y axis - Friction torque

    % Physical unit of torque for visualization (Y axis)
    PlotTorqueUnit simscape.Unit { simscape.mustBeCommensurateUnit(PlotTorqueUnit, "N*m") } = simscape.Unit("N*m")

    % Data set of torque (Y axis)
    TorqueValues (:,1) simscape.Value { mustBeVector, simscape.mustBeCommensurateUnit(TorqueValues, "N*m") } = simscape.Value([0, 0]', "N*m")

    % Data set of Stribeck torque (Y axis)
    StribeckTorqueValues simscape.Value { mustBeVector, simscape.mustBeCommensurateUnit(StribeckTorqueValues, "N*m") } = simscape.Value([0, 0]', "N*m")

    % Data set of Coulomb torque (Y axis)
    CoulombTorqueValues simscape.Value { mustBeVector, simscape.mustBeCommensurateUnit(CoulombTorqueValues, "N*m") } = simscape.Value([0, 0]', "N*m")

    % Data set of viscous torque (Y axis)
    ViscousTorqueValues simscape.Value { mustBeVector, simscape.mustBeCommensurateUnit(ViscousTorqueValues, "N*m") } = simscape.Value([0, 0]', "N*m")

    % -------------------------------------------------------------------------
    % States of visualization app

    % State of enabled button (button with enable/disable check box) for plot auto-update
    AutoUpdatePlot matlab.lang.OnOffSwitchState = "on"

    % Switch to show or hide Stribeck torque plot
    ShowStribeckTorque (1,1) logical = true

    % Switch to show or hide Coulomb torque plot
    ShowCoulombTorque (1,1) logical = true

    % Switch to show or hide viscous torque plot
    ShowViscousTorque (1,1) logical = true

  end  % properties

  methods

    function DataSet = RotationalFrictionDataSet(NameValuePair)
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

        DataSet.ModelParams.BreakawayTorque = ModelUtil1.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "brkwy_trq");
        DataSet.ModelParams.BreakawayVelocity = ModelUtil1.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "brkwy_vel");
        DataSet.ModelParams.CoulombTorque = ModelUtil1.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "Col_trq");
        DataSet.ModelParams.ViscousCoefficient = ModelUtil1.getSimscapeValueFromBlockParameter(DataSet.BlockPath, "visc_coef");

        resetCommonSettings(DataSet)
      end  % if
    end  % function

    function resetDataSet(DataSet)
      %%
      DataSet.ModelParams.BreakawayTorque = simscape.Value(25, "N*m");
      DataSet.ModelParams.BreakawayVelocity = simscape.Value(0.1, "rad/s");
      DataSet.ModelParams.CoulombTorque = simscape.Value(20, "N*m");
      DataSet.ModelParams.ViscousCoefficient = simscape.Value(0.001, "N*m*s/rad");

      resetCommonSettings(DataSet)

    end  % function

    function resetCommonSettings(DataSet)
      %%
      DataSet.NumVelocityValues = 200;
      DataSet.PlotVelocityUnit = "rad/s";
      DataSet.PlotTorqueUnit = "N*m";

      updateDataSet(DataSet)

    end  % function

    function updateDataSet(DataSet)
      %%
      updateDerivedParameters(DataSet.ModelParams)

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
      DataSet.StribeckTorqueValues = scale_s * (velocity_values ./ th_s .* exp(-(velocity_values ./ th_s).^2));  % !friction-model

      DataSet.TorqueValues = DataSet.StribeckTorqueValues + DataSet.CoulombTorqueValues + DataSet.ViscousTorqueValues;  % !friction-model

    end  % function

  end  % methods
end  % classdef
