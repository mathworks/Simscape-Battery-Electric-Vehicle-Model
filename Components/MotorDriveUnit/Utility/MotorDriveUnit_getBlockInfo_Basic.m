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
% By default, the data are computed by assuming that
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
  nvpairs.IronLossToNominalLossRatio (1,1) double {mustBeNonnegative} = 0.1;
end

% Collect mask workspace variables.
% They have been evaluated.
% See the documentation for Simulink.VariableUsage.
maskVars = get_param(fullpathToBlock, "MaskWSVariables");
varNames = string({maskVars.Name});
varValues = {maskVars.Value};

getPar = @(varName) varValues{varNames == varName};

% Block parameters can have physical units.
% To use correct units, first get the value and unit of a parameter
% and build a Simscape value object using sscVal defined here:
sscVal = @(varName) simscape.Value(getPar(varName), getPar(varName + "_unit"));
% Then obtain the value in the expected unit using the value function.

% ================
% Block parameters

% Maximum torque
sv = sscVal("torque_max");
info.MaxTorque_Nm = value(sv, "N*m");

% Maximum power
sv = sscVal("power_max");
info.MaxPower_kW = value(sv, "kW");

% Torque control time constant, Tc
sv = sscVal("Tc");
info.ResponseTime_s = value(sv, "s");

% Motor and driver overall efficiency (percent)
% No unit is associated. Directly get the value.
info.Efficiency_pct = getPar("eff");
eff_norm = info.Efficiency_pct / 100;

% Speed at which efficiency is measured
sv = sscVal("w_eff");
spd_eff_rpm = value(sv, "rpm");
info.SpeedAtEfficiencyMeasurement_rpm = spd_eff_rpm;
spd_eff_radps = spd_eff_rpm*2*pi/60;

% Torque at which efficiency is measured
sv = sscVal("T_eff");
trq_eff_Nm = value(sv, "N*m");
info.TorqueAtEfficiencyMeasurement_Nm = trq_eff_Nm;

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
mechpow_eff = spd_eff_radps * trq_eff_Nm;
info.MechanicalPowerAtEfficiencyMeasurement_kW = mechpow_eff / 1000;
assert( info.MechanicalPowerAtEfficiencyMeasurement_kW < info.MaxPower_kW, ...
  "Power at efficiency measurement speed must be smaller than maximum power.")

% Nominal loss (total loss) at efficiency measurement point
nominal_loss_eff = (1/eff_norm - 1) * mechpow_eff;
info.NominalLossAtEfficiencyMeasurement_W = nominal_loss_eff;

iron_to_nominal_loss_ratio = nvpairs.IronLossToNominalLossRatio;
% Iron losses at measurement speed, Piron
iron_loss_eff = iron_to_nominal_loss_ratio * nominal_loss_eff;
info.IronLossAtEfficiencyMeasurement_W = iron_loss_eff;

% Copper loss at efficiency measurement point
info.CopperLossAtEfficiencyMeasurement_W = nominal_loss_eff - iron_loss_eff;

end  % function
