function plan = buildfile
%% Check code, check project, and run tests
% This function is used by MATLAB Build Tool to automate tasks such as
% checking code, checking project, or running tests.
%
% Overview of MATLAB Build Tool
% https://www.mathworks.com/help/matlab/matlab_prog/overview-of-matlab-build-tool.html
%
% Run Build from Toolstrip
% https://www.mathworks.com/help/matlab/matlab_prog/run-build-from-toolstrip.html

% Copyright 2023-2025 The MathWorks, Inc.

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

% Default tasks must finish quickly.
% The Test task can take long time, thus it is not added to the default tasks.
plan.DefaultTasks = "CodeIssues";

plan("CodeIssues") = matlab.buildtool.tasks.CodeIssuesTask( ...
  SourceFiles = ".", ...
  IncludeSubfolders = true, ...
  Results = [ ...
  "cache/buildtool-results/code-issues.mat" ...
  "cache/buildtool-results/code-issues.sarif" ...
  ] );

% This is a custom task. See the CheckProjectTask local function implemented
% below this function.
plan("CheckProject").Dependencies = "CodeIssues";

plan("Test") = matlab.buildtool.tasks.TestTask( ...
  Dependencies = ["CodeIssues", "CheckProject"], ...
  ...
  SourceFiles = [
  "BEV"
  "Components"
  "Interface"
  "Utility"
  ], ...
  IncludeSubfolders = true, ...
  ...
  TestResults = [
  "cache/buildtool-results/test-results.xml"
  "cache/buildtool-results/test-results.pdf"
  ], ...
  CodeCoverageResults = [
  "cache/buildtool-results/code-coverage.html"
  "cache/buildtool-results/code-coverage.xml"
  ] );

%plan("Clean") = matlab.buildtool.tasks.CleanTask;

% plan("LiveScriptToJupyterNotebook").Inputs = "**/*.mlx";
% plan("LiveScriptToJupyterNotebook").Outputs = ...
%   replace(plan("LiveScriptToJupyterNotebook").Inputs, ".mlx", ".ipynb");

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
function LiveScriptToMarkdownTask(context)
%% Export Live Scripts to Markdown files
%
%   buildtool LiveScriptToMarkdown

arguments
  context (1,1) matlab.buildtool.TaskContext
end
mlxFiles = context.Task.Inputs.paths;
mdFiles = context.Task.Outputs.paths;
for idx = 1:numel(mlxFiles)
  disp("Generating Markdown file from Live Script:")
  disp("  " + mlxFiles(idx))

  LiveScript_Utility.CheckAndGenerateMarkdown(mlxFiles(idx))
  % export(mlxFiles(idx), mdFiles(idx), Run=true);

end  % for
end  % function
%}

function CheckProjectTask(~)
%% Run MATLAB project integrity checks
%
%   buildtool CheckProject

BEVProject_CheckProject

end  % function
