function fig = MotorDriveUnit_BasicModelEfficiencyPlot(NameValuePair)
% To see what plot this function creates, run this function without any arguments.

% Copyright 2023-2025 The MathWorks, Inc.

arguments (Input)
  NameValuePair.MaxTorque (1,1) simscape.Value {LiteApp6.SimscapeUtility.mustBeSimscapeValuePositive} = simscape.Value(420, "N*m")
  NameValuePair.MaxSpeed (1,1) simscape.Value {LiteApp6.SimscapeUtility.mustBeSimscapeValuePositive} = simscape.Value(15000, "rpm")
  NameValuePair.MaxPower (1,1) simscape.Value {LiteApp6.SimscapeUtility.mustBeSimscapeValuePositive} = simscape.Value(220, "kW")

  NameValuePair.EfficiencyPercent (1,1) simscape.Value {LiteApp6.SimscapeUtility.mustBeSimscapeValuePositive} = simscape.Value(95, "1")
  NameValuePair.MeasuredSpeed (1,1) simscape.Value {LiteApp6.SimscapeUtility.mustBeSimscapeValueNonnegative} = simscape.Value(2000, "rpm")
  NameValuePair.MeasuredTorque (1,1) simscape.Value {LiteApp6.SimscapeUtility.mustBeSimscapeValueNonnegative} = simscape.Value(50, "N*m")

  % Motor & Drive block from Simscape Driveline does not include rotational damping,
  % but the Motor Drive Unit model can have a damping block in addition to
  % a Motor & Drive block.
  % In that case, we can pass the damping coefficient to this function
  % and get the more accurate plot of efficiency contour.
  % NameValuePair.RotorDamping_Nm_per_radps (1,1) double {mustBeNonnegative} = 0;
  % NameValuePair.RotorDamping (1,1) simscape.Value {LiteApp6.SimscapeUtility.mustBeSimscapeValueNonnegative} = simscape.Value(0.05, "N*m/(rad/s)")
  NameValuePair.RotorDamping (1,1) simscape.Value {LiteApp6.SimscapeUtility.mustBeSimscapeValueNonnegative} = simscape.Value(0, "N*m/(rad/s)")

  % Contour levels need 3 or more points for lower bound, upper bound,
  % and one or more points in between.
  NameValuePair.ContourLevelsPercent (1,:) simscape.Value {LiteApp6.SimscapeUtility.mustBeSimscapeValueNonnegative} = simscape.Value([1 60 80 90 92 94 96 97 98 99], "1")

  NameValuePair.PlotResolution (1,1) {mustBeInteger, mustBePositive} = 500

  NameValuePair.ParentAxes (1,:) matlab.graphics.axis.Axes {mustBeScalarOrEmpty}

  % These are valid only when ParentAxes is NOT specified.
  NameValuePair.Theme {mustBeMember(NameValuePair.Theme, ["light", "dark"])} = "light"
  NameValuePair.ThemeMode {mustBeMember(NameValuePair.ThemeMode, ["auto", "manual"])} = "auto"
end  % arguments

arguments (Output)
  fig (1,1) matlab.ui.Figure
end  % arguments

% In Motor & Drive block from Simscape Driveline,
% iron loss, constant electrical loss, and rotor friction are not modelled,
% i.e., they are 0. 
fig = MotorDriveUnit_EfficiencyPlot( ...
  ParentAxes = NameValuePair.ParentAxes, ...
  MaxTorque = NameValuePair.MaxTorque, ...
  MaxSpeed = NameValuePair.MaxSpeed, ...
  MaxPower = NameValuePair.MaxPower, ...
  EfficiencyPercent = NameValuePair.EfficiencyPercent, ...
  MeasuredSpeed = NameValuePair.MeasuredSpeed, ...
  MeasuredTorque = NameValuePair.MeasuredTorque, ...
  IronToNominalLossRatioPercent = simscape.Value(0, "1"), ...
  FixedLoss = simscape.Value(0, "W"), ...
  RotorDamping = NameValuePair.RotorDamping, ...
  ContourLevelsPercent = NameValuePair.ContourLevelsPercent, ...
  PlotResolution = NameValuePair.PlotResolution, ...
  Theme = NameValuePair.Theme, ...
  ThemeMode = NameValuePair.ThemeMode );

end  % function
