%% Model Parameters for FEM-Parameterized PMSM

% Copyright 2020 The MathWorks, Inc.

%% Electrical

% Load flux linkage data.
% This data was generated for a typical generic motor, not for a specific one.
load("PmsmFem_ParamData.mat")

PmsmFem.NumPolePairs = 4; % Number of pole pairs
PmsmFem.idVec_A = idVec; % Direct-asis current vector, iD
PmsmFem.iqVec_A = iqVec; % Quadrature-axis current vector, iQ
PmsmFem.angleVec_deg = angleVec2; % Rotor angle vector, theta
PmsmFem.flux = flux2;
PmsmFem.torque_Nm = torque2; % Torque matrix, T(iD,iQ,theta)

clear idVec iqVec angleVec2 flux2 torque2

PmsmFem.Rs_Ohm = 0.07; % Stator resistance per phase, Rs

%% Iron Losses

PmsmFem.openCircuitLossVec_W = [80 25 5];
PmsmFem.shortCircuitLossVec_W = [230 55 10];
PmsmFem.frequencyForLosses_Hz = 150;
PmsmFem.shortCircuitCurrent_A = 85;

%% Mechanical

PmsmFem.rotorInertia_kg_m2 = 3.93*0.01^2; % Rotor inertia
PmsmFem.rotorDamping_Nm_per_radps = 0;  % Rotor damping

%% Variables

PmsmFem.initialDAxisCurrent_A = 0;
PmsmFem.initialQAxisCurrent_A = 0;
PmsmFem.initialRotorSpeed_rpm = 0;
PmsmFem.initialRotorAngle_rad = -pi/2/PmsmFem.NumPolePairs;
