function plan = buildfile
%% Define and run tasks.
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

% Copyright 2023 The MathWorks, Inc.

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
  Results = "results/issues.sarif");

% Add a task to run tests.
plan("Test") = matlab.buildtool.tasks.TestTask( ...
  TestResults = ["results/test-results.xml", "results/test-results.pdf"], ...
  CodeCoverageResults = ["results/coverage.html", "results/coverage.xml"], ...
  SourceFiles = pwd);

plan("Clean") = matlab.buildtool.tasks.CleanTask;

%{
plan("jupyter").Inputs = "**/*.mlx";
plan("jupyter").Outputs = replace(plan("jupyter").Inputs, ".mlx", ".ipynb");
%}

%{
plan("LiveScriptToHTML").Inputs = "**/*.mlx";
plan("LiveScriptToHTML").Outputs = replace(plan("LiveScriptToHTML").Inputs, ".mlx", ".html");
%}

plan.DefaultTasks = ["CodeIssues", "lint", "Test"];

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


%{
function LiveScriptToJupyterNotebookTask(context)
%% Export Live Scripts to Jupyter notebooks
arguments
  context (1,1) matlab.buildtool.TaskContext
end
mlxFiles = context.Task.Inputs.paths;
ipynbFiles = context.Task.Outputs.paths;
for idx = 1:numel(mlxFiles)
  disp("Generating Jupyter notebook from Live Script:")
  disp("  " + mlxFiles(idx))

  export(mlxFiles(idx), ipynbFiles(idx), Run=true)

end  % for
end  % function
%}


%{
function LiveScriptToHTMLTask(context)
%% Export Live Scripts to HTML
arguments
  context (1,1) matlab.buildtool.TaskContext
end
mlxFiles = context.Task.Inputs.paths;
docFiles = context.Task.Outputs.paths;
for idx = 1:numel(mlxFiles)
  disp("Generating HTML from Live Script:")
  disp("  " + mlxFiles(idx))

  export(mlxFiles(idx), docFiles(idx), Run=true)

end  % for
end  % function
%}


function CheckProjectTask(~)
%% Run MATLAB project integrity checks

BEVProject_CheckProject

end  % function
