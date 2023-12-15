function fig = MotorDriveUnit_plotEfficiency(nvpairs)
%% Makes a plot of power conversion efficiency/losses for motor drive unit
% This function takes arguments corresponding to block parameters
% of the following blocks:
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
% No that Motor & Drive (System Level) block supports
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

% Copyright 2021-2023 The MathWorks, Inc.

arguments
  % In road vehicle applications,
  % maximum motor speed is determined by vehicle top speed,
  % tire rolling radius, and reduction gear ratio. 
  nvpairs.MaxSpeed_rpm (1,1) double {mustBePositive} = 17000

  nvpairs.MaxTorque_Nm (1,1) double {mustBePositive} = 163
  nvpairs.MaxPower_kW (1,1) double {mustBePositive} = 53

  nvpairs.Efficiency_pct (1,1) double {mustBePositive} = 95
  nvpairs.Speed_measured_rpm (1,1) double {mustBeNonnegative} = 2000
  nvpairs.Torque_measured_Nm (1,1) double {mustBeNonnegative} = 50

  % In Motor & Drive block from Simscape Driveline,
  % iron loss, constant electrical loss, and rotor friction are not modelled,
  % i.e., they are 0. 
  nvpairs.IronToNominalLossRatio_pct (1,1) double {mustBeNonnegative} = 0.1
  nvpairs.FixedLoss_W (1,1) double {mustBeNonnegative} = 40
  nvpairs.RotorDamping_Nm_per_radps (1,1) double {mustBeNonnegative} = 0.05

  % Contour levels need 3 or more points for lower bound, upper bound,
  % and one or more points in between.
  nvpairs.ContourLevels_pct (1,:) double {mustBeNonnegative} = [1 60 80 90 92 94 96 97 98 99]

  nvpairs.PlotResolution (1,1) {mustBeInteger, mustBePositive} = 500
end

trq_max_Nm = nvpairs.MaxTorque_Nm;

spd_max_rpm = nvpairs.MaxSpeed_rpm;

power_max_W = 1000* nvpairs.MaxPower_kW;

eff_norm = nvpairs.Efficiency_pct/100;

spd_eff_rpm = nvpairs.Speed_measured_rpm;

trq_eff_Nm = nvpairs.Torque_measured_Nm;

% normalized
iron_to_nominal_loss_ratio = nvpairs.IronToNominalLossRatio_pct / 100;

loss_const_W = nvpairs.FixedLoss_W;

k_damp = nvpairs.RotorDamping_Nm_per_radps;

contour_levels = nvpairs.ContourLevels_pct;
assert(numel(contour_levels) > 2, ...
  "Contour levels need 3 or more elements, but " ...
  + "it has only " + numel(contour_levels) + " levels.")

plotResolution = nvpairs.PlotResolution;

%% Derived parameters

spd_eff_radps = spd_eff_rpm*2*pi/60;

% Mechanical power at efficiency measurement point
mechpow_eff = spd_eff_radps * trq_eff_Nm;

% Nominal loss (total loss at efficiency measurement point
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

fig = figure;  hold on
contourf(w_rpm_vec, trq_Nm_vec, eff, contour_levels, ShowText="on")
plot(w_rpm_vec, trq_max_envelope, LineWidth=3, Color="blue")
sct = scatter(spd_eff_rpm, trq_eff_Nm, "x");
sct.Marker = "x";
sct.LineWidth = 1;
sct.SizeData = 100;
sct.MarkerEdgeColor = "black";
xlim([0 spd_max_rpm])
ylim([0 trq_max_Nm])
xlabel("Speed (rpm)")
ylabel("Torque (Nm)")
title("Overall Efficiency of Motor Drive Unit (%)")

end
