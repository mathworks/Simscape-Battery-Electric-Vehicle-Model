%% Model parameters for Reducer component
% When the Recuder harness model opens, the model runs this script automatically in
% the PreLoadFcn callback.
%
% Informational messages from disp are turned off to prevent
% the warnings/diagnostics from appearing when the model opens.

% Copyright 2025 The MathWorks, Inc.

%% Bus definitions

defineBus_Rotational

%% Reducer parameters

reducer.GearRatio = 9.1;

reducer.Efficiency_normalized = 0.98;

smoothing.Reducer_PowerThreshold_W = 1;
