%% Takes screenshots and saves them to file.
% This functions takes screenshots of the top layer
% and some subsystems specified in this function.

% Copyright 2022 The MathWorks, Inc.

mdl = "BatteryHV_harness_model";
load_system(mdl)

block_path = mdl + "/High Voltage Battery";

% Load model parameters.
BatteryHV_harness_setup

imageSaveFolder = fullfile( currentProject().RootFolder, ...
                    "Components", "BatteryHighVoltage", "images" );

% Set referenced subsystem.
set_param(block_path, ReferencedSubsystem = "BatteryHV_refsub_Basic")

% Update model for screenshot.
set_param(mdl, SimulationCommand = "update")

% Take the screenshot of top layer and save it.
screenshotSimulink( ...
  SimulinkModelName = mdl, ...
  SaveFolder = imageSaveFolder );

setRefSub = @(name) ...
  set_param(block_path, ReferencedSubsystem = "BatteryHV_refsub_" + name);

takeScreenshot = @(name) ...
  screenshotSimulink( ...
    OutputFileName = "image_BatteryHV_refsub_" + name + ".png", ...
    SimulinkModelName = mdl, ...
    SubsystemPath = "/High Voltage Battery", ...
    SaveFolder = imageSaveFolder );

name = "Basic";
setRefSub(name)
takeScreenshot(name);

name = "Driveline";
setRefSub(name)
takeScreenshot(name);

name = "Electrical";
setRefSub(name)
takeScreenshot(name);
