%% Takes screenshots and saves to file.
% This script takes screenshots of the top layer and some subsystems.

% Copyright 2022-2023 The MathWorks, Inc.

mdl = "BEV_system_model";
load_system(mdl)

% Set referenced subsystems, and load parameters.
BEV_setup

imageSaveFolder = fullfile( currentProject().RootFolder, ...
  "BEV", "Utility", "Images" );

% Update the model before taking screenshot.
% This ensures that the model is completely built and ready to run.
% This also updates the redering of Bus signal lines.
set_param(mdl, SimulationCommand = "update")

% Take the screenshot of top layer and save it.
screenshotSimulink( ...
  OutputFileName = mdl + "_screenshot.png", ...
  SimulinkModelName = mdl, ...
  SaveFolder = imageSaveFolder );

%% Take screenshots of High Voltage Battery component
%{
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
%}
