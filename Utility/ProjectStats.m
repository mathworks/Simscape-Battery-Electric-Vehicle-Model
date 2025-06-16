%[text] # Project statistics
%[text] This Live Script reports some statistics of the project. For information about MATLAB Project, see [Projects](https://www.mathworks.com/help/matlab/projects.html) in the documentation. For information about the object of MATLAB Project, see [`matlab.project.Project`](https://www.mathworks.com/help/matlab/ref/matlab.project.project.html).
% Check if any MATLAB Project is currently open.
assert(not(isempty(matlab.project.rootProject)), "No project is loaded.")
disp(currentProject().Name) %[output:4a6aa6ff]
%%
%[text] ### Project Paths
disp([currentProject().ProjectPath.StoredLocation]') %[output:21b395a2]
%[text] ### Startup Files
disp(extractAfter([currentProject().StartupFiles]', currentProject().RootFolder)) %[output:015a3b94]
%[text] ### Simulink cache folder
disp(extractAfter(currentProject().SimulinkCacheFolder, currentProject().RootFolder)) %[output:31122d6d]
%%
%[text] ## Files in Project
%[text] The number of files in the project
disp(numel(currentProject().Files) + " files") %[output:2accf8f6]
project_files = extractAfter([currentProject().Files.Path]', currentProject().RootFolder);
%[text] System Models
disp(project_files(contains(project_files, "system_model", IgnoreCase=true))) %[output:5ce03cfe]
%[text] Referenced Subsystems
refsubs = project_files(contains(project_files, "_refsub_", IgnoreCase=true));
refsubs = refsubs(endsWith(refsubs, (".mdl"|".slx")));
disp(numel(refsubs) + " referenced subsystems") %[output:559db94f]
disp(refsubs) %[output:69f5c9d2]
%[text] Simscape custom components
sscfiles = project_files(endsWith(project_files, ".ssc"));
disp(numel(sscfiles) + " Simscape custom components") %[output:86517736]
disp(sscfiles) %[output:8a0ff20b]
%[text] *Copyright 2022-2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:4a6aa6ff]
%   data: {"dataType":"text","outputData":{"text":"Simscape Battery Electric Vehicle Model\n","truncated":false}}
%---
%[output:21b395a2]
%   data: {"dataType":"text","outputData":{"text":"    \"\"\n    \"BEV\"\n    \"BEV\/SimulationCases\"\n    \"BEV\/Test\"\n    \"BEV\/Utility\"\n    \"BEV\/Utility\/Configuration\"\n    \"BEV\/Utility\/Images\"\n    \"BEV\/Utility\/LocalTasks\"\n    \"Components\"\n    \"Components\/BEVController\"\n    \"Components\/BEVController\/Harness\"\n    \"Components\/BEVController\/SimulationCases\"\n    \"Components\/BEVController\/Test\"\n    \"Components\/BEVController\/Utility\"\n    \"Components\/BEVController\/Utility\/Configuration\"\n    \"Components\/BEVController\/Utility\/LocalTasks\"\n    \"Components\/BatteryHighVoltage\"\n    \"Components\/BatteryHighVoltage\/Harness\"\n    \"Components\/BatteryHighVoltage\/Model-TableBased\"\n    \"Components\/BatteryHighVoltage\/SimulationCases\"\n    \"Components\/BatteryHighVoltage\/Test\"\n    \"Components\/BatteryHighVoltage\/Utility\"\n    \"Components\/BatteryHighVoltage\/Utility\/Configuration\"\n    \"Components\/BatteryHighVoltage\/Utility\/Images\"\n    \"Components\/BatteryHighVoltage\/Utility\/LocalTasks\"\n    \"Components\/ControllerAndEnvironment\"\n    \"Components\/ControllerAndEnvironment\/Harness\"\n    \"Components\/ControllerAndEnvironment\/Harness\/Components\"\n    \"Components\/ControllerAndEnvironment\/Harness\/Components\/Vehicle\"\n    \"Components\/ControllerAndEnvironment\/Harness\/Components\/Vehicle\/Harness\"\n    \"Components\/ControllerAndEnvironment\/Harness\/Components\/Vehicle\/SimulationCases\"\n    \"Components\/ControllerAndEnvironment\/Harness\/Components\/Vehicle\/Test\"\n    \"Components\/ControllerAndEnvironment\/Harness\/Components\/Vehicle\/Utility\"\n    \"Components\/ControllerAndEnvironment\/Harness\/Components\/Vehicle\/Utility\/Configuration\"\n    \"Components\/ControllerAndEnvironment\/Harness\/Components\/Vehicle\/Utility\/LocalTasks\"\n    \"Components\/ControllerAndEnvironment\/SimulationCases\"\n    \"Components\/ControllerAndEnvironment\/Test\"\n    \"Components\/ControllerAndEnvironment\/Utility\"\n    \"Components\/ControllerAndEnvironment\/Utility\/Configuration\"\n    \"Components\/ControllerAndEnvironment\/Utility\/LocalTasks\"\n    \"Components\/MotorDriveUnit\"\n    \"Components\/MotorDriveUnit\/Model-Basic\"\n    \"Components\/MotorDriveUnit\/Model-BasicThermal\"\n    \"Components\/MotorDriveUnit\/Model-BasicThermal\/SimulationCases\"\n    \"Components\/MotorDriveUnit\/Model-Basic\/SimulationCases\"\n    \"Components\/MotorDriveUnit\/Model-SystemTable\"\n    \"Components\/MotorDriveUnit\/Model-SystemTable\/SimulationCases\"\n    \"Components\/MotorDriveUnit\/Model-SystemThermal\"\n    \"Components\/MotorDriveUnit\/Model-SystemThermal\/SimulationCases\"\n    \"Components\/MotorDriveUnit\/Utility-MDU\"\n    \"Components\/Reducer\"\n    \"Components\/Reducer\/Utility\"\n    \"Components\/Reducer\/Utility\/Images\"\n    \"Components\/Vehicle1D\"\n    \"Components\/Vehicle1D\/Model-Basic\"\n    \"Components\/Vehicle1D\/Model-Basic\/SimulationCases\"\n    \"Components\/Vehicle1D\/Model-Custom\"\n    \"Components\/Vehicle1D\/Utility-Vehicle1D\"\n    \"Components\/VehicleSpeedReference\"\n    \"Components\/VehicleSpeedReference\/SimulationCases\"\n    \"Components\/VehicleSpeedReference\/Utility\"\n    \"Components\/VehicleSpeedReference\/markdown\"\n    \"DetailedModelApplications\"\n    \"DetailedModelApplications\/MotorDrivePmsmFem\"\n    \"DetailedModelApplications\/MotorPmsmFem\"\n    \"Interface\"\n    \"Utility\"\n    \"Utility\/Checks\"\n    \"Utility\/LocalTasks\"\n    \"Utility\/SignalDesigner\"\n    \"Utility\/TestTools\"\n    \"cache\/buildtool-results\"\n    \"cache\/simcache\"\n\n","truncated":false}}
%---
%[output:015a3b94]
%   data: {"dataType":"text","outputData":{"text":"    \"\\Utility\\atProjectStartUp.m\"\n    \"\\BEVProjectDescription.html\"\n\n","truncated":false}}
%---
%[output:31122d6d]
%   data: {"dataType":"text","outputData":{"text":"\\cache\\simcache\n","truncated":false}}
%---
%[output:2accf8f6]
%   data: {"dataType":"text","outputData":{"text":"1219 files\n","truncated":false}}
%---
%[output:5ce03cfe]
%   data: {"dataType":"text","outputData":{"text":"    \"\\BEV\\BEV_system_model.mdl\"\n    \"\\BEV\\Utility\\Images\\BEV_system_model_screenshot.png\"\n\n","truncated":false}}
%---
%[output:559db94f]
%   data: {"dataType":"text","outputData":{"text":"14 referenced subsystems\n","truncated":false}}
%---
%[output:69f5c9d2]
%   data: {"dataType":"text","outputData":{"text":"    \"\\Components\\BEVController\\BEVController_refsub_Basic.mdl\"\n    \"\\Components\\BatteryHighVoltage\\BatteryHV_refsub_Basic.mdl\"\n    \"\\Components\\BatteryHighVoltage\\BatteryHV_refsub_System.mdl\"\n    \"\\Components\\BatteryHighVoltage\\BatteryHV_refsub_SystemSimple.mdl\"\n    \"\\Components\\BatteryHighVoltage\\BatteryHV_refsub_SystemTable.mdl\"\n    \"\\Components\\ControllerAndEnvironment\\CtrlEnv_refsub_Basic.mdl\"\n    \"\\Components\\MotorDriveUnit\\Model-Basic\\MotorDriveUnit_refsub_Basic.mdl\"\n    \"\\Components\\MotorDriveUnit\\Model-BasicThermal\\MotorDriveUnit_refsub_BasicThermal.mdl\"\n    \"\\Components\\MotorDriveUnit\\Model-SystemTable\\MotorDriveUnit_refsub_SystemTable.mdl\"\n    \"\\Components\\MotorDriveUnit\\Model-SystemThermal\\MotorDriveUnit_refsub_SystemThermal.mdl\"\n    \"\\Components\\Reducer\\Reducer_refsub_Basic.mdl\"\n    \"\\Components\\Vehicle1D\\Model-Basic\\Vehicle1D_refsub_Basic.mdl\"\n    \"\\Components\\Vehicle1D\\Model-Custom\\Vehicle1D_refsub_Custom.mdl\"\n    \"\\Components\\VehicleSpeedReference\\VehSpdRef_refsub_Basic.mdl\"\n\n","truncated":false}}
%---
%[output:86517736]
%   data: {"dataType":"text","outputData":{"text":"1 Simscape custom components\n","truncated":false}}
%---
%[output:8a0ff20b]
%   data: {"dataType":"text","outputData":{"text":"\\Components\\Vehicle1D\\Model-Custom\\Vehicle1D_Custom.ssc\n","truncated":false}}
%---
