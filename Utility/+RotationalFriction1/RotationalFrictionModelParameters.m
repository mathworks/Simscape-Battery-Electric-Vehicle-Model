classdef RotationalFrictionModelParameters < handle
  % Model parameters of rotational friction model
  %
  % The parameters of this class correspond to those in the Rotational Friction block in Simscape.
  %
  % To create an uninitialized instance, call this class without any options.
  % To create an instance initialized with default parameter values,
  % use the Initialize=true option.

  % Copyright 2025-2026 The MathWorks, Inc.

  properties

    % Public parameters of the friction torque model
    BreakawayTorque simscape.Value { simscape.mustBeCommensurateUnit(BreakawayTorque, "N*m"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } = simscape.Value(nan, "N*m")
    BreakawayVelocity simscape.Value { simscape.mustBeCommensurateUnit(BreakawayVelocity, "rad/s"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } = simscape.Value(nan, "rad/s")
    CoulombTorque simscape.Value { simscape.mustBeCommensurateUnit(CoulombTorque, "N*m"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } = simscape.Value(nan, "N*m")
    ViscousCoefficient simscape.Value { simscape.mustBeCommensurateUnit(ViscousCoefficient, "N*m*s/rad"), CodeUtil1.mustBeSimscapeValuePositiveOrNan } = simscape.Value(nan, "N*m*s/rad")

    % Derived parameters
    StribeckScaledTorque simscape.Value { simscape.mustBeCommensurateUnit(StribeckScaledTorque, "N*m") } = simscape.Value(nan, "N*m")
    StribeckThresholdVelocity simscape.Value { simscape.mustBeCommensurateUnit(StribeckThresholdVelocity, "rad/s") } = simscape.Value(nan, "rad/s")
    CoulombThresholdVelocity simscape.Value { simscape.mustBeCommensurateUnit(CoulombThresholdVelocity, "rad/s") } = simscape.Value(nan, "rad/s")

  end  % properties

  methods

    function ModelParams = RotationalFrictionModelParameters(NameValuePair)
      arguments (Input)
        NameValuePair.Initialization (1,1) logical = false
      end  % arguments

      if NameValuePair.Initialization
        resetPublicParameters(ModelParams)
        updateDerivedParameters(ModelParams)
      end  % if
    end  % function

    function resetPublicParameters(ModelParams)
      ModelParams.BreakawayTorque = simscape.Value(25, "N*m");
      ModelParams.BreakawayVelocity = simscape.Value(0.1, "rad/s");
      ModelParams.CoulombTorque = simscape.Value(20, "N*m");
      ModelParams.ViscousCoefficient = simscape.Value(0.001, "N*m*s/rad");
    end  % function

    function updateDerivedParameters(ModelParams)
      % These are the derived parameters of the equation-based models of the rotational friction model.
      ModelParams.StribeckScaledTorque = sqrt(2 * exp(1)) * (ModelParams.BreakawayTorque - ModelParams.CoulombTorque);
      ModelParams.StribeckThresholdVelocity = sqrt(2) * ModelParams.BreakawayVelocity;
      ModelParams.CoulombThresholdVelocity = ModelParams.BreakawayVelocity / 10;
    end  % function

  end  % methods
end  % classdef
