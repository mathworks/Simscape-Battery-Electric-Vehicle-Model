%% Parameters for the axle torque driver
% If you edit this file, make sure to run this script to update the variable
% in the base workspace before running simulation.

% Copyright 2025-2026 The MathWorks, Inc.

% Define an N-by-3 signal design matrix.
% Each row defines start time, end time, and constant value.
% Use nan at the end time (second column) to create a non-constant curve.
% Data between rows are smoothly interpolated by the modified Akima spline.
signal_design_matrix = [
  0  5  0      ; ... from time 0 to time 5, constant value 0
  8  20 100    ; ... from time 8 to time 20, constant value 100
  30 50 -100
  65 70 0
  ];

vectors = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(signal_design_matrix);

% Use this table in a lookup table block.
% Table data are used as the parameters of a lookup table block which requires at least three data points.
AxleTorqueInput = table( ...
  simscape.Value(vectors.X, "s"), ...
  simscape.Value(vectors.F, "N*m"), ...
  VariableNames=["Time", "Torque"]);
