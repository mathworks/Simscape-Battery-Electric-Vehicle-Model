function Vehicle1D_loadSimulationCase_Braking
%% Sets up simulation
% This function sets up the followings:
% - Simulation stop time
% - Input signals
% - Initial conditions
%
% Model must be loaded for this function to work.

% Copyright 2023 The MathWorks, Inc.

Vehicle1D_loadSimulationCase( ...
  CaseName = "Braking", ...
  ...
  ModelName = "Vehicle1D_harness_model", ...
  ...
  StopTime = 400, ...
  ...
  InputSystemPath = "/Inputs", ...
  ...
  BrakeForce_BlockName = "Brake force", ... N
  BrakeForce_DataPoints = [0 100 0; 103 nan 3000; 110 200 0; 205 nan 5000; 210 300 0; 370 390 3000], ...
  BrakeForce_DeltaT = 0.2, ...
  ...
  RoadGrade_BlockName = "Road grade", ... %
  RoadGrade_DataPoints = [0 5 0; 10 500 -7; 520 1000 -4], ...
  RoadGrade_DeltaT = 0.5, ...
  ...
  AxleTorque_BlockName = "Axle torque", ... N*m
  AxleTorque_DataPoints = [0 10 0], ... ; 30 60 1000; 62 70 1000], ...
  AxleTorque_DeltaT = 0.5, ...
  ...
  GeartrainInertia_kg_m2 = 15*0.3^2, ...
  GeartrainDamping_Nm_per_rpm = 0.001, ...
  ...
  Initial_GeartrainInertiaSpd_rpm = 0, ...
  Initial_VehicleSpeed_kph = 0, ...
  ...
  DisplayMessage = true );

end  % function
