%% Parameters for the BEV Controller test inputs
% If you edit this file, make sure to run this script to update the variable
% in the base workspace before running simulation.

% Copyright 2025-2026 The MathWorks, Inc.

% Define an N-by-3 signal design matrix.
% Each row defines start time, end time, and constant value.
% Use nan at the end time (second column) to create a non-constant curve.
% Data between rows are smoothly interpolated by the modified Akima spline.
signal_design_matrix = [
  0   100 0   ; ... from time 0 to time 100, constant value 0
  105 200 40  ; ... from time 105 to time 200, constant value 40
  205 300 60
  305 400 100
  405 500 50
  510 600 0
  ];

vectors = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(signal_design_matrix);

% Use this table in a lookup table block.
% Table data are used as the parameters of a lookup table block which requires at least three data points.
VehicleSpeedInput = table( ...
  simscape.Value(vectors.X, "s"), ...
  simscape.Value(vectors.F, "km/hr"), ...
  VariableNames=["Time", "Speed"]);
