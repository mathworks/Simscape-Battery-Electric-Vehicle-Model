%% Parameters for the motor torque driver
% If you edit this file, make sure to run this script to update the variable
% in the base workspace before running simulation.

% Copyright 2025-2026 The MathWorks, Inc.

% Define an N-by-3 signal design matrix.
% Each row defines start time, end time, and constant value.
% Use nan at the end time (second column) to create a non-constant curve.
% Data between rows are smoothly interpolated by the modified Akima spline.
signal_design_matrix = [
  0  3  0      ; ... from time 0 to time 3, constant value 0
  4  5  -50    ; ... from time 4 to time 5, constant value -50
  6  10 50
  12 13 0
  ];

vectors = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(signal_design_matrix);

% Use this table in a lookup table block.
% Table data are used as the parameters of a lookup table block which requires at least three data points.
MotorTorqueInput = table( ...
  simscape.Value(vectors.X, "s"), ...
  simscape.Value(vectors.F, "N*m"), ...
  VariableNames=["Time", "Torque"]);
