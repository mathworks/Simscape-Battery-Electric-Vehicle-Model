function plan = buildfile_24b
%% Define and run tasks.
% buildtool -buildFile buildfile_24b.m -verbosity Verbose CodeIssues CheckProject Test

% Copyright 2023-2026 The MathWorks, Inc.

top_folder = currentProject().RootFolder;

test_definitions = [ 
  fullfile(top_folder, "BEV", "Test", "BEV_UnitTest_MQC.m")
  ...
  fullfile(top_folder, "Components", "BatteryHighVoltage", "Test", "BatteryHV_UnitTest.m")
  fullfile(top_folder, "Components", "BatteryHighVoltage", "Test", "BatteryHV_UnitTest_MQC.m")
  ...
  fullfile(top_folder, "Components", "BEVController", "Test", "BEVController_UnitTest_MQC.m")
  ...
  fullfile(top_folder, "Components", "ControllerAndEnvironment", "Test", "CtrlEnv_UnitTest_MQC.m")
  ...
  fullfile(top_folder, "Components", "MotorDriveUnit", "Model-Basic", "MotorDriveUnit_test_Basic.m")
  fullfile(top_folder, "Components", "MotorDriveUnit", "Model-Basic", "SimulationCases", "MotorDriveUnit_test_Basic_simulation_cases.m")
  fullfile(top_folder, "Components", "MotorDriveUnit", "Model-BasicThermal", "MotorDriveUnit_test_BasicThermal.m")
  fullfile(top_folder, "Components", "MotorDriveUnit", "Model-BasicThermal", "SimulationCases", "MotorDriveUnit_test_BasicThermal_simulation_cases.m")
  fullfile(top_folder, "Components", "MotorDriveUnit", "Model-SystemTable", "MotorDriveUnit_test_SystemTable.m")
  fullfile(top_folder, "Components", "MotorDriveUnit", "Model-SystemTable", "SimulationCases", "MotorDriveUnit_test_System_simulation_cases.m")
  fullfile(top_folder, "Components", "MotorDriveUnit", "Model-SystemThermal", "MotorDriveUnit_test_SystemThermal.m")
  fullfile(top_folder, "Components", "MotorDriveUnit", "Model-SystemThermal", "SimulationCases", "MotorDriveUnit_test_SystemThermal_simulation_cases.m")
  fullfile(top_folder, "Components", "MotorDriveUnit", "Utility-MDU", "MotorDriveUnit_test_Utility_MDU.m")
  fullfile(top_folder, "Components", "MotorDriveUnit", "MotorDriveUnit_test.m")
  ...
  fullfile(top_folder, "Components", "Vehicle1D", "Model-Basic", "SimulationCases", "Vehicle1D_test_Basic_simulation_cases.m")
  fullfile(top_folder, "Components", "Vehicle1D", "Model-Basic", "Vehicle1D_Basic_test.m")
  fullfile(top_folder, "Components", "Vehicle1D", "Utility-Vehicle1D", "Vehicle1D_test_Utility.m")
  fullfile(top_folder, "Components", "Vehicle1D", "Utility-Vehicle1D", "Vehicle1DPerformance_test.m")
  fullfile(top_folder, "Components", "Vehicle1D", "Utility-Vehicle1D", "Vehicle1DPerformance_uitest.m")
  fullfile(top_folder, "Components", "Vehicle1D", "Vehicle1D_test.m")
  fullfile(top_folder, "Components", "Vehicle1D", "Vehicle1DPerformanceDesignApp_uitest.m")
  ...
  fullfile(top_folder, "Components", "VehicleSpeedReference", "VehSpdRef_harness_model_test.m")
  fullfile(top_folder, "Components", "VehicleSpeedReference", "SimulationCases", "VehSpdRef_Case_test.m")
  ...
  fullfile(top_folder, "Test", "BEVProject_UnitTest_MQC.m")
  ];

% This function runs tasks such as identifing code issues,
% running tests, or performing your custom tasks.
% To see available tasks, run the following command in MATLAB Command Window.
%
%   buildtool -tasks
%
% This function uses MATLAB build tool API, which was first released in R2022b.
% Incremental builds are supported since R2023a.
% Task for running tests is supported since R2023b.
% For information about MATLAB build tool, see the documentation:
%
% - Overview of MATLAB Build Tool
%   https://mathworks.com/help/matlab/matlab_prog/overview-of-matlab-build-tool.html
%
% - Improve Performance with Incremental Builds
%   https://mathworks.com/help/matlab/matlab_prog/improve-performance-with-incremental-builds.html
%
% - Task for running tests
%   https://mathworks.com/help/matlab/ref/matlab.buildtool.tasks.testtask-class.html

%   buildtool -tasks
%   buildtool CodeIssues
%   buildtool CheckProject
%   buildtool Test
%   buildtool Clean
%   buildtool CodeIssues CheckProject Test

%%
% Create a build plan from task functions.
%
% `localfunctions` returns a cell array of function handles
% to all local functions in the current file.
%
% For information about buildplan, see the documentation:
% - https://mathworks.com/help/matlab/ref/buildplan.html
%
plan = buildplan(localfunctions);
plan.DefaultTasks = [
  "CodeIssues"
  "CheckProject"
  "Test"
  ];

% Add a task to identify code issues.
plan("CodeIssues") = matlab.buildtool.tasks.CodeIssuesTask( ...
  Results = "test-result-24b/code-issues.sarif");

plan("CheckProject").Dependencies = "CodeIssues";

% Add a task to run tests.
plan("Test") = matlab.buildtool.tasks.TestTask( ...
  Dependencies = "CodeIssues", ...
  SourceFiles = pwd, ...
  TestResults = [
  "test-result-24b/test-result.xml"
  "test-result-24b/test-result.pdf"
  ], ...
  CodeCoverageResults = [
  "test-result-24b/code-coverage.html"
  "test-result-24b/code-coverage.xml"
  ] );

plan("Test").Tests = test_definitions;

plan("Clean") = matlab.buildtool.tasks.CleanTask;

end  % function

function CheckProjectTask(~)
BEVProject_CheckProject
end  % local function
