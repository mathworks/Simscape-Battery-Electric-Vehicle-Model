%% Parameters for the lookup table blocks
% If you edit this file, make sure to run this script to update the variable
% in the base workspace before running simulation.

% Copyright 2026 The MathWorks, Inc.

% -----------------------------------------------------------------------------
% Brake force input

% Define an N-by-3 signal design matrix.
% Each row defines start time, end time, and constant value.
% Use nan at the end time (second column) to create a non-constant curve.
% Data between rows are smoothly interpolated by the modified Akima spline.
BrakeForceInput.SignalDesignMatrix = [ 0 1 0 ];  % from time 0 to time 1, stay at a constant value 0

BrakeForceInput.DataTable = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(BrakeForceInput.SignalDesignMatrix);

% Set these fields to the parameters of a Lookup Table block with the value method.
% For example, use BrakeForceInput.Time.value("s").
BrakeForceInput.Time = simscape.Value(BrakeForceInput.DataTable.X, "s");
BrakeForceInput.Force = simscape.Value(BrakeForceInput.DataTable.F, "N");

% -----------------------------------------------------------------------------
% Road grade (percent) input

RoadGradeInput.SignalDesignMatrix = [ 0 1 0 ];  % from time 0 to time 1, stay at a constant value 0

RoadGradeInput.DataTable = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(RoadGradeInput.SignalDesignMatrix);

RoadGradeInput.Time = simscape.Value(RoadGradeInput.DataTable.X, "s");
RoadGradeInput.Grade = RoadGradeInput.DataTable.F;

% -----------------------------------------------------------------------------
% Axle torque input

AxleTorqueInput.DesignMatrix = [ 0 1 0 ];  % from time 0 to time 10, stay at a constant value 0

AxleTorqueInput.DataTable = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(AxleTorqueInput.DesignMatrix);

AxleTorqueInput.Time = simscape.Value(AxleTorqueInput.DataTable.X, "s");
AxleTorqueInput.Torque = simscape.Value(AxleTorqueInput.DataTable.F, "N*m");
