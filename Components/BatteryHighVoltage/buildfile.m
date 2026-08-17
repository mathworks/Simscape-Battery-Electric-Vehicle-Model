function plan = buildfile
% Define tasks for the buildtool to check code and run tests.
% In the Editor, use the "Run Build" button to start a task.

% Overview of MATLAB Build Tool
% https://www.mathworks.com/help/matlab/matlab_prog/overview-of-matlab-build-tool.html
%
% Run Build from Toolstrip
% https://www.mathworks.com/help/matlab/matlab_prog/run-build-from-toolstrip.html

% Copyright 2023-2026 The MathWorks, Inc.

plan = buildplan();
plan.DefaultTasks = "CodeIssues";

plan("CodeIssues") = matlab.buildtool.tasks.CodeIssuesTask( ...
  WarningThreshold = Inf, ...
  SourceFiles = ["**/*.m", "**/*.mlx"], ...
  Results = "test-result/code-issues.sarif" );

collection = matlab.buildtool.io.FileCollection.fromPaths(["**/*.m", "**/*.mlx"]);
collection = select(collection, @(x) not(contains(x, "buildfile")));

plan("Test") = matlab.buildtool.tasks.TestTask( ...
  Dependencies = "CodeIssues", ...
  SourceFiles = collection.paths, ...
  TestResults = "test-result/test-result.pdf", ...
  CodeCoverageResults = "test-result/code-coverage.html" );

end  % function
