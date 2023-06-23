function MotorDriveUnit_setInitialConditions(nvpairs)
%% Computes and sets initial conditions

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.Initial_LoadInertiaSpd_rpm (1,1) double = 0;
  nvpairs.Initial_MotorDriveUnit_RotorSpd_rpm (1,1) double = 0;
  nvpairs.Initial_MotorDriveUnit_Temperature_K (1,1) {mustBePositive} = 273.15 + 20
  nvpairs.Initial_AmbientTemperature_K (1,1) {mustBePositive} = 273.15 + 20
  nvpairs.DisplayMessage (1,1) logical = true
end

dispMsg = nvpairs.DisplayMessage;

if dispMsg
  disp("Setting initial conditions...")
end

loadInertiaSpd_rpm = nvpairs.Initial_LoadInertiaSpd_rpm;
setValue("initial.loadInertiaSpd_rpm", loadInertiaSpd_rpm, dispMsg)

motorSpd_rpm = nvpairs.Initial_MotorDriveUnit_RotorSpd_rpm;
setValue("initial.motorSpd_rpm", motorSpd_rpm, dispMsg)

Initial_MotorTemp_K = nvpairs.Initial_MotorDriveUnit_Temperature_K;
setValue("initial.motorDriveUnit_Temperature_K", Initial_MotorTemp_K, dispMsg)

Initial_AmbTemp_K = nvpairs.Initial_AmbientTemperature_K;
setValue("initial.ambientTemp_K", Initial_AmbTemp_K, dispMsg)

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
