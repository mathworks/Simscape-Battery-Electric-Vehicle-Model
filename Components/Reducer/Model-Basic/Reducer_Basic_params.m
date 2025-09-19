%% Model parameters for reducer component
%
% If you edit this file, make sure to run this to update variables
% in the base workspace before running simulation.

% Copyright 2023 The MathWorks, Inc.

%% Bus definitions

defineBus_Rotational

%% Reducer parameters

reducer.GearRatio = 9.1;

reducer.Efficiency_normalized = 0.98;

smoothing.Reducer_PowerThreshold_W = 1;
