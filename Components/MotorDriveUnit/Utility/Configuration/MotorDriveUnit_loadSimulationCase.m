function MotorDriveUnit_loadSimulationCase(nvpairs)
%% Sets up simulation
% This function sets up the followings:
% - Simulation stop time
% - Input signals
% - Initial conditions
%
% Model must be loaded for this function to work.

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.CaseName {mustBeTextScalar} = "Default"

  nvpairs.ModelName {mustBeTextScalar} = "MotorDriveUnit_harness_model"

  nvpairs.StopTime (1,1) {mustBePositive} = 10

  nvpairs.InputSystemPath {mustBeTextScalar} = "/Inputs"

  nvpairs.AxleClutchSwitch_BlockName {mustBeTextScalar} = "Axle clutch switch"
  nvpairs.AxleClutchSwitch_DataPoints (:,2) double = [0 0; 1 0]

  nvpairs.AxleSpeed_BlockName {mustBeTextScalar} = "Axle speed"
  nvpairs.AxleSpeed_DataPoints (:,3) double = [0 1 0]
  nvpairs.AxleSpeed_DeltaT (1,1) {mustBePositive} = 0.1

  nvpairs.AxleTorque_BlockName {mustBeTextScalar} = "Axle torque"
  nvpairs.AxleTorque_DataPoints (:,3) double = [0 1 0]
  nvpairs.AxleTorque_DeltaT (1,1) {mustBePositive} = 0.1

  nvpairs.MotorTorqueCommand_BlockName {mustBeTextScalar} = "Motor torque command"
  nvpairs.MotorTorqueCommand_DataPoints (:,3) double = [0 1 0]
  nvpairs.MotorTorqueCommand_DeltaT (1,1) {mustBePositive} = 0.1

  nvpairs.HeatFlowCommand_BlockName {mustBeTextScalar} = "Heat flow command"
  nvpairs.HeatFlowCommand_DataPoints (:,3) double = [0 1 0]
  nvpairs.HeatFlowCommand_DeltaT (1,1) {mustBePositive} = 0.1

  nvpairs.LoadInertia_kg_m2 (1,1) {mustBePositive} = 100*0.3^2
  nvpairs.LoadDamping_Nm_per_rpm (1,1) {mustBePositive} = 0.03

  nvpairs.GeartrainInertia_kg_m2 (1,1) {mustBePositive} = 15*0.3^2
  nvpairs.GeartrainDamping_Nm_per_rpm (1,1) {mustBePositive} = 0.001

  nvpairs.HVBattery_Voltage_V (1,1) {mustBePositive} = 340
  nvpairs.HVBattery_TerminalResistance_Ohm (1,1) {mustBePositive} = 0.01

  nvpairs.Initial_LoadInertiaSpd_rpm (1,1) double = 0;
  nvpairs.Initial_MotorDriveUnit_RotorSpd_rpm (1,1) double = 0;
  nvpairs.Initial_MotorDriveUnit_Temperature_K (1,1) {mustBePositive} = 273.15 + 20
  nvpairs.Initial_AmbientTemperature_K (1,1) {mustBePositive} = 273.15 + 20

  nvpairs.DisplayMessage (1,1) logical = true
end

dispMsg = nvpairs.DisplayMessage;

if dispMsg
  disp("Setting up simulation...")
  disp("Simulation case: " + nvpairs.CaseName)
end

mdl = nvpairs.ModelName;

t_end = nvpairs.StopTime;

if dispMsg
  disp("Setting simulation stop time to " + t_end + " sec.")
end

set_param(mdl, StopTime = num2str(t_end));

if dispMsg
  disp("Setting block parameters...")
end

inpSysPath = mdl + nvpairs.InputSystemPath;

AxleClutchSwitch_block_path = inpSysPath + "/" + nvpairs.AxleClutchSwitch_BlockName;
set_param(AxleClutchSwitch_block_path, dataPoints = mat2str(nvpairs.AxleClutchSwitch_DataPoints))

AxleSpeed_block_path = inpSysPath + "/" + nvpairs.AxleSpeed_BlockName;
set_param(AxleSpeed_block_path, dataPoints = mat2str(nvpairs.AxleSpeed_DataPoints))
set_param(AxleSpeed_block_path, deltaT = num2str(nvpairs.AxleSpeed_DeltaT))

AxleTorque_block_path = inpSysPath + "/" + nvpairs.AxleTorque_BlockName;
set_param(AxleTorque_block_path, dataPoints = mat2str(nvpairs.AxleTorque_DataPoints))
set_param(AxleTorque_block_path, deltaT = num2str(nvpairs.AxleTorque_DeltaT))

MotorTorqueCommand_block_path = inpSysPath + "/" + nvpairs.MotorTorqueCommand_BlockName;
set_param(MotorTorqueCommand_block_path, dataPoints = mat2str(nvpairs.MotorTorqueCommand_DataPoints))
set_param(MotorTorqueCommand_block_path, deltaT = num2str(nvpairs.MotorTorqueCommand_DeltaT))

HeatFlowCommand_block_path = inpSysPath + "/" + nvpairs.HeatFlowCommand_BlockName;
set_param(HeatFlowCommand_block_path, dataPoints = mat2str(nvpairs.HeatFlowCommand_DataPoints))
set_param(HeatFlowCommand_block_path, deltaT = num2str(nvpairs.HeatFlowCommand_DeltaT))

set_param(mdl + "/Mechanical Load/Load Inertia", inertia = num2str(nvpairs.LoadInertia_kg_m2))
set_param(mdl + "/Mechanical Load/Load Damper", D = num2str(nvpairs.LoadDamping_Nm_per_rpm))

set_param(mdl + "/Mechanical Load/Geartrain Inertia", inertia = num2str(nvpairs.GeartrainInertia_kg_m2))
set_param(mdl + "/Mechanical Load/Geartrain Damper", D = num2str(nvpairs.GeartrainDamping_Nm_per_rpm))

setValue("batteryHV.nominalVoltage_V", nvpairs.HVBattery_Voltage_V, nvpairs.DisplayMessage)

setValue("batteryHV.internalResistance_Ohm", nvpairs.HVBattery_TerminalResistance_Ohm, nvpairs.DisplayMessage)

MotorDriveUnit_setInitialConditions( ...
  Initial_LoadInertiaSpd_rpm = nvpairs.Initial_LoadInertiaSpd_rpm, ...
  Initial_MotorDriveUnit_RotorSpd_rpm = nvpairs.Initial_MotorDriveUnit_RotorSpd_rpm, ...
  Initial_MotorDriveUnit_Temperature_K = nvpairs.Initial_MotorDriveUnit_Temperature_K, ...
  Initial_AmbientTemperature_K = nvpairs.Initial_AmbientTemperature_K, ...
  DisplayMessage = nvpairs.DisplayMessage );

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
