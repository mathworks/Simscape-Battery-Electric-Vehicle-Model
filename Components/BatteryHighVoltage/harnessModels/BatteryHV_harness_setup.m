%% Model Parameters for High Voltage Battery Harness Model
% This script is run automatically when harness model opens.

% Copyright 2022-2023 The MathWorks, Inc.

%% Bus

defineBus_HighVoltage

%% Battery componednt parameters

% This works with the Basic, System-Level Simple, and System-Level battery models.
BatteryHV_refsub_SystemLevel_params

%{
refsubFilename = BatteryHV_getReferencedSubsystemFilename(...
  ModelName = "BatteryHV_harness_model", ...
  ReferencedSubsystemPrefix = "BatteryHV_refsub_" );

disp("Found referenced subsystem: " + refsubFilename)
disp("Loading parameters...")

paramFilename = refsubFilename + "_params";
evalin("base", paramFilename)
%}
