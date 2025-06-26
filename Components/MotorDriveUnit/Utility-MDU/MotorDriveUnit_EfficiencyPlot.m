function fig = MotorDriveUnit_EfficiencyPlot(NameValuePair)
%% Makes a plot of power conversion efficiency/losses for motor drive unit
% To see what plot this function creates, run this function without any arguments.
%
% This function takes arguments corresponding to the block parameters of
% the following blocks:
%
%   - Motor & Drive block, from Simscape Driveline
%   - Motor & Drive (System Level) block, from Simscape Electrical
%
% and makes a plot of electric-to-mechanical power conversion efficiency map
% as a function of motor speed and torque.
%
% You can run this function without arguments,
% and it will create a plot using default argument values.
%
% Note that Motor & Drive (System Level) block supports
% various ways to accept block parameters, but
% this function makes a plot for it assuming the following case:
%
%   Electrical Torque
%     - Parameterized by: Maximum torque and power
%   Electrical Losses
%     - Parameterize losses by: Single efficiency measurement
%
% To make an efficiency plot for other cases
% in Motor & Drive (System Level) block,
% use the "Plot efficiency map" link in the block Description.

% Copyright 2021-2025 The MathWorks, Inc.

arguments (Input)
  NameValuePair.ParentAxes (1,:) matlab.graphics.axis.Axes {mustBeScalarOrEmpty}

  % In road vehicle applications,
  % maximum motor speed is determined by vehicle top speed,
  % tire rolling radius, and reduction gear ratio. 
  NameValuePair.MaxSpeed (1,1) simscape.Value {LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive} = simscape.Value(17000, "rpm")

  NameValuePair.MaxTorque (1,1) simscape.Value {LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive} = simscape.Value(163, "N*m")
  NameValuePair.MaxPower (1,1) simscape.Value {LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive} = simscape.Value(53, "kW")

  NameValuePair.EfficiencyPercent (1,1) simscape.Value {LiteApp5.SimscapeUtility.mustBeSimscapeValuePositive} = simscape.Value(95, "1")
  NameValuePair.MeasuredSpeed (1,1) simscape.Value {LiteApp5.SimscapeUtility.mustBeSimscapeValueNonnegative} = simscape.Value(2000, "rpm")
  NameValuePair.MeasuredTorque (1,1) simscape.Value {LiteApp5.SimscapeUtility.mustBeSimscapeValueNonnegative} = simscape.Value(50, "N*m")

  % In Motor & Drive block from Simscape Driveline,
  % iron loss, constant electrical loss, and rotor friction are not modelled,
  % i.e., they are 0. 
  NameValuePair.IronToNominalLossRatioPercent (1,1) simscape.Value {LiteApp5.SimscapeUtility.mustBeSimscapeValueNonnegative} = simscape.Value(0.1, "1")
  NameValuePair.FixedLoss (1,1) simscape.Value {LiteApp5.SimscapeUtility.mustBeSimscapeValueNonnegative} = simscape.Value(40, "W")
  NameValuePair.RotorDamping (1,1) simscape.Value {LiteApp5.SimscapeUtility.mustBeSimscapeValueNonnegative} = simscape.Value(0.05, "N*m/(rad/s)")

  % Contour levels need 3 or more points for lower bound, upper bound,
  % and one or more points in between.
  NameValuePair.ContourLevelsPercent (1,:) simscape.Value {LiteApp5.SimscapeUtility.mustBeSimscapeValueNonnegative} = simscape.Value([1 60 80 90 92 94 96 97 98 99], "1")

  NameValuePair.PlotResolution (1,1) {mustBeInteger, mustBePositive} = 500
end  % arguments

arguments (Output)
  fig (1,1) matlab.ui.Figure
end  % arguments

trq_max_Nm = value(NameValuePair.MaxTorque, "N*m");

spd_max_rpm = value(NameValuePair.MaxSpeed, "rpm");

power_max_W = value(NameValuePair.MaxPower, "W");

eff_norm = value(NameValuePair.EfficiencyPercent, "1") / 100;

spd_eff_rpm = value(NameValuePair.MeasuredSpeed, "rpm");

