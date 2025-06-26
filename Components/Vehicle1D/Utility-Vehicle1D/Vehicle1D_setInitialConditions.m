function Vehicle1D_setInitialConditions(nvpairs)
%% Computes and sets initial conditions

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.Initial_LoadInertiaSpd_rpm (1,1) double = 0;
  nvpairs.Initial_VehicleSpeed_kph (1,1) double = 0;
  nvpairs.DisplayMessage (1,1) logical = true
end

dispMsg = nvpairs.DisplayMessage;

if dispMsg
  disp("Setting initial conditions...")
end

loadInertiaSpd_rpm = nvpairs.Initial_LoadInertiaSpd_rpm;
setValue("initial.loadInertiaSpd_rpm", loadInertiaSpd_rpm, dispMsg)

vehicle_speed_kph = nvpairs.Initial_VehicleSpeed_kph;
setValue("initial.vehicle_speed_kph", vehicle_speed_kph, dispMsg)

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
