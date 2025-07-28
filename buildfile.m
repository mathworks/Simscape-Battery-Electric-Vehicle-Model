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

% Create a build plan from local functions.
plan = buildplan();

% The CodeIssues task finishes quickly. Use it as the default task.
plan.DefaultTasks = "CodeIssues";

% https://www.mathworks.com/help/matlab/ref/matlab.buildtool.tasks.codeissuestask-class.html
plan("CodeIssues") = matlab.buildtool.tasks.CodeIssuesTask( ...
  SourceFiles = ".", ...
  IncludeSubfolders = true, ...
  Results = [ ...
  "test-result/code-issues.mat" ...
  "test-result/code-issues.sarif" ...
  ] );

% Add a custom task using matlab.buildtool.Task.
% https://www.mathworks.com/help/matlab/ref/matlab.buildtool.task-class.html
plan("CheckProject") = matlab.buildtool.Task( ...
  Description = "MATLAB project integrity checks", ...
  Actions = @action_check_project);

plan("CheckProject").Dependencies = "CodeIssues";

% https://www.mathworks.com/help/matlab/ref/matlab.buildtool.tasks.testtask-class.html
plan("Test") = matlab.buildtool.tasks.TestTask( ...
  Dependencies = ["CodeIssues", "CheckProject"], ...
  ...
  SourceFiles = [
  "BEV"
  "Components"
  "FYI"
  "Interface"
  "Utility"
  ], ...
  IncludeSubfolders = true, ...
  ...
  TestResults = [
  "test-result/test-results.xml"
  "test-result/test-results.pdf"
  ], ...
  CodeCoverageResults = [
  "test-result/code-coverage.html"
  "test-result/code-coverage.xml"
  ] );

end  % function

function action_check_project(~)
BEVProject_CheckProject
end  % function
