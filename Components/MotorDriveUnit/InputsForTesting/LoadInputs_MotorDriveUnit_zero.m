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
% Akima spline (in the lookup table block) requires at least three data points.
Time = simscape.Value([0 1 2]', "s");
Data = simscape.Value([0 0 0]', "rpm");
MDU_HarnessInputs.AxleSpeed = table(Time, Data);

%% Axle torque
% Akima spline (in the lookup table block) requires at least three data points.
Time = simscape.Value([0 1 2]', "s");
Data = simscape.Value([0 0 0]', "N*m");
MDU_HarnessInputs.AxleTorque = table(Time, Data);

%% Motor torque command
% Akima spline (in the lookup table block) requires at least three data points.
Time = simscape.Value([0 1 2]', "s");
Data = simscape.Value([0 0 0]', "N*m");
MDU_HarnessInputs.MotorTorqueCommand = table(Time, Data);

%% Motor heat flow
% Akima spline (in the lookup table block) requires at least three data points.
Time = simscape.Value([0 1 2]', "s");
Data = simscape.Value([0 0 0]', "W");
MDU_HarnessInputs.MotorHeatFlow = table(Time, Data);
