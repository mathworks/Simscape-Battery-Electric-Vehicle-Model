%% Load input signal data in the base workspace
% Lookup table blocks should refer to the base workspace variables that are
% setup in this script.

% Copyright 2026 The MathWorks, Inc.

%% Axle speed input clutch on/off

% Set data to the target variable in the base workspace.
% The signal is a discrete signal to engage or disengage a clutch.
MotorDriveUnit.Input_AxleSpeedSwitch_TimePoints = simscape.Value([0, 1], "s");
MotorDriveUnit.Input_AxleSpeedSwitch_StepValues = [0 0];

%% Axle speed

% Set data to the target variable in the base workspace.
% These data are used as the parameters of a lookup table block which requires at least three data points.
MotorDriveUnit.Input_AxleSpeed_TimePoints = simscape.Value([0, 1, 2], "s");
MotorDriveUnit.Input_AxleSpeed_Data = simscape.Value([0, 0, 0], "rpm");

%% Axle torque

signal_design_matrix = [0 100 100; 150 200 400];
data_table = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(signal_design_matrix);

% Set data to the target variable in the base workspace.
% These data are used as the parameters of a lookup table block which requires at least three data points.
MotorDriveUnit.Input_AxleTorque_TimePoints = simscape.Value(data_table.X, "s");
MotorDriveUnit.Input_AxleTorque_Data = simscape.Value(data_table.F, "N*m");

%% Motor torque command

signal_design_matrix = [0 40 0; 50 170 -20; 180 200 -50];
data_table = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(signal_design_matrix);

% Set data to the target variable in the base workspace.
% These data are used as the parameters of a lookup table block which requires at least three data points.
MotorDriveUnit.Input_MotorTorqueCommand_TimePoints = simscape.Value(data_table.X, "s");
MotorDriveUnit.Input_MotorTorqueCommand_Data = simscape.Value(data_table.F, "N*m");

%% Motor heat flow

% Set data to the target variable in the base workspace.
% These data are used as the parameters of a lookup table block which requires at least three data points.
MotorDriveUnit.Input_MotorHeatFlow_TimePoints = simscape.Value([0, 1, 2], "s");
MotorDriveUnit.Input_MotorHeatFlow_Data = simscape.Value([0, 0, 0], "W");
