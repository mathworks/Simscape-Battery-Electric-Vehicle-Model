function MotorDriveUnit_setSimCase(NameValuePairs)
%% Sets up simulation
% This function sets up the followings:
% - Simulation stop time
% - Input signals
% - Initial conditions

% Copyright 2023-2025 The MathWorks, Inc.

arguments (Input)
  NameValuePairs.CaseName {mustBeTextScalar} = "Default"

  NameValuePairs.ModelName {mustBeTextScalar} = "MotorDriveUnit_TestModel"

  NameValuePairs.StopTime (1,1) {mustBePositive} = 10

  NameValuePairs.InputSystemPath {mustBeTextScalar} = "/Inputs"

  NameValuePairs.AxleClutchSwitch_BlockName {mustBeTextScalar} = "Axle clutch switch"
  NameValuePairs.AxleClutchSwitch_DataPoints (:,2) double = [0 0; 1 0]

  NameValuePairs.AxleSpeed_BlockName {mustBeTextScalar} = "Axle speed"
  NameValuePairs.AxleSpeed_DataPoints (:,3) double = [0 1 0]
  NameValuePairs.AxleSpeed_DeltaT (1,1) {mustBePositive} = 0.1

  NameValuePairs.AxleTorque_BlockName {mustBeTextScalar} = "Axle torque"
  NameValuePairs.AxleTorque_DataPoints (:,3) double = [0 1 0]
  NameValuePairs.AxleTorque_DeltaT (1,1) {mustBePositive} = 0.1

  NameValuePairs.MotorTorqueCommand_BlockName {mustBeTextScalar} = "Motor torque command"
  NameValuePairs.MotorTorqueCommand_DataPoints (:,3) double = [0 1 0]
  NameValuePairs.MotorTorqueCommand_DeltaT (1,1) {mustBePositive} = 0.1

  NameValuePairs.HeatFlowCommand_BlockName {mustBeTextScalar} = "Heat flow command"
  NameValuePairs.HeatFlowCommand_DataPoints (:,3) double = [0 1 0]
  NameValuePairs.HeatFlowCommand_DeltaT (1,1) {mustBePositive} = 0.1

  NameValuePairs.LoadInertia_kg_m2 (1,1) {mustBePositive} = 100*0.3^2
  NameValuePairs.LoadDamping_Nm_per_rpm (1,1) {mustBePositive} = 0.03

  NameValuePairs.GeartrainInertia_kg_m2 (1,1) {mustBePositive} = 15*0.3^2
  NameValuePairs.GeartrainDamping_Nm_per_rpm (1,1) {mustBePositive} = 0.001

  NameValuePairs.HVBattery_Voltage_V (1,1) {mustBePositive} = 340
  NameValuePairs.HVBattery_TerminalResistance_Ohm (1,1) {mustBePositive} = 0.01

  NameValuePairs.Initial_LoadInertiaSpd_rpm (1,1) double = 0;
  NameValuePairs.Initial_MotorDriveUnit_RotorSpd_rpm (1,1) double = 0;
  NameValuePairs.Initial_MotorDriveUnit_Temperature_K (1,1) {mustBePositive} = 273.15 + 20
  NameValuePairs.Initial_AmbientTemperature_K (1,1) {mustBePositive} = 273.15 + 20

  NameValuePairs.DisplayMessage (1,1) logical = true
end  % arguments

dispMsg = NameValuePairs.DisplayMessage;

if dispMsg
  disp("Setting up simulation...")
  disp("Simulation case: " + NameValuePairs.CaseName)
end  % if

mdl = NameValuePairs.ModelName;

if not(bdIsLoaded(mdl))
  load_system(mdl)
end  % if

t_end = NameValuePairs.StopTime;

if dispMsg
  disp("Setting simulation stop time to " + t_end + " sec.")
end  %if

set_param(mdl, StopTime = num2str(t_end));

if dispMsg
  disp("Setting block parameters...")
end  % if

inpSysPath = mdl + NameValuePairs.InputSystemPath;

AxleClutchSwitch_block_path = inpSysPath + "/" + NameValuePairs.AxleClutchSwitch_BlockName;
set_param(AxleClutchSwitch_block_path, dataPoints = mat2str(NameValuePairs.AxleClutchSwitch_DataPoints))

AxleSpeed_block_path = inpSysPath + "/" + NameValuePairs.AxleSpeed_BlockName;
set_param(AxleSpeed_block_path, dataPoints = mat2str(NameValuePairs.AxleSpeed_DataPoints))
set_param(AxleSpeed_block_path, deltaT = num2str(NameValuePairs.AxleSpeed_DeltaT))

AxleTorque_block_path = inpSysPath + "/" + NameValuePairs.AxleTorque_BlockName;
set_param(AxleTorque_block_path, dataPoints = mat2str(NameValuePairs.AxleTorque_DataPoints))
set_param(AxleTorque_block_path, deltaT = num2str(NameValuePairs.AxleTorque_DeltaT))

MotorTorqueCommand_block_path = inpSysPath + "/" + NameValuePairs.MotorTorqueCommand_BlockName;
set_param(MotorTorqueCommand_block_path, dataPoints = mat2str(NameValuePairs.MotorTorqueCommand_DataPoints))
set_param(MotorTorqueCommand_block_path, deltaT = num2str(NameValuePairs.MotorTorqueCommand_DeltaT))

HeatFlowCommand_block_path = inpSysPath + "/" + NameValuePairs.HeatFlowCommand_BlockName;
set_param(HeatFlowCommand_block_path, dataPoints = mat2str(NameValuePairs.HeatFlowCommand_DataPoints))
set_param(HeatFlowCommand_block_path, deltaT = num2str(NameValuePairs.HeatFlowCommand_DeltaT))

set_param(mdl + "/Mechanical Load/Load Inertia", inertia = num2str(NameValuePairs.LoadInertia_kg_m2))
set_param(mdl + "/Mechanical Load/Load Damper", D = num2str(NameValuePairs.LoadDamping_Nm_per_rpm))

set_param(mdl + "/Mechanical Load/Geartrain Inertia", inertia = num2str(NameValuePairs.GeartrainInertia_kg_m2))
set_param(mdl + "/Mechanical Load/Geartrain Damper", D = num2str(NameValuePairs.GeartrainDamping_Nm_per_rpm))

setValue("batteryHV.nominalVoltage_V", NameValuePairs.HVBattery_Voltage_V, NameValuePairs.DisplayMessage)

setValue("batteryHV.internalResistance_Ohm", NameValuePairs.HVBattery_TerminalResistance_Ohm, NameValuePairs.DisplayMessage)

MotorDriveUnit_setInitialConditions( ...
  Initial_LoadInertiaSpd_rpm = NameValuePairs.Initial_LoadInertiaSpd_rpm, ...
  Initial_MotorDriveUnit_RotorSpd_rpm = NameValuePairs.Initial_MotorDriveUnit_RotorSpd_rpm, ...
  Initial_MotorDriveUnit_Temperature_K = NameValuePairs.Initial_MotorDriveUnit_Temperature_K, ...
  Initial_AmbientTemperature_K = NameValuePairs.Initial_AmbientTemperature_K, ...
  DisplayMessage = NameValuePairs.DisplayMessage );

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
