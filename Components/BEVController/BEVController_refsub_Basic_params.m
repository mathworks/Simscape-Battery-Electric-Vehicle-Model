%% Parameters for BEV Controller component
% If you edit this file, make sure to run this to update variables
% in the base workspace before running simulation.

% Copyright 2023 The MathWorks, Inc.

%% BEV controller parameters

% Parameters for converting vehicle speed to motor speed
bevControl.MotorSpdRef_tireRollingRadius_m = 0.34;
bevControl.MotorSpdRef_reductionGearRaio = 9.1;

% ====================
% Motor torque control

% PI controller gains for motor torque control
bevControl.MotorSpdRef_Ki = 15;
bevControl.MotorSpdRef_Kp = 15;

% Bounds for torque command
bevControl.MotorDriveUnit_trqMax_Nm = 420;
