classdef RotationalFrictionTorqueAppParameters

  % Copyright 2026 The MathWorks, Inc.

  properties

    BreakawayTorque (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(BreakawayTorque, "N*m"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(25, "N*m")

    BreakawayVelocity (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(BreakawayVelocity, "rad/s"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(0.1, "rad/s")

    CoulombTorque (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(CoulombTorque, "N*m"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(20, "N*m")

    ViscousCoefficient (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(ViscousCoefficient, "N*m*s/rad"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(0.001, "N*m*s/rad")

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

  end  % properties
end  % classdef
