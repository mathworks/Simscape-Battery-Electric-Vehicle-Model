function MotorDriveUnit_setInitialConditions(NamValuePair)
%% Set initial conditions in the base workspace.

% Copyright 2023-2025 The MathWorks, Inc.

arguments (Input)
  NamValuePair.Initial_LoadInertiaSpeed (1,1) simscape.Value {simscape.mustBeCommensurateUnit(NamValuePair.Initial_LoadInertiaSpeed, "rad/s")} = simscape.Value(0, "rpm");
  NamValuePair.Initial_MotorDriveUnit_RotorSpd_rpm (1,1) double = 0;
  NamValuePair.Initial_MotorDriveUnit_Temperature_K (1,1) {mustBePositive} = 273.15 + 20
  NamValuePair.Initial_AmbientTemperature_K (1,1) {mustBePositive} = 273.15 + 20
  NamValuePair.DisplayMessage (1,1) logical = true
end  % arguments

dispMsg = NamValuePair.DisplayMessage;

if dispMsg
  disp("Setting initial conditions...")
end  % if

loadInertiaSpeed = NamValuePair.Initial_LoadInertiaSpeed;
setValue("initial.LoadInertiaSpeed", loadInertiaSpeed, dispMsg)

motorSpd_rpm = NamValuePair.Initial_MotorDriveUnit_RotorSpd_rpm;
setValue("initial.motorDriveUnit_RotorSpd_rpm", motorSpd_rpm, dispMsg)

Initial_MotorTemp_K = NamValuePair.Initial_MotorDriveUnit_Temperature_K;
setValue("initial.motorDriveUnit_Temperature_K", Initial_MotorTemp_K, dispMsg)

Initial_AmbTemp_K = NamValuePair.Initial_AmbientTemperature_K;
setValue("initial.ambientTemp_K", Initial_AmbTemp_K, dispMsg)

end  % function

function setValue(workspaceVarName, x, displayMessage)
arguments (Input)
  workspaceVarName (1,1) string
  x (1,1) {mustBeA(x, ["double" "simscape.Value"])}
  displayMessage (1,1) logical
end  % arguments

if class(x) == "simscape.Value"
  if displayMessage
    disp(workspaceVarName + " = " + value(x) + " (" + string(unit(x)) + ")" )
  end  % if
  cmd = workspaceVarName + " = simscape.Value(" + value(x) + ", """ + string(unit(x)) + """);";
else
  if displayMessage
    disp(workspaceVarName + " = " + x)
  end  % if
  cmd = workspaceVarName + " = " + x + ";";
end  % if

% The assignin command does not work with a struct field.
evalin("base", cmd)

end  % function
