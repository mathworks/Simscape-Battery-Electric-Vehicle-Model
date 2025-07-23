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
plan = buildplan(localfunctions);

% CodeIssues task finish quickly. Use it as the default task.
plan.DefaultTasks = "CodeIssues";

% https://www.mathworks.com/help/matlab/ref/matlab.buildtool.tasks.codeissuestask-class.html
plan("CodeIssues") = matlab.buildtool.tasks.CodeIssuesTask( ...
  SourceFiles = ".", ...
  IncludeSubfolders = true, ...
  Results = [ ...
  "cache/buildtool-results/code-issues.mat" ...
  "cache/buildtool-results/code-issues.sarif" ...
  ] );

plan("CheckProject").Dependencies = "CodeIssues";

% https://www.mathworks.com/help/matlab/ref/matlab.buildtool.tasks.testtask-class.html
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

end  % function

function CheckProjectTask(~)
%% Run MATLAB project integrity checks
BEVProject_CheckProject
end  % function
