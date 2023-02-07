%% Takes screenshots and saves them to file.
% This functions takes screenshots of the top layer
% and some subsystems specified in this function.

% Copyright 2022-2023 The MathWorks, Inc.

mdl = "BatteryHV_harness_model";
load_system(mdl)

block_path = mdl + "/High Voltage Battery";

% Load model parameters.
BatteryHV_harness_setup

imageSaveFolder = fullfile( currentProject().RootFolder, ...
                    "Components", "BatteryHighVoltage", "Images" );

% Set referenced subsystem.
set_param(block_path, ReferencedSubsystem = "BatteryHV_refsub_Basic")

% Update model for screenshot.
set_param(mdl, SimulationCommand = "update")

% Take the screenshot of top layer and save it.
screenshotSimulink( ...
  OutputFileName = mdl + "_screenshot.png", ...
  SimulinkModelName = mdl, ...
  SaveFolder = imageSaveFolder );

%% Take screenshots of subsystems

setRefSub = @(name) ...
  set_param(block_path, ReferencedSubsystem = "BatteryHV_refsub_" + name);

takeScreenshot = @(name) ...
  screenshotSimulink( ...
    OutputFileName = "BatteryHV_refsub_" + name + "_screenshot.png", ...
    SimulinkModelName = mdl, ...
    SubsystemPath = "/High Voltage Battery", ...
    SaveFolder = imageSaveFolder );

name = "Basic";
setRefSub(name)
takeScreenshot(name);

name = "System";
setRefSub(name)
takeScreenshot(name);

name = "SystemSimple";
setRefSub(name)
takeScreenshot(name);

name = "SystemTable";
setRefSub(name)
takeScreenshot(name);
