%% Load input signal data in the base workspace
% Lookup table blocks should refer to the base workspace variables that are 
% setup in this script.

% Copyright 2026 The MathWorks, Inc.

%% Load current

% Set data to the target variable in the base workspace.
% These data are used as the parameters of a lookup table block which requires at least three data points.
batteryHV.Input_LoadCurrent_TimePoints = simscape.Value([0, 1, 2], "s");
batteryHV.Input_LoadCurrent_Data = simscape.Value([-10, -10, -10], "A");

%% Heat flow

% Set data to the target variable in the base workspace.
% These data are used as the parameters of a lookup table block which requires at least three data points.
batteryHV.Input_HeatFlow_TimePoints = simscape.Value([0, 1, 2], "s");
batteryHV.Input_HeatFlow_Data = simscape.Value([0, 0, 0], "W");
