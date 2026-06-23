classdef AbstractMotorModelParameters < handle
  % Parameters of the abstract motor model.
  %
  % The parameters of this class correspond to those in the following blocks.
  % - The "Motor & Drive" block in Simscape Driveline
  % - The "Motor & Drive (System Level)" block in Simscape Electrical
  %
  % The "Motor & Drive (System Level)" block must have the following parameter settings.
  % - Performance: Maximum torque and power
  % - Electrical losses: Single efficiency measurement model
  % - Thermal port: omitted
  %
  % To create an uninitialized instance, call this class without any options.
  % To create an instance initialized with default parameter values,
  % use the Initialization=true option.

  % Copyright 2026 The MathWorks, Inc.

  properties

    MaxTorque simscape.Value ...
      { simscape.mustBeCommensurateUnit(MaxTorque, "N*m"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "N*m")

    MaxPower simscape.Value ...
      { simscape.mustBeCommensurateUnit(MaxPower, "kW"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "kW")

    MeasuredEfficiencyPercent double { mustBeInRange(MeasuredEfficiencyPercent, 0, 100) } = 0  %#ok<MUSTINRANGE>
      % mustBeBetween is not available in R2024b.

    MeasuredAngularSpeed simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredAngularSpeed, "rpm"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "rpm")

    MeasuredTorque simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredTorque, "N*m"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "N*m")

    % Iron (core) loss at efficiency measurement point.
    % - Hysteresis and eddy current losses.
    % - Primarily voltage/frequency dependent.
    MeasuredIronLoss simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredIronLoss, "W"), CodeUtil1.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(nan, "W")

    FixedLoss simscape.Value ...
      { simscape.mustBeCommensurateUnit(FixedLoss, "W"), CodeUtil1.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(nan, "W")

    RotorDamping simscape.Value ...
      { simscape.mustBeCommensurateUnit(RotorDamping, "N*m/rpm"), CodeUtil1.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(nan, "N*m/rpm")

    % -------------------------------------------------------------------------
    % Derived parameters

    % Nominal loss at efficiency measurement point.
    % - "Nominal" in this case means "operating point".
    % - Nominal loss can also be called rated loss.
    MeasuredNominalLoss simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredNominalLoss, "W"), CodeUtil1.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(nan, "W")

    % Copper loss at efficiency measurement point.
    % - Depends on the load.
    % - Evaluated at nominal (rated) current.
    MeasuredCopperLoss simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredCopperLoss, "W"), CodeUtil1.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(nan, "W")

    % The ratio of iron loss to nominal loss at efficiency measurement point.
    % - Iron loss is typically around 10% of nominal loss at measurement point.
    % - The ratio is not used by the Motor & Drive blocks.
    % - Useful to check that the estimated iron loss at efficiency measurement point
    % is about 10%.
    IronToNominalLossRatioPercent double { mustBeInRange(IronToNominalLossRatioPercent, 0, 100) }  %#ok<MUSTINRANGE>
      %  mustBeBetween is not available in R2024b.

    MeasuredIronLossCoefficient simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredIronLossCoefficient, "W/rpm^2") } ...
      = simscape.Value(nan, "W/rpm^2")

    MeasuredCopperLossCoefficient simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredCopperLossCoefficient, "W/(N*m)^2") } ...
      = simscape.Value(nan, "W/(N*m)^2")

  end  % properties

  methods

    function ModelParams = AbstractMotorModelParameters(NameValuePair)
      arguments (Input)
        NameValuePair.Initialization (1,1) logical = false
      end  % arguments

      if not(NameValuePair.Initialization)

        return

      end  % if

      ModelParams.MaxTorque = simscape.Value(160, "N*m");
      ModelParams.MaxPower = simscape.Value(55, "kW");

      ModelParams.MeasuredEfficiencyPercent = 95;
      ModelParams.MeasuredAngularSpeed = simscape.Value(2000, "rpm");
      ModelParams.MeasuredTorque = simscape.Value(50, "N*m");

      ModelParams.MeasuredIronLoss = simscape.Value(55, "W");
      ModelParams.FixedLoss = simscape.Value(40, "W");
      ModelParams.RotorDamping = simscape.Value(0.05, "N*m/(rad/s)");

      updateDerivedParameters(ModelParams)

    end  % function

    function updateDerivedParameters(ModelParams)

      % -----------------------------------------------------------------------
      % Nominal (rated) loss at efficiency measurement point

      normalized_measured_efficiency = ModelParams.MeasuredEfficiencyPercent / 100;
      if normalized_measured_efficiency > 0.998
        ModelParams.MeasuredNominalLoss = simscape.Value(0, "W");
        ModelParams.IronToNominalLossRatioPercent = 0;
        ModelParams.MeasuredCopperLoss = simscape.Value(0, "W");
        ModelParams.MeasuredIronLossCoefficient = simscape.Value(0, "W/rpm^2");
        ModelParams.MeasuredCopperLossCoefficient = simscape.Value(0, "W/(N*m)^2");

        return

      end  % if

      % Mechanical power at efficiency measurement point
      measured_mechanical_power = ModelParams.MeasuredAngularSpeed * ModelParams.MeasuredTorque;

      % Nominal loss (total loss) at efficiency measurement point
      measured_nominal_loss = convert((1/normalized_measured_efficiency - 1) * measured_mechanical_power, "W");

      ModelParams.MeasuredNominalLoss = measured_nominal_loss;

      % -----------------------------------------------------------------------
      % The ratio of iron loss to nominal loss at efficiency measurement point.

      % Measured nominal loss can be 0, for example if the motor model type is "Simplified".
      % Avoid divide-by-zero.
      if measured_nominal_loss < simscape.Value(1e-9, "W")
        ModelParams.IronToNominalLossRatioPercent = 0;
      else
        normalized_iron_to_nominal_loss_ratio = ModelParams.MeasuredIronLoss / measured_nominal_loss;
        ModelParams.IronToNominalLossRatioPercent = 100 * normalized_iron_to_nominal_loss_ratio;
      end  % if

      % -----------------------------------------------------------------------
      % Copper loss at efficiency measurement point

      measured_copper_loss = convert(measured_nominal_loss - ModelParams.MeasuredIronLoss, "W");
      ModelParams.MeasuredCopperLoss = measured_copper_loss;

      % -----------------------------------------------------------------------
      % Coefficients for the loss models

      % Iron loss coefficient for iron loss model
      measured_iron_loss_coeff = convert(ModelParams.MeasuredIronLoss / ModelParams.MeasuredAngularSpeed^2, "W/rpm^2");
      ModelParams.MeasuredIronLossCoefficient = measured_iron_loss_coeff;

      % Copper loss coefficient for copper loss model
      measured_copper_loss_coeff = convert(measured_copper_loss / ModelParams.MeasuredTorque^2, "W/(N*m)^2");
      ModelParams.MeasuredCopperLossCoefficient = measured_copper_loss_coeff;

    end  % function

  end  % methods
end  % classdef
