%% Script to run unit tests
% This script runs tests for component-level and system-level tests.
% Note that tests for detailed model applications are not run
% to aoivd long-running tests.

% Copyright 2021-2023 The MathWorks, Inc.

relStr = matlabRelease().Release;
disp("This is MATLAB " + relStr + ".")

topFolder = currentProject().RootFolder;

%% Create test suite

suite = matlab.unittest.TestSuite.fromProject( currentProject );

%disp("### Not building test suite for detailed model applications.")

%% Create test runner

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed);

%% JUnit style test result

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
  fullfile(topFolder, "Test", "BEV_TestResults_"+relStr+".xml"));

addPlugin(runner, plugin)

%% MATLAB Code Coverage Report

coverageReportFolder = fullfile(topFolder, "coverage" + relStr);
if not(isfolder(coverageReportFolder))
  mkdir(coverageReportFolder)
end

coverageReport = matlab.unittest.plugins.codecoverage.CoverageReport( ...
  coverageReportFolder, ...
  MainFile = "Project_Coverage_" + relStr + ".html" );

plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile( ...
  [ ...
  fullfile(topFolder, "Interface", "defineBus_HighVoltage.m")
  fullfile(topFolder, "Interface", "defineBus_Rotational.m")
  ...
  fullfile(topFolder, "Test", "CheckProject", "BEVProject_CheckProject.mlx")
  ...
  fullfile(topFolder, "Utility", "Checks", "checkCallbackButton.m")
  ...
  fullfile(topFolder, "Utility", "SignalDesigner", "+SignalDesignUtility", "buildTrace.m")
  fullfile(topFolder, "Utility", "SignalDesigner", "+SignalDesignUtility", "buildXYData.m")
  fullfile(topFolder, "Utility", "SignalDesigner", "+SignalSourceBlockCallback", "plotContinuous.m")
  fullfile(topFolder, "Utility", "SignalDesigner", "+SignalSourceBlockCallback", "plotContinuousMultiStep.m")
  fullfile(topFolder, "Utility", "SignalDesigner", "+SignalSourceBlockCallback", "plotPieceWiseConstant.m")
  fullfile(topFolder, "Utility", "SignalDesigner", "+SignalSourceBlockCallback", "plotTraceGenerator.m")
  fullfile(topFolder, "Utility", "SignalDesigner", "+SignalSourceBlockCallback", "setDataToLookupTableBlock.m")
  fullfile(topFolder, "Utility", "SignalDesigner", "SignalDesigner.m")
  fullfile(topFolder, "Utility", "SignalDesigner", "SignalDesigner_example.mlx")
  ...
  fullfile(topFolder, "Utility", "AboutBEVProject.mlx")
  fullfile(topFolder, "Utility", "adjustFigureHeightAndWindowYPosition.m")
  fullfile(topFolder, "Utility", "atProjectStartUp.m")
  fullfile(topFolder, "Utility", "generateHTML.m")
  fullfile(topFolder, "Utility", "getSimscapeValueFromBlockParameter.m")
  fullfile(topFolder, "Utility", "plotSimulationResultSignal.m")
  fullfile(topFolder, "Utility", "setMinimumYRange.m")
  fullfile(topFolder, "Utility", "verifyBlockCheckbox_custom.m")
  fullfile(topFolder, "Utility", "verifyBlockDropdown_custom.m")
  fullfile(topFolder, "Utility", "verifyBlockInitialPriority_custom.m")
  fullfile(topFolder, "Utility", "verifyBlockParameter_custom.m")
  ...
  fullfile(topFolder, "BEVProject_main_script.mlx")
  ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%% Run tests
results = run(runner, suite);
assertSuccess(results)
