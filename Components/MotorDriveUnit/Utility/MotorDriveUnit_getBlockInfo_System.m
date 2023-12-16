function info = MotorDriveUnit_getBlockInfo_System(fullpathToBlock)
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

% Copyright 2023 The MathWorks, Inc.

arguments
  fullpathToBlock {mustBeText} = gcb
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

% Iron losses at measurement speed
sv = getSimscapeValueFromBlockParameter(fullpathToBlock, "Piron");
iron_loss_meas_W = value(sv, "W");
info.IronLoss_measured_W = iron_loss_meas_W;

% Fixed losses independent of torque and speed
sv = getSimscapeValueFromBlockParameter(fullpathToBlock, "Pbase");
fixed_loss_measurement_W = value(sv, "W");
info.FixedLoss_W = fixed_loss_measurement_W;

% External supply series resistance is 0 and not used.

% Rotor inertia
sv = getSimscapeValueFromBlockParameter(fullpathToBlock, "J");
rotor_inertia_kg_m2 = value(sv, "kg*m^2");
info.RotorInertia_kg_m2 = rotor_inertia_kg_m2;

% Rotor damping
sv = getSimscapeValueFromBlockParameter(fullpathToBlock, "lam");
damp_Nm_per_radps = value(sv, "N*m/(rad/s)");
info.RotorDamping_Nm_per_radps = damp_Nm_per_radps;

% Initial rotor speed
sv = getSimscapeValueFromBlockParameter(fullpathToBlock, "speed0");
initial_rotor_speed_rpm = value(sv, "rpm");
info.InitialRotorSpeed_rpm = initial_rotor_speed_rpm;

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
sv = getSimscapeValueFromBlockParameter(fullpathToBlock, "thermal_mass");
thermal_mass_J_per_K = value(sv, "J/K");
info.ThermalMass_J_per_K = thermal_mass_J_per_K;

% Initial temperature
sv = getSimscapeValueFromBlockParameter(fullpathToBlock, "initial_temperature");
initial_temperature_degC = value(sv, "degC");
info.Initial_Temperature_degC = initial_temperature_degC;

% ===============
% Additional data

% Mechanical power at efficiency measurement point
mechpow_eff = spd_meas_radps * trq_meas_Nm;
mechpow_meas_kW = mechpow_eff / 1000;
info.MechanicalPower_measured_kW = mechpow_meas_kW;
assert( mechpow_meas_kW < maxPower_kW, ...
  "Power at efficiency measurement speed must be smaller than maximum power.")

% Nominal loss (total loss) at efficiency measurement point
nominal_loss_meas_W = (1/eff_norm - 1) * mechpow_eff;
info.NominalLoss_measured_W = nominal_loss_meas_W;

iron_to_nominal_loss_ratio = iron_loss_meas_W / nominal_loss_meas_W;
info.IronToNominalLossRatio_pct = iron_to_nominal_loss_ratio * 100;

% Copper loss at efficiency measurement point
copper_loss_meas_W = nominal_loss_meas_W - iron_loss_meas_W;
info.CopperLoss_measured_W = copper_loss_meas_W;

end  % function
