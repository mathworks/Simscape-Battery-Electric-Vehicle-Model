function BatteryHV_loadSimulationCase(nvpairs)
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

  nvpairs.ModelName {mustBeTextScalar} = "BatteryHV_harness_model"

  nvpairs.StopTime (1,1) {mustBePositive} = 10

  nvpairs.InputSystemPath {mustBeTextScalar} = "/Inputs"

  nvpairs.LoadCurrentBlockName {mustBeTextScalar} = "Load current"
  nvpairs.LoadCurrentDataPoints (:,3) double = [0 1 0]
  nvpairs.LoadCurrentDeltaT (1,1) {mustBePositive} = 0.1

  nvpairs.HeatFlowBlockName {mustBeTextScalar} = "Heat flow"
  nvpairs.HeatFlowDataPoints (:,3) double = [0 1 0]
  nvpairs.HeatFlowDeltaT (1,1) {mustBePositive} = 0.1

  nvpairs.TerminalVoltage_V (1,1) {mustBePositive} = 350
  nvpairs.NominalCapacity_kWh (1,1) {mustBePositive} = 40

  nvpairs.InitialSOC_pct (1,1) {mustBeInRange(nvpairs.InitialSOC_pct, 0, 100)} = 70
  nvpairs.InitialBatteryTemperature_K (1,1) {mustBePositive} = 273.15 + 20
  nvpairs.InitialAmbientTemperature_K (1,1) {mustBePositive} = 273.15 + 20

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
  disp("Setting block parameters for input blocks...")
end

inpSysPath = mdl + nvpairs.InputSystemPath;
LoadCurrent_block_path = inpSysPath + "/" + nvpairs.LoadCurrentBlockName;
Heatflow_block_path = inpSysPath + "/" + nvpairs.HeatFlowBlockName;

set_param(LoadCurrent_block_path, dataPoints = mat2str(nvpairs.LoadCurrentDataPoints))
set_param(LoadCurrent_block_path, deltaT = num2str(nvpairs.LoadCurrentDeltaT))

set_param(Heatflow_block_path, dataPoints = mat2str(nvpairs.HeatFlowDataPoints))
set_param(Heatflow_block_path, deltaT = num2str(nvpairs.HeatFlowDeltaT))

BatteryHV_setInitialConditions( ...
  TerminalVoltage_V = nvpairs.TerminalVoltage_V, ...
  NominalCapacity_kWh = nvpairs.NominalCapacity_kWh, ...
  InitialSOC_pct = nvpairs.InitialSOC_pct, ...
  InitialBatteryTemperature_K = nvpairs.InitialBatteryTemperature_K, ...
  InitialAmbientTemperature_K = nvpairs.InitialAmbientTemperature_K, ...
  DisplayMessage = dispMsg );

end  % function
