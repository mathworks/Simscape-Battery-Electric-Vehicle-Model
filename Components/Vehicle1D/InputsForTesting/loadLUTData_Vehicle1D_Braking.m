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
BrakeForceInput.SignalDesignMatrix = [
  0   100 0    ; ... from time 0 to time 100, stay at a constant value 0
  103 nan 3000 ; ... at time 103, hit a constant value 3000
  110 200 0    ;
  205 nan 5000 ;
  210 300 0    ;
  370 390 3000 ];

BrakeForceInput.DataTable = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(BrakeForceInput.SignalDesignMatrix);

% Set these fields to the parameters of a Lookup Table block with the value method.
% For example, use BrakeForceInput.Time.value("s").
BrakeForceInput.Time = simscape.Value(BrakeForceInput.DataTable.X, "s");
BrakeForceInput.Force = simscape.Value(BrakeForceInput.DataTable.F, "N");

% -----------------------------------------------------------------------------
% Road grade (percent) input

RoadGradeInput.SignalDesignMatrix = [
  0   5    0  ; ... from time 0 to time 5, stay at a constant value 0
  10  500  -7 ; ... from time 10 to time 500, stay at a constant value -7
  520 1000 -4 ];

RoadGradeInput.DataTable = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(RoadGradeInput.SignalDesignMatrix);

RoadGradeInput.Time = simscape.Value(RoadGradeInput.DataTable.X, "s");
RoadGradeInput.Grade = RoadGradeInput.DataTable.F;

% -----------------------------------------------------------------------------
% Axle torque input

AxleTorqueInput.DesignMatrix = [ 0 10 0 ]; ... from time 0 to time 10, stay at a constant value 0

AxleTorqueInput.DataTable = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(AxleTorqueInput.DesignMatrix);

AxleTorqueInput.Time = simscape.Value(AxleTorqueInput.DataTable.X, "s");
AxleTorqueInput.Torque = simscape.Value(AxleTorqueInput.DataTable.F, "N*m");
