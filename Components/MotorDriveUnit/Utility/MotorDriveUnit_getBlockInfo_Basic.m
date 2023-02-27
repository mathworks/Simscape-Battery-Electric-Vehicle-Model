function info = MotorDriveUnit_getBlockInfo_Basic(fullpathToBlock, nvpairs)
%% Collects block parameter values from Motor & Drive block
%
% OVERVIEW
%
% This function takes full block path to the Motor & Drive block from
% Simscape Driveline, reads block parameters, and returns them in a struct.
% First load or open a Simulink model containing the Motor & Drive block,
% and pass the full block path of the block to this function.
%
% Calling this function with no argument uses the currently selected block
% in Simulink model file. Open Simulink model, select the Motor & Drive block,
% and run this function to collect information.
%
% ADDITINAL DATA
%
% In addition to reading parameters from Motor & Drive block,
% this function calculates and returns additional data
% (mechanical power, copper loss, iron loss, and nominal loss)
% at efficiency measurement point.
%
% By default, data are computed by assuming that
% the ratio of iron loss to nominal loss
% at efficiency measurement speed is 10 percent.
% You can specify the ratio (in percent) by passing a value to this function
% and get the corresponding data.
%
% The absolute value of iron loss can be used as
% "Iron losses at measurement speed" parameter of
% Motor & Drive (System Level) block in Simscape Electrical.

% Copyright 2021-2023 The MathWorks, Inc.

arguments
  fullpathToBlock {mustBeText} = gcb
  nvpairs.IronToNominalLossRatio_pct (1,1) double {mustBeNonnegative} = 10;
end

% ================
% Block parameters

% Maximum torque
sv = getSimscapeValueFromBlockParameter(fullpathToBlock, "torque_max");
maxTorque_Nm = value(sv, "N*m");
info.MaxTorque_Nm = maxTorque_Nm;

% Maximum power
sv = getSimscapeValueFromBlockParameter(fullpathToBlock, "power_max");
maxPower_kW = value(sv, "kW");
info.MaxPower_kW = maxPower_kW;

% Torque control time constant, Tc
sv = getSimscapeValueFromBlockParameter(fullpathToBlock, "Tc");
info.ResponseTime_s = value(sv, "s");

% Motor and driver overall efficiency (percent)
% No unit is associated to this block parameter.
sv = getSimscapeValueFromBlockParameter(fullpathToBlock, "eff");
% Get the value by specifying "1" for unit.
eff_pct = value(sv, "1");
info.Efficiency_pct = eff_pct;
eff_norm = eff_pct / 100;

% Speed at which efficiency is measured
sv = getSimscapeValueFromBlockParameter(fullpathToBlock, "w_eff");
spd_meas_rpm = value(sv, "rpm");
info.Speed_measured_rpm = spd_meas_rpm;
spd_meas_radps = spd_meas_rpm*2*pi/60;

% Torque at which efficiency is measured
sv = getSimscapeValueFromBlockParameter(fullpathToBlock, "T_eff");
trq_meas_Nm = value(sv, "N*m");
info.Torque_measured_Nm = trq_meas_Nm;

%{
% Thermal port
info.thermal = getPar("thermal_port");

if info.thermal == simscape.enum.thermaleffects.model
  sv = sscVal("temperature");
  info.Initial_Temperature_K = value(sv, "K");
end
%}

% ===============
% Additional data

% Mechanical power at efficiency measurement point
mechpow_eff = spd_meas_radps * trq_meas_Nm;
mechpow_meas_kW = mechpow_eff / 1000;
info.MechanicalPower_measurement_kW = mechpow_meas_kW;
assert( mechpow_meas_kW < maxPower_kW, ...
  "Power at efficiency measurement speed must be smaller than maximum power.")

% Nominal loss (total loss) at efficiency measurement point
nominal_loss_meas_W = (1/eff_norm - 1) * mechpow_eff;
info.NominalLoss_measured_W = nominal_loss_meas_W;

iron_to_nominal_loss_ratio = nvpairs.IronToNominalLossRatio_pct / 100;
% Iron losses at measurement speed, Piron
iron_loss_meas_W = iron_to_nominal_loss_ratio * nominal_loss_meas_W;
info.IronLoss_measured_W = iron_loss_meas_W;

% Copper loss at efficiency measurement point
copper_loss_meas_W = nominal_loss_meas_W - iron_loss_meas_W;
info.CopperLoss_measured_W = copper_loss_meas_W;

end  % function
