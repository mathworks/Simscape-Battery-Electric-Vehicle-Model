%% Load input signal data in the base workspace
% Lookup table blocks should refer to the base workspace variables that are defined in this script.

% Copyright 2026 The MathWorks, Inc.

% Use Simscape's unit of time with a table, instead of a duration object and a timetable.
% This approach makes it consistent to handle units in block parameters.

%% Axle speed input clutch on/off
% Discrete signal
Time = simscape.Value([0 1]', "s");
StepValues = [0 0]';
MDU_HarnessInputs.AxleSpeedSwitch = table(Time, StepValues);

%% Axle speed
% Akima spline (used in the lookup table block) requires at least three data points.
Time = simscape.Value([0 1 2]', "s");
Data = simscape.Value([0 0 0]', "rpm");
MDU_HarnessInputs.AxleSpeed = table(Time, Data);

%% Axle torque
% Akima spline (used in the lookup table block) requires at least three data points.

signal_design_matrix = [
  0   100 100  % from time 0 to 100, stay constant at 100.
  150 200 400  % from time 150 to 200, stay constant at 400. (from time 100 to 150, smoothly interpolate.)
  ];
data_table = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(signal_design_matrix);
Time = simscape.Value(data_table.X, "s");
Data = simscape.Value(data_table.F, "N*m");
MDU_HarnessInputs.AxleTorque = table(Time, Data);

%% Motor torque command
% Akima spline (used in the lookup table block) requires at least three data points.

signal_design_matrix = [
  0   40  0    % from time 0 to 40, stay constant at 0.
  50  170 -20  % from time 0 to 100, stay constant at 100. (from time 40 to 50, smoothly interpolate.)
  180 200 -50
  ];
data_table = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(signal_design_matrix);
Time = simscape.Value(data_table.X, "s");
Data = simscape.Value(data_table.F, "N*m");
MDU_HarnessInputs.MotorTorqueCommand = table(Time, Data);

%% Motor heat flow
% Akima spline (in the lookup table block) requires at least three data points.
Time = simscape.Value([0 1 2]', "s");
Data = simscape.Value([0 0 0]', "W");
MDU_HarnessInputs.MotorHeatFlow = table(Time, Data);
