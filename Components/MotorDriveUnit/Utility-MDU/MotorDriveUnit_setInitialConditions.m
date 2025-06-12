function MotorDriveUnit_setInitialConditions(NamValuePair)
%% Computes and sets initial conditions

% Copyright 2023-2025 The MathWorks, Inc.

arguments (Input)
  NamValuePair.Initial_LoadInertiaSpd_rpm (1,1) double = 0;
  NamValuePair.Initial_MotorDriveUnit_RotorSpd_rpm (1,1) double = 0;
  NamValuePair.Initial_MotorDriveUnit_Temperature_K (1,1) {mustBePositive} = 273.15 + 20
  NamValuePair.Initial_AmbientTemperature_K (1,1) {mustBePositive} = 273.15 + 20
  NamValuePair.DisplayMessage (1,1) logical = true
end  % arguments

dispMsg = NamValuePair.DisplayMessage;

if dispMsg
  disp("Setting initial conditions...")
end

loadInertiaSpd_rpm = NamValuePair.Initial_LoadInertiaSpd_rpm;
setValue("initial.loadInertiaSpd_rpm", loadInertiaSpd_rpm, dispMsg)

motorSpd_rpm = NamValuePair.Initial_MotorDriveUnit_RotorSpd_rpm;
setValue("initial.motorSpd_rpm", motorSpd_rpm, dispMsg)

Initial_MotorTemp_K = NamValuePair.Initial_MotorDriveUnit_Temperature_K;
setValue("initial.motorDriveUnit_Temperature_K", Initial_MotorTemp_K, dispMsg)

Initial_AmbTemp_K = NamValuePair.Initial_AmbientTemperature_K;
setValue("initial.ambientTemp_K", Initial_AmbTemp_K, dispMsg)

end  % function

function setValue(workspaceVarName, value, displayMessage)
%%

arguments (Input)
  workspaceVarName {mustBeTextScalar}
  value (1,1) double
  displayMessage (1,1) logical
end  % arguments

if displayMessage
  disp(workspaceVarName + " = " + value)
end  % if

evalin("base", workspaceVarName + " = " + value + ";");

end  % function
