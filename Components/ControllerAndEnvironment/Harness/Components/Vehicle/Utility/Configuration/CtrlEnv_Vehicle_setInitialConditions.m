function CtrlEnv_Vehicle_setInitialConditions(nvpairs)
%% Computes and sets initial conditions
% This function updates variables in the base workspace.
% Model must use those variables.

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.Initial_VehicleSpeed_kph (1,1) double = 0
  nvpairs.Initial_MotorTemperature_K (1,1) {mustBePositive} = 273.15 + 20
  nvpairs.Initial_MotorAmbientTemperature_K (1,1) {mustBePositive} = 273.15 + 20
  nvpairs.Initial_BatteryTemperature_K (1,1) {mustBePositive} = 273.15 + 20
  nvpairs.Initial_BatteryAmbientTemperature_K (1,1) {mustBePositive} = 273.15 + 20
  nvpairs.TireRollingRadius_m (1,1) double {mustBePositive} = 0.35
  nvpairs.GearRatio (1,1) double {mustBePositive} = 9.1
  nvpairs.DisplayMessage (1,1) logical = true
end

dispMsg = nvpairs.DisplayMessage;

if dispMsg
  disp("Setting initial conditions...")
end

vehSpd_kph = nvpairs.Initial_VehicleSpeed_kph;
setValue("initial.VehicleSpeed_kph", vehSpd_kph, dispMsg)

vehInertiaSpd_rpm = CtrlEnv_Vehicle_getMotorSpeedFromVehicleSpeed( ...
    VehicleSpeed_kph = vehSpd_kph, ...
    TireRollingRadius_m = nvpairs.TireRollingRadius_m, ...
    GearRatio = nvpairs.GearRatio );
setValue("initial.VehicleInertiaSpd_rpm", vehInertiaSpd_rpm, dispMsg)

motorTemp_K = nvpairs.Initial_MotorTemperature_K;
setValue("initial.MotorTemperature_K", motorTemp_K, dispMsg)

motorAmbientTemp_K = nvpairs.Initial_MotorAmbientTemperature_K;
setValue("initial.MotorAmbientTemperature_K", motorAmbientTemp_K, dispMsg)

batteryTemp_K = nvpairs.Initial_BatteryTemperature_K;
setValue("initial.BatteryTemperature_K", batteryTemp_K, dispMsg)

batteryAmbientTemp_K = nvpairs.Initial_BatteryAmbientTemperature_K;
setValue("initial.BatteryAmbientTemperature_K", batteryAmbientTemp_K, dispMsg)

end  % function

function setValue(workspaceVarName, value, displayMessage)
arguments
  workspaceVarName {mustBeTextScalar}
  value (1,1) double
  displayMessage (1,1) logical
end
if displayMessage
  disp(workspaceVarName + " = " + value)
end
evalin("base", workspaceVarName + " = " + value + ";");
end  % function
