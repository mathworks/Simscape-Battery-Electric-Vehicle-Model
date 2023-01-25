%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr + ".")

TopFolder = currentProject().RootFolder;

%% Create test suite

suite = matlab.unittest.TestSuite.fromFile( ...
  fullfile(TopFolder, "Test", "CheckProject", "BEVProject_CheckProject_UnitTest.m"));

%% Create test runner

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed );

%% JUnit Style Test Result

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
  fullfile(TopFolder, "Test", "CheckProject", "BEVProject_CheckProject_TestResults_"+RelStr+".xml"));

addPlugin(runner, plugin)

%% Run tests

results = run(runner, suite);

assertSuccess(results)
