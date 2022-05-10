%% Build Simscape custom Battery library

% Copyright 2020-2022 The MathWorks, Inc.

current_folder = pwd;

prj_root = currentProject().RootFolder;

ssc_lib_path = fullfile(prj_root, ...
  "DetailedModelApplications", "BatteryHighVoltageDetailed", "lib");

assert(isfolder(ssc_lib_path), ...
  "Simscape custom library folder was not found: " + ssc_lib_path)

disp("Changing the current folder to build custom Simscape library: " + ssc_lib_path)
cd(ssc_lib_path)

% Build custom library.
ssc_build batteryModule

% Return to the previous folder.
cd(current_folder)
