function CtrlEnv_Vehicle_loadSimulationCase(nvpairs)
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

  nvpairs.ModelName {mustBeTextScalar} = "CtrlEnv_Vehicle_harness_model"

  nvpairs.StopTime (1,1) {mustBePositive} = 300

  nvpairs.InputSystemPath {mustBeTextScalar} = ""

  nvpairs.BrakeForce_BlockName {mustBeTextScalar} = "Brake force"
  nvpairs.BrakeForce_DataPoints (:,3) double = [0 200 0; 230 280 1000]
  nvpairs.BrakeForce_DeltaT (1,1) {mustBePositive} = 0.5

  nvpairs.MotorTorqueCommand_BlockName {mustBeTextScalar} = "Motor torque command"
  nvpairs.MotorTorqueCommand_DataPoints (:,3) double = [0 100 100; 110 200 0]
  nvpairs.MotorTorqueCommand_DeltaT (1,1) {mustBePositive} = 0.5

  nvpairs.MotorHeatFlowCommand_BlockName {mustBeTextScalar} = "Motor heat flow command"
  nvpairs.MotorHeatFlowCommand_DataPoints (:,3) double = [0 90 0; 110 190 -1000; 210 300 1000]
  nvpairs.MotorHeatFlowCommand_DeltaT (1,1) {mustBePositive} = 0.5

  nvpairs.BatteryHeatFlowCommand_BlockName {mustBeTextScalar} = "Battery heat flow command"
  nvpairs.BatteryHeatFlowCommand_DataPoints (:,3) double = [0 90 0; 110 190 -1000; 210 300 1000]
  nvpairs.BatteryHeatFlowCommand_DeltaT (1,1) {mustBePositive} = 0.5

  nvpairs.Initial_VehicleSpeed_kph (1,1) double = 0
  nvpairs.Initial_MotorTemperature_K (1,1) {mustBePositive} = 273.15 + 60
  nvpairs.Initial_MotorAmbientTemperature_K (1,1) {mustBePositive} = 273.15 + 20
  nvpairs.Initial_BatteryTemperature_K (1,1) {mustBePositive} = 273.15 + 50
  nvpairs.Initial_BatteryAmbientTemperature_K (1,1) {mustBePositive} = 273.15 + 20

  nvpairs.TireRollingRadius_m (1,1) double {mustBePositive} = 0.35
  nvpairs.GearRatio (1,1) double {mustBePositive} = 9.1

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

BrakeForce_block_path = inpSysPath + "/" + nvpairs.BrakeForce_BlockName;
set_param(BrakeForce_block_path, dataPoints = mat2str(nvpairs.BrakeForce_DataPoints))
set_param(BrakeForce_block_path, deltaT = num2str(nvpairs.BrakeForce_DeltaT))

MotorTrqCmd_block_path = inpSysPath + "/" + nvpairs.MotorTorqueCommand_BlockName;
set_param(MotorTrqCmd_block_path, dataPoints = mat2str(nvpairs.MotorTorqueCommand_DataPoints))
set_param(MotorTrqCmd_block_path, deltaT = num2str(nvpairs.MotorTorqueCommand_DeltaT))

MotorHeatCmd_block_path = inpSysPath + "/" + nvpairs.MotorHeatFlowCommand_BlockName;
set_param(MotorHeatCmd_block_path, dataPoints = mat2str(nvpairs.MotorHeatFlowCommand_DataPoints))
set_param(MotorHeatCmd_block_path, deltaT = num2str(nvpairs.MotorHeatFlowCommand_DeltaT))

BatteryHeatCmd_block_path = inpSysPath + "/" + nvpairs.BatteryHeatFlowCommand_BlockName;
set_param(BatteryHeatCmd_block_path, dataPoints = mat2str(nvpairs.BatteryHeatFlowCommand_DataPoints))
set_param(BatteryHeatCmd_block_path, deltaT = num2str(nvpairs.BatteryHeatFlowCommand_DeltaT))

CtrlEnv_Vehicle_setInitialConditions( ...
  Initial_VehicleSpeed_kph = nvpairs.Initial_VehicleSpeed_kph, ...
  Initial_MotorTemperature_K = nvpairs.Initial_MotorTemperature_K, ...
  Initial_MotorAmbientTemperature_K = nvpairs.Initial_MotorAmbientTemperature_K, ...
  Initial_BatteryTemperature_K = nvpairs.Initial_BatteryTemperature_K, ...
  Initial_BatteryAmbientTemperature_K = nvpairs.Initial_BatteryAmbientTemperature_K, ...
  TireRollingRadius_m = nvpairs.TireRollingRadius_m, ...
  GearRatio = nvpairs.GearRatio, ...
  DisplayMessage = nvpairs.DisplayMessage )

end  % function
