%% Script to run unit tests
% This script runs all the unit tests that are the child classes of
% matlab.unittest.TestCase in the project.
% Unit test classes are automatically detected by
% the matlab.unittest.TestSuite.fromFolder function.

% Copyright 2021-2022 The MathWorks, Inc.

relstr = matlabRelease().Release;
disp("This is MATLAB " + relstr)

%% Create test suite

prjroot = currentProject().RootFolder;

suite = matlab.unittest.TestSuite.fromFolder(prjroot, "IncludingSubfolders",true);

%% Create test runner

runner = matlab.unittest.TestRunner.withTextOutput( ...
          "OutputDetail", matlab.unittest.Verbosity.Detailed);

%% JUnit style test result

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
          fullfile("test", "TestResults_"+relstr+".xml"));

addPlugin(runner, plugin)

%% Run tests

results = run(runner, suite);

disp(results)
