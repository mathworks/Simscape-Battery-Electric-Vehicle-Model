function plan = buildfile
%% Setup of the buildtool command for build, test, and coverage measurement.
% This function is used by buildtool to run tests and measure code coverage.
%
% Before running buildtool, cd to the folder where this file is stored.
%
% Running buildtool without any arguments starts the Code Analyzer for files
% in the current and child folders, and reports the result.
%
% Running `buildtool test` starts unittest.
% All the tests implemented in the current and child folders run.
% Code coverage is measured and reported too.
%
% See available tasks:
%   buildtool -tasks
%
% Run default tasks:
%   buildtool
%
% Run a task or tasks:
%   buildtool check
%   buildtool test
%   buildtool check test

% Overview of MATLAB Build Tool
% https://www.mathworks.com/help/matlab/matlab_prog/overview-of-matlab-build-tool.html
%
% The `buildtool` command uses the `buildfile` function.
% https://www.mathworks.com/help/matlab/ref/buildtool.html

% Copyright 2024-2025 The MathWorks, Inc.

plan = buildplan;

plan.DefaultTasks = "check";

%% Code check
% This provides a task for identifying code issues using the MATLAB Code Analyzer.
% https://www.mathworks.com/help/matlab/ref/matlab.buildtool.tasks.codeissuestask-class.html

plan("check") = matlab.buildtool.tasks.CodeIssuesTask( ...
  WarningThreshold = Inf, ...
  Results="test-result/code-issues.sarif");

% SARIF stands for Static Analysis Results Interchange Format and
% is an OASIS Standard that defines an output file format for static code analysis tools.
% https://sarifweb.azurewebsites.net/

%% Test
% This finds and runs all unit tests in the current and child folders.

plan("test") = matlab.buildtool.tasks.TestTask( ...
  ...
  ... Target files for testing and code coverage measurement
  SourceFiles = [ ...
    "**/*.m"
    "**/*.mlx"
  ], ...
  ...
  TestResults = [ ...
    "test-result/test-result.xml"
    "test-result/test-result.pdf"
    ], ...
  ...
  CodeCoverageResults = [ ...
    "test-result/code-coverage.html"
    "test-result/code-coverage.xml"
    ] );

end  % function
