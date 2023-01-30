%% Script to run unit tests
% This script runs tests for component-level and system-level tests.
% Note that tests for detailed model applications are not run
% to aoivd long-running tests.

% Copyright 2021-2023 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr + ".")

TopFolder = currentProject().RootFolder;

%% Create test suite

suite_0 = matlab.unittest.TestSuite.fromFile( ...
  fullfile(TopFolder, "Test", "BEVProject_UnitTest_MQC.m"));

disp("Building test suite for component-level tests.")
suite_1 = matlab.unittest.TestSuite.fromFolder( ...
  fullfile(TopFolder, "Components"), ...
  IncludingSubfolders = true);

disp("Building test suite for system-level tests.")
suite_2 = matlab.unittest.TestSuite.fromFolder( ...
  fullfile(TopFolder, "BEV"), ...
  IncludingSubfolders = true);

suite = [suite_0, suite_1, suite_2];

disp("### Not building test suite for detailed model applications.")

%% Create test runner

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed);

%% JUnit style test result

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
  fullfile(TopFolder, "Test", "BEV_TestResults_"+RelStr+".xml"));

addPlugin(runner, plugin)

%% Run tests

results = run(runner, suite);

assertSuccess(results)
