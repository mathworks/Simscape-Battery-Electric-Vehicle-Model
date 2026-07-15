classdef AbstractMotorEfficiencyAppParameters
  % Properties for app parameters.
  %
  % Use this class to conveniently define struct fields that are used as app parameters.
  % See the app description for an example use.

  % Copyright 2026 The MathWorks, Inc.

  properties

    % -------------------------------------------------------------------------
    % Parameters

    % How to set maximum angular speed of motor, "auto" or "specify".
    % The abstract motor model and the Motor & Drive blocks do not have
    % a parameter for the maximum motor speed.
    % However, the max speed may be determined by system-level requirements.
    % For example, in road-vehicle applications, the max motor speed is determined by
    % vehicle top speed, tire rolling radius, and reduction gear ratio.
    MaxAngularSpeedMode (1,1) string {mustBeMember(MaxAngularSpeedMode, ["auto", "specify"])} = "auto"

    % Maximum angular speed of motor.
    MaxAngularSpeed (1,1) simscape.Value ...
      { simscape.mustBeCommensurateUnit(MaxAngularSpeed, "rad/s"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(11000, "rpm")

    % Maximum torque of motor.
    MaxTorque simscape.Value ...
      { simscape.mustBeCommensurateUnit(MaxTorque, "N*m"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(230, "N*m")

    % Maximum power of motor.
    MaxPower simscape.Value ...
      { simscape.mustBeCommensurateUnit(MaxPower, "kW"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(110, "kW")

    % Overall power conversion efficiency in percent.
    OverallEfficiencyPercent double ...
      { mustBeInRange(OverallEfficiencyPercent, 0, 100) } ...
      = 97  %#ok<MUSTINRANGE> mustBeBetween is not available in R2024b.

    % Angular speed at which power conversion efficiency was measured.
    MeasuredAngularSpeed simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredAngularSpeed, "rpm"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(2800, "rpm")

    % Torque at which power conversion efficiency was measured.
    MeasuredTorque simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredTorque, "N*m"), bevutil1.CodeUtil.mustBeSimscapeValuePositiveOrNan } ...
      = simscape.Value(80, "N*m")

    % Iron (core) losses measured at efficiency measurement point.
    % - Hysteresis and eddy current losses.
    % - Primarily voltage/frequency dependent.
    MeasuredIronLosses simscape.Value ...
      { simscape.mustBeCommensurateUnit(MeasuredIronLosses, "W"), bevutil1.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(70, "W")

    % Fixed losses over all operating region, independent of efficiency measurement point.
    FixedLosses simscape.Value ...
      { simscape.mustBeCommensurateUnit(FixedLosses, "W"), bevutil1.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(30, "W")

    % Rotational friction losses at motor rotor.
    RotorDampingCoefficient simscape.Value ...
      { simscape.mustBeCommensurateUnit(RotorDampingCoefficient, "N*m/rpm"), bevutil1.CodeUtil.mustBeSimscapeValueNonnegativeOrNan } ...
      = simscape.Value(0.03, "N*m/rpm")

    % -------------------------------------------------------------------------
    % Plot customization

    % A switch to automatically set plot range, "on" or "off".
    PlotAutoRange matlab.lang.OnOffSwitchState = "on"

    % Plot upper bound of motor angular speed.
    PlotAngularSpeedUpperBound simscape.Value ...
      { mustBeScalarOrEmpty, simscape.mustBeCommensurateUnit(PlotAngularSpeedUpperBound, "rad/s") } ...
      = simscape.Value(12000, "rpm")

    % Plot upper bound of motor torque.
    PlotTorqueUpperBound simscape.Value ...
      { mustBeScalarOrEmpty, simscape.mustBeCommensurateUnit(PlotTorqueUpperBound, "N*m") } ...
      = simscape.Value(240, "N*m")

    % Array of efficiency contour level values in percent.
    % Contour levels need 3 or more points for lower bound, upper bound,
    % and one or more points in between.
    PlotContourLevelsPercent (1,:) double {mustBeNonnegative} = [0 70 80 90 99]

  end  % properties
end  % classdef
