function info = MotorDriveUnit_getBasicModelBlockInfo(fullpathToBlock, NameValuePair)
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

% Copyright 2021-2025 The MathWorks, Inc.

arguments (Input)
  fullpathToBlock {mustBeText} = gcb
  NameValuePair.IronToNominalLossRatioPercent (1,1) double {mustBeNonnegative} = 10;
end  % arguments

arguments (Output)
  info (1,1) struct
end  % arguments

errorID = "MotorDriveUnit_getBasicModelBlockInfo:";

% ================
% Block parameters

% Maximum torque
info.MaxTorque = ModelTool2.getSimscapeValueFromBlockParameter(fullpathToBlock, "torque_max");

% Maximum power
info.MaxPower =ModelTool2.getSimscapeValueFromBlockParameter(fullpathToBlock, "power_max");

% Torque control time constant, Tc
info.ResponseTime = ModelTool2.getSimscapeValueFromBlockParameter(fullpathToBlock, "Tc");

% Motor and driver overall efficiency (percent)
info.EfficiencyPercent = ModelTool2.getSimscapeValueFromBlockParameter(fullpathToBlock, "eff");

% Speed at which efficiency is measured
info.MeasuredSpeed = ModelTool2.getSimscapeValueFromBlockParameter(fullpathToBlock, "w_eff");

% Torque at which efficiency is measured
info.MeasuredTorque = ModelTool2.getSimscapeValueFromBlockParameter(fullpathToBlock, "T_eff");

% ===============
% Additional data
maxPower_kW = value(info.MaxPower, "kW");
spd_meas_radps = value(info.MeasuredSpeed, "rad/s");
trq_meas_Nm = value(info.MeasuredTorque, "N*m");
eff_norm = value(info.EfficiencyPercent, "1") / 100;

% Mechanical power at efficiency measurement point
mechpow_eff = spd_meas_radps * trq_meas_Nm;
mechpow_meas_kW = mechpow_eff / 1000;
info.MechanicalPower_measurement_kW = mechpow_meas_kW;
assert( mechpow_meas_kW < maxPower_kW, ...
  errorID + "InvalidPower", ...
  CodeTool1.i18n("Power at efficiency measurement speed must be smaller than maximum power."))

% Nominal loss (total loss) at efficiency measurement point
nominal_loss_meas_W = (1/eff_norm - 1) * mechpow_eff;
info.MeasuredNominalLoss = simscape.Value(nominal_loss_meas_W, "W");

iron_to_nominal_loss_ratio = NameValuePair.IronToNominalLossRatioPercent / 100;
% Iron losses at measurement speed, Piron
iron_loss_meas_W = iron_to_nominal_loss_ratio * nominal_loss_meas_W;
info.MeasuredIronLoss = simscape.Value(iron_loss_meas_W, "W");

% Copper loss at efficiency measurement point
copper_loss_meas_W = nominal_loss_meas_W - iron_loss_meas_W;
info.MeasuredCopperLoss = simscape.Value(copper_loss_meas_W, "W");

end  % function
