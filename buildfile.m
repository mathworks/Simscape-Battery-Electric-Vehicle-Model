function plan = buildfile
% Check code, check project, and run tests.
% This function is used by MATLAB Build Tool to automate tasks such as
% checking code, checking project, or running tests.
%
% Overview of MATLAB Build Tool
% https://www.mathworks.com/help/matlab/matlab_prog/overview-of-matlab-build-tool.html
%
% Run Build from Toolstrip
% https://www.mathworks.com/help/matlab/matlab_prog/run-build-from-toolstrip.html

% Copyright 2023-2026 The MathWorks, Inc.

collection = matlab.buildtool.io.FileCollection.fromPaths(["**/*.m", "**/*.mlx"]);
% collection = select(collection, @(x) not(contains(x, ".git" + ("/"|"\"))));
% collection = select(collection, @(x) not(contains(x, ".github" + ("/"|"\"))));
% collection = select(collection, @(x) not(contains(x, "cache" + ("/"|"\"))));
collection = select(collection, @(x) not(contains(x, "buildfile" )));
collection = select(collection, @(x) not(contains(x, "Components" + ("/"|"\") + "ForTesting" )));
collection = select(collection, @(x) not(contains(x, "docs" + ("/"|"\") )));
collection = select(collection, @(x) not(contains(x, "resources" + ("/"|"\") )));
collection = select(collection, @(x) not(contains(x, "Utility" + ("/"|"\") + "ModelingUtilityForSimscape" )));

plan = buildplan();

% The CodeIssues task finishes quickly. Use it as the default task.
plan.DefaultTasks = "CodeIssues";

% https://www.mathworks.com/help/matlab/ref/matlab.buildtool.tasks.codeissuestask-class.html
% IncludeSubfolders = true, ...
plan("CodeIssues") = matlab.buildtool.tasks.CodeIssuesTask( ...
  SourceFiles = collection.paths, ...
  Results = [ ...
  "test-result/code-issues.mat" ...
  "test-result/code-issues.sarif" ...
  ] );

% Check the project. This is a custom task using matlab.buildtool.Task.
% https://www.mathworks.com/help/matlab/ref/matlab.buildtool.task-class.html
plan("CheckProject") = matlab.buildtool.Task( ...
  Description = "MATLAB project integrity checks", ...
  Actions = @action_check_project);

plan("CheckProject").Dependencies = "CodeIssues";

% https://www.mathworks.com/help/matlab/ref/matlab.buildtool.tasks.testtask-class.html
% IncludeSubfolders = true, ...
plan("Test") = matlab.buildtool.tasks.TestTask( ...
  Dependencies = "CheckProject", ...
  SourceFiles = collection.paths, ...
  TestResults = [
  "test-result/test-result.xml"
  "test-result/test-result.pdf"
  ], ...
  CodeCoverageResults = [
  "test-result/code-coverage.html"
  "test-result/code-coverage.xml"
  ] );

end  % function

function action_check_project(~)
checkProjectIssues_live
end  % local function
