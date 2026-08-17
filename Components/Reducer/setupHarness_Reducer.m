%% Setup script for the Reducer component harness
% When the harness model opens, the model runs this script automatically in
% the PreLoadFcn callback.
%
% Displaying messages must be turned off to avoid warnings when the model opens.

% Copyright 2025-2026 The MathWorks, Inc.

%% Bus definitions

defineBus_Rotational

%% Reducer parameters

reducer.GearRatio = 9.1;
reducer.Efficiency_normalized = 0.98;

smoothing.Reducer_PowerThreshold_W = 1;

%% Input torques from the motor and the axle

loadLUTData_Reducer_Motor_FlipTorque
loadLUTData_Reducer_Axle_FlipTorque
