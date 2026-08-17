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
  0  20 0    % from time 0 to 20, stay constant at 0.
  21 40 -10  % from time 21 to 40, stay constant at -10. (from time 20 to 21, smoothly interpolate.)
  ];
data_table = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(signal_design_matrix);
Time = simscape.Value(data_table.X, "s");
Data = simscape.Value(data_table.F, "N*m");
MDU_HarnessInputs.AxleTorque = table(Time, Data);

%% Motor torque command
% Akima spline (used in the lookup table block) requires at least three data points.

signal_design_matrix = [
  0   10  0     % from time 0 to 10, stay constant at 0.
  60  100 -300  % from time 60 to 100, stay constant at -300. (From time 10 to 60, smoothly interpolate.)
  105 200 200
  205 300 250
  ];
data_table = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(signal_design_matrix);
Time = simscape.Value(data_table.X, "s");
Data = simscape.Value(data_table.F, "N*m");
MDU_HarnessInputs.MotorTorqueCommand = table(Time, Data);

%% Motor heat flow
% Akima spline (used in the lookup table block) requires at least three data points.

signal_design_matrix = [
  0   50  0      % from time 0 to 50, stay constant at 0.
  60  200 -2000  % from time 60 to 200, stay constant at -2000. (from time 50 to 60, smoothly interpolate.)
  250 300 -12000
  ];
data_table = bevutil1.SignalUtil.getVectorsFromSignalDesignMatrix(signal_design_matrix);
Time = simscape.Value(data_table.X, "s");
Data = simscape.Value(data_table.F, "W");
MDU_HarnessInputs.MotorHeatFlow = table(Time, Data);
