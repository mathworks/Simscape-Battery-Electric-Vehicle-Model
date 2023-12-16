function plan = buildfile
%% Define and run tasks.

% Copyright 2023 The MathWorks, Inc.

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
  fullfile(top_folder, "Components", "MotorDriveUnit", "Test", "MotorDriveUnit_UnitTest_MQC.m")
  ...
  fullfile(top_folder, "Components", "Vehicle1D", "Test", "Vehicle1D_UnitTest_MQC.m")
  ...
  fullfile(top_folder, "Components", "VehicleSpeedReference", "Test", "VehSpdRef_UnitTest_MQC.m")
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
%   buildtool LiveScriptToJupyterNotebook
%   buildtool Clean

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

% Add a task to identify code issues.
plan("CodeIssues") = matlab.buildtool.tasks.CodeIssuesTask( ...
  Results = "cache/buildtool-results/code-issues.sarif");

plan("CheckProject").Dependencies = "CodeIssues";

% Add a task to run tests.
plan("Test") = matlab.buildtool.tasks.TestTask( ...
  SourceFiles = pwd, ...
  TestResults = [
  "cache/buildtool-results/test-results.xml"
  "cache/buildtool-results/test-results.pdf"
  ], ...
  CodeCoverageResults = [
  "cache/buildtool-results/code-coverage.html"
  "cache/buildtool-results/code-coverage.xml"
  ] );

plan("Test").Dependencies = ["CodeIssues" "CheckProject"];

plan("Test").Tests = test_definitions;

plan("Clean") = matlab.buildtool.tasks.CleanTask;

plan("LiveScriptToJupyterNotebook").Inputs = "**/*.mlx";
plan("LiveScriptToJupyterNotebook").Outputs = ...
  replace(plan("LiveScriptToJupyterNotebook").Inputs, ".mlx", ".ipynb");

plan.DefaultTasks = [
  "CodeIssues"
  "CheckProject"
  "Test"
  ];

end  % function


%% Local functions == task functions
% Task functions are local functions in the build file (this file).
%
% - Function name must end with the word "Task", which is case insensitive.
%   The build tool generates task names from task function names
%   by removing the "Task" suffix.
%   For example, a task function `testTask` results in a task named "test".
%
% - A task function must accept a TaskContext object as its first input,
%   even if the task ignores it.
%
% - The build tool treats the first help text line,
%   often called the H1 line, of the task function as the task description.


function LiveScriptToJupyterNotebookTask(context)
%% Export Live Scripts to Jupyter notebooks
%
%   buildtool LiveScriptToJupyterNotebook

arguments
  context (1,1) matlab.buildtool.TaskContext
end
mlxFiles = context.Task.Inputs.paths;
ipynbFiles = context.Task.Outputs.paths;
for idx = 1:numel(mlxFiles)
  disp("Generating Jupyter notebook from Live Script:")
  disp("  " + mlxFiles(idx))

  export(mlxFiles(idx), ipynbFiles(idx), Run=true);

end  % for
end  % function


function CheckProjectTask(~)
%% Run MATLAB project integrity checks
%
%   buildtool CheckProject

BEVProject_CheckProject

end  % function
