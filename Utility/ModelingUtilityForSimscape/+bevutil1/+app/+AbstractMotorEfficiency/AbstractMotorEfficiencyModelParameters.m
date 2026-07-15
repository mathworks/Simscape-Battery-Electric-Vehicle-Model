classdef AbstractMotorEfficiencyModelParameters
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

  properties (Access=private, Constant)
    errorID (1,1) string = "AbstractMotorEfficiencyModelParameters:"
  end  % properties
  properties

    MaxTorque simscape.Value ...
      { simscape.mustBeCommensurateUnit(MaxTorque, "N*m"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "N*m")

    MaxPower simscape.Value ...
      { simscape.mustBeCommensurateUnit(MaxPower, "kW"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "kW")

    OverallEfficiencyPercent double { mustBeInRange(OverallEfficiencyPercent, 0, 100) } ...
      = 0  %#ok<MUSTINRANGE> mustBeBetween is not available in R2024b.

    MeasuredAngularSpeed simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredAngularSpeed, "rpm"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "rpm")

    MeasuredTorque simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredTorque, "N*m"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(nan, "N*m")

    % Iron (core) losses at efficiency measurement point.
    % - Hysteresis and eddy current losses.
    % - Primarily voltage/frequency dependent.
    MeasuredIronLosses simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredIronLosses, "W"), bevutil1.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(nan, "W")

    FixedLosses simscape.Value ...
      { simscape.mustBeCommensurateUnit(FixedLosses, "W"), bevutil1.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(nan, "W")

    RotorDampingCoefficient simscape.Value ...
      { simscape.mustBeCommensurateUnit(RotorDampingCoefficient, "N*m/rpm"), bevutil1.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(nan, "N*m/rpm")

    % -------------------------------------------------------------------------
    % Derived parameters

    % Nominal losses at efficiency measurement point.
    % - "Nominal" in this case means "operating point".
    % - Nominal losses is also called rated losses.
    MeasuredNominalLosses simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredNominalLosses, "W"), bevutil1.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(nan, "W")

    % Copper loss at efficiency measurement point.
    % - Depends on the load.
    % - Evaluated at nominal (rated) current.
    MeasuredCopperLosses simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredCopperLosses, "W"), bevutil1.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(nan, "W")

    % The ratio of iron loss to nominal loss at efficiency measurement point.
    % - Iron loss is typically around 10% of nominal loss at measurement point.
    % - The ratio is not used by the Motor & Drive blocks.
    % - Useful to check that the estimated iron loss at efficiency measurement point
    % is about 10%.
    IronToNominalLossRatioPercent double { mustBeInRange(IronToNominalLossRatioPercent, 0, 100) } ...
      = 0  %#ok<MUSTINRANGE> mustBeBetween is not available in R2024b.

    MeasuredIronLossCoefficient simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredIronLossCoefficient, "W/rpm^2") } ...
      = simscape.Value(nan, "W/rpm^2")

    MeasuredCopperLossCoefficient simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredCopperLossCoefficient, "W/(N*m)^2") } ...
      = simscape.Value(nan, "W/(N*m)^2")

  end  % properties

  methods

    function ModelParams = AbstractMotorEfficiencyModelParameters(NameValuePair)
      arguments (Input)
        NameValuePair.Initialization (1,1) logical = false
      end  % arguments

      if not(NameValuePair.Initialization)

        return

      end  % if

      ModelParams.MaxTorque = simscape.Value(160, "N*m");
      ModelParams.MaxPower = simscape.Value(55, "kW");

      ModelParams.OverallEfficiencyPercent = 95;
      ModelParams.MeasuredAngularSpeed = simscape.Value(2000, "rpm");
      ModelParams.MeasuredTorque = simscape.Value(50, "N*m");

      ModelParams.MeasuredIronLosses = simscape.Value(55, "W");
      ModelParams.FixedLosses = simscape.Value(40, "W");
      ModelParams.RotorDampingCoefficient = simscape.Value(0.05, "N*m/(rad/s)");

      ModelParams = updateDerivedParameters(ModelParams);

    end  % function

    function ModelParams = updateDerivedParameters(ModelParams)
      %%

      % -----------------------------------------------------------------------
      % Validate constraints involving primary parameters before dealing with derived parameters.
      % Constraints on individual parameters are imposed in the property declarations.
      % The logic here validates constrains involving two or more parameters.

      if ModelParams.MaxTorque < ModelParams.MeasuredTorque
        % It is unknown which is/are wrong; MaxTorque, and/or MeasuredTorque.
        id = ModelParams.errorID + "InvalidTorqueParameters";
        msg = bevutil1.CodeUtil.i18n("Torque at measurement point cannot be greater than max torque.");

        throw(MException(id, msg))

      end  % if

      if ModelParams.MaxPower / ModelParams.MaxTorque < ModelParams.MeasuredAngularSpeed
        % It is unknown which is/are wrong; MaxPower, MaxTorque, and/or MeasuredAngularSpeed.
        id = ModelParams.errorID + "SpeedConstraintViolation";
        msg = bevutil1.CodeUtil.i18n("MeasuredAngularSpeed cannot be higher than the speed determined from max power and max torque.");

        throw(MException(id, msg))

      end  % if

      % -----------------------------------------------------------------------
      % Nominal (rated) losses at efficiency measurement point

      normalized_measured_efficiency = ModelParams.OverallEfficiencyPercent / 100;
      if normalized_measured_efficiency > 0.998
        % Treat the motor as an ideal motor, i.e., a motor without losses in power conversion.
        ModelParams.MeasuredNominalLosses = simscape.Value(0, "W");
        ModelParams.IronToNominalLossRatioPercent = 0;
        ModelParams.MeasuredCopperLosses = simscape.Value(0, "W");
        ModelParams.MeasuredIronLossCoefficient = simscape.Value(0, "W/rpm^2");
        ModelParams.MeasuredCopperLossCoefficient = simscape.Value(0, "W/(N*m)^2");

        return

      end  % if

      % Mechanical power at efficiency measurement point
      measured_mechanical_power = ModelParams.MeasuredAngularSpeed * ModelParams.MeasuredTorque;

      % Nominal losses (total losses) at efficiency measurement point
      measured_nominal_losses = convert((1/normalized_measured_efficiency - 1) * measured_mechanical_power, "W");
      if measured_nominal_losses <= ModelParams.MeasuredIronLosses
        id = ModelParams.errorID + "InvalidIronLosses";
        msg = bevutil1.CodeUtil.i18n("Iron losses cannot be higher than nominal losses.");

        throw(MException(id, msg))

      end  % if

      ModelParams.MeasuredNominalLosses = measured_nominal_losses;

      % -----------------------------------------------------------------------
      % The ratio of iron losses to nominal losses at efficiency measurement point.

      % measured_nominal_losses can be positive and very close to zero if efficiency is very close to 1, but
      % such a case is already excluded by checking as the ideal motor case above.
      % Thus, it is safe to use measured_nominal_losses in the denominator.
      normalized_iron_to_nominal_loss_ratio = ModelParams.MeasuredIronLosses / measured_nominal_losses;

      ModelParams.IronToNominalLossRatioPercent = 100 * normalized_iron_to_nominal_loss_ratio;

      % -----------------------------------------------------------------------
      % Copper losses at efficiency measurement point

      measured_copper_loss = convert(measured_nominal_losses - ModelParams.MeasuredIronLosses, "W");
      ModelParams.MeasuredCopperLosses = measured_copper_loss;

      % -----------------------------------------------------------------------
      % Coefficients for the power conversion loss models

      % Iron loss coefficient for iron loss model
      measured_iron_loss_coeff = convert(ModelParams.MeasuredIronLosses / ModelParams.MeasuredAngularSpeed^2, "W/rpm^2");
      ModelParams.MeasuredIronLossCoefficient = measured_iron_loss_coeff;

      % Copper loss coefficient for copper loss model
      measured_copper_loss_coeff = convert(measured_copper_loss / ModelParams.MeasuredTorque^2, "W/(N*m)^2");
      ModelParams.MeasuredCopperLossCoefficient = measured_copper_loss_coeff;

    end  % function

  end  % methods
end  % classdef
