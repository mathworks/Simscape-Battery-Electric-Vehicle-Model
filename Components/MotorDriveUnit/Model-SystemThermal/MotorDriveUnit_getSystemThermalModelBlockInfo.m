function info = MotorDriveUnit_getSystemThermalModelBlockInfo(fullpathToBlock)
%% Collects block parameter values from Motor & Drive (System Level) block
% This function takes full block path to the Motor & Drive (System Level) block from
% Simscape Electrical, reads block parameters, and returns them in a struct.
% First load or open a Simulink model containing the Motor & Drive (System Level) block,
% and pass the full block path of the block to this function.
%
% Calling this function with no argument uses the currently selected block
% in Simulink model file.
% Open Simulink model, select the Motor & Drive (System Level) block,
% and run this function to collect information.

% Copyright 2023-2025 The MathWorks, Inc.

arguments (Input)
  fullpathToBlock {mustBeText} = gcb
end  % arguments

arguments (Output)
  info (1,1) struct
end  % arguments

errorID = "MotorDriveUnit_getSystemThermalModelBlockInfo:";

% ================
% Block parameters

% Maximum torque
info.MaxTorque = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(fullpathToBlock, "torque_max");

% Maximum power
info.MaxPower = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(fullpathToBlock, "power_max");

% Torque control time constant, Tc
info.ResponseTime = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(fullpathToBlock, "Tc");

% Motor and driver overall efficiency (percent)
info.EfficiencyPercent = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(fullpathToBlock, "eff");

% Speed at which efficiency is measured
info.MeasuredSpeed = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(fullpathToBlock, "w_eff");

% Torque at which efficiency is measured
info.MeasuredTorque = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(fullpathToBlock, "T_eff");

% Iron losses at measurement speed
info.IronLoss = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(fullpathToBlock, "Piron");

% Fixed losses independent of torque and speed
info.FixedLoss = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(fullpathToBlock, "Pbase");

% External supply series resistance is 0 and not used.

% Rotor inertia
info.RotorInertia = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(fullpathToBlock, "J");

% Rotor damping
info.RotorDamping = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(fullpathToBlock, "lam");

% Initial rotor speed
info.InitialRotorSpeed = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(fullpathToBlock, "speed0");

% Temperature dependence parameters
%
% - Resistance temperature coefficient: 3.93e-3 "1/K"
% - Measurement temperature: 25 "degC"
%
% are kept at default values.
%
% For more information see "Thermal Model for Actuator Blocks" section
% in the documentation
% "Simulating Thermal Effects in Rotational and Translational Actuators".
% https://www.mathworks.com/help/sps/ug/simulating-thermal-effects-in-rotational-and-translational-actuators.html#btczw4r-3

% Thermal mass
info.ThermalMass = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(fullpathToBlock, "thermal_mass");

% Initial temperature
info.InitialTemperature = bev1mus.ModelUtil.getSimscapeValueFromBlockParameter(fullpathToBlock, "initial_temperature");

% ===============
% Additional data
maxPower_kW = value(info.MaxPower, "kW");
eff_norm = value(info.EfficiencyPercent, "1") / 100;
spd_meas_radps = value(info.MeasuredSpeed, "rad/s");
trq_meas_Nm = value(info.MeasuredTorque, "N*m");
iron_loss_meas_W = value(info.IronLoss, "W");

% Mechanical power at efficiency measurement point
mechpow_eff = spd_meas_radps * trq_meas_Nm;
mechpow_meas_kW = mechpow_eff / 1000;
info.MeasuredMechanicalPower = simscape.Value(mechpow_meas_kW, "kW");
assert( mechpow_meas_kW < maxPower_kW, ...
  errorID + "InvalidPower", ...
  bev1mus.CodeUtil.i18n("Power at efficiency measurement speed must be smaller than maximum power."))

% Nominal loss (total loss) at efficiency measurement point
nominal_loss_meas_W = (1/eff_norm - 1) * mechpow_eff;
info.MeasuredNominalLoss = simscape.Value(nominal_loss_meas_W, "W");

iron_to_nominal_loss_ratio = iron_loss_meas_W / nominal_loss_meas_W;
info.IronToNominalLossRatioPercent = simscape.Value(iron_to_nominal_loss_ratio * 100, "1");

% Copper loss at efficiency measurement point
copper_loss_meas_W = nominal_loss_meas_W - iron_loss_meas_W;
info.MeasuredCopperLoss = simscape.Value(copper_loss_meas_W, "W");

end  % function
