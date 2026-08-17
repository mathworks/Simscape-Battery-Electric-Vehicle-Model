%% Parameters for the vehicle speed reference
% If you edit this file, make sure to run this to update variables
% in the base workspace before running simulation.

% Copyright 2026 The MathWorks, Inc.

% Set data to the target variable in the base workspace.
% These data are used as the parameters of a lookup table block which requires at least three data points.
VehicleSpeedRef = table( ...
  simscape.Value([0, 1, 10]', "s"), ...
  simscape.Value([0, 0, 0]', "km/hr"), ...
  VariableNames = ["Time", "Speed"] );
