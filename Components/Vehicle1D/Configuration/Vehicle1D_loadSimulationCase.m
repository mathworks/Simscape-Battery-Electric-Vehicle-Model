function Vehicle1D_loadSimulationCase(nvpairs)
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

  nvpairs.ModelName {mustBeTextScalar} = "Vehicle1D_harness_model"

  nvpairs.StopTime (1,1) {mustBePositive} = 10

  nvpairs.InputSystemPath {mustBeTextScalar} = "/Inputs"

  nvpairs.BrakeForce_BlockName {mustBeTextScalar} = "Brake force"
  nvpairs.BrakeForce_DataPoints (:,3) double = [0 1 0]
  nvpairs.BrakeForce_DeltaT (1,1) {mustBePositive} = 0.1

  nvpairs.RoadGrade_BlockName {mustBeTextScalar} = "Road grade"
  nvpairs.RoadGrade_DataPoints (:,3) double = [0 1 0]
  nvpairs.RoadGrade_DeltaT (1,1) {mustBePositive} = 0.1

  nvpairs.AxleTorque_BlockName {mustBeTextScalar} = "Axle torque"
  nvpairs.AxleTorque_DataPoints (:,3) double = [0 1 0]
  nvpairs.AxleTorque_DeltaT (1,1) {mustBePositive} = 0.1

  nvpairs.GeartrainInertia_kg_m2 (1,1) {mustBePositive} = 15*0.3^2
  nvpairs.GeartrainDamping_Nm_per_rpm (1,1) {mustBePositive} = 0.001

  nvpairs.Initial_GeartrainInertiaSpd_rpm (1,1) double = 0;
  nvpairs.Initial_VehicleSpeed_kph (1,1) double = 0;

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

RoadGrade_block_path = inpSysPath + "/" + nvpairs.RoadGrade_BlockName;
set_param(RoadGrade_block_path, dataPoints = mat2str(nvpairs.RoadGrade_DataPoints))
set_param(RoadGrade_block_path, deltaT = num2str(nvpairs.RoadGrade_DeltaT))

AxleTorque_block_path = inpSysPath + "/" + nvpairs.AxleTorque_BlockName;
set_param(AxleTorque_block_path, dataPoints = mat2str(nvpairs.AxleTorque_DataPoints))
set_param(AxleTorque_block_path, deltaT = num2str(nvpairs.AxleTorque_DeltaT))

set_param(mdl + "/Axle torque input/Geartrain Inertia", ...
  inertia = num2str(nvpairs.GeartrainInertia_kg_m2))

set_param(mdl + "/Axle torque input/Geartrain Damper", ...
  D = num2str(nvpairs.GeartrainDamping_Nm_per_rpm))

Vehicle1D_setInitialConditions( ...
  Initial_LoadInertiaSpd_rpm = nvpairs.Initial_GeartrainInertiaSpd_rpm, ...
  Initial_VehicleSpeed_kph = nvpairs.Initial_VehicleSpeed_kph, ...
  DisplayMessage = nvpairs.DisplayMessage );

end  % function