trq_eff_Nm = value(NameValuePair.MeasuredTorque, "N*m");

% normalized
iron_to_nominal_loss_ratio = value(NameValuePair.IronToNominalLossRatioPercent) / 100;

loss_const_W = value(NameValuePair.FixedLoss, "W");

k_damp = value(NameValuePair.RotorDamping, "N*m/(rad/s)");

contour_levels = value(NameValuePair.ContourLevelsPercent, "1");
assert(numel(contour_levels) > 2, ...
  "Contour levels need 3 or more elements, but " ...
  + "it has only " + numel(contour_levels) + " levels.")

plotResolution = NameValuePair.PlotResolution;

%% Derived parameters

spd_eff_radps = spd_eff_rpm*2*pi/60;

% Mechanical power at efficiency measurement point
mechpow_eff = spd_eff_radps * trq_eff_Nm;

% Nominal loss (total loss) at efficiency measurement point
nominal_loss_eff = (1/eff_norm - 1) * mechpow_eff;

% Iron loss at efficiency measurement point
iron_loss_eff = iron_to_nominal_loss_ratio * nominal_loss_eff;

% Copper loss at efficiency measurement point
copper_loss_eff = nominal_loss_eff - iron_loss_eff;

% Copper loss coefficient for copper loss model
k_copper = copper_loss_eff/trq_eff_Nm^2;

% Iron loss coefficient for iron loss model
k_iron = iron_loss_eff/spd_eff_radps^2;

%% Plot

% x-axis ... speed
w_rpm_vec = linspace(1, spd_max_rpm, plotResolution);
w_radps_vec = w_rpm_vec/60*2*pi;  % rad/s

% y-axis ... torque
trq_Nm_vec = linspace(0, trq_max_Nm, plotResolution)';

trq_max_envelope = min(power_max_W ./ w_radps_vec, trq_max_Nm);

% Calculation below is done in x-y mesh.
[w, trq] = meshgrid(w_radps_vec, trq_Nm_vec);

% A mask matrix with 1 for valid, 0 for invalid regions.
% This is later multiplied to the efficiency matrix
% to set regions over the maximum power to 0.
valid_region_mat = trq < trq_max_envelope;

% Fixed electrical loss
Pb = loss_const_W*ones(plotResolution, plotResolution);

kc = k_copper;  % Copper loss coefficient
ki = k_iron;  % Iron loss coefficient
kd = k_damp;  % Rotor friction coefficient

trq_elec = abs(trq) - kd*w;  % Steady state
Lc = kc*trq_elec.^2;  % Copper loss model
Li = ki*w.^2;  % Iron loss model
L_elec = Pb + Lc + Li;  % Total electrical loss
mech_power = trq.*w;  % Mechanical power
eff = 100 * abs(mech_power) ./(L_elec + abs(mech_power));  % Efficiency in percent

% Apply mask
eff = valid_region_mat .* eff;

if isfield(NameValuePair, "ParentAxes") && (class(NameValuePair.ParentAxes) == "matlab.graphics.axis.Axes")
  ax = NameValuePair.ParentAxes;
else
  fig = figure;
  ax = axes(fig);
end  % if

hold(ax, "on")
contourf(ax, w_rpm_vec, trq_Nm_vec, eff, contour_levels, ShowText="on")
plot(ax, w_rpm_vec, trq_max_envelope, LineWidth=3, Color="blue")
sct = scatter(ax, spd_eff_rpm, trq_eff_Nm); %, "x");
sct.Marker = "x";
sct.LineWidth = 1;
sct.SizeData = 100;
sct.MarkerEdgeColor = "black";
xlim(ax, [0 spd_max_rpm])
ylim(ax, [0 trq_max_Nm])
xlabel(ax, LiteApp5.Utility.i18n("Speed, $\omega$ (rpm)"), Interpreter="latex")
ylabel(ax, LiteApp5.Utility.i18n("Torque, $\tau$ (Nm)"), Interpreter="latex")
title(ax, LiteApp5.Utility.i18n("Overall Efficiency of Motor Drive Unit (%)"))

end  % function
