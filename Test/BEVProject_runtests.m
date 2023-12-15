function BEVProject_runtests()
%% Script to run unit tests
% This script runs tests for component-level and system-level tests.
% Note that tests for detailed model applications are not run
% to avoid long-running tests.

% Copyright 2021-2023 The MathWorks, Inc.

rel_str = matlabRelease().Release;
disp("This is MATLAB " + rel_str + ".")

top_folder = currentProject().RootFolder;

%% Create test suite

suite = matlab.unittest.TestSuite.fromProject( currentProject );

%% Create test runner

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed);

%% JUnit style test result

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
  fullfile(top_folder, "Test", "BEV_TestResults_"+rel_str+".xml"));

addPlugin(runner, plugin)

%% MATLAB Code Coverage Report

coverage_report_folder = fullfile(top_folder, "coverage" + rel_str);

coverage_report_object = matlab.unittest.plugins.codecoverage.CoverageReport( ...
  coverage_report_folder, ...
  MainFile = "Project_Coverage_" + rel_str + ".html" );

plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile( ...
  [ ...
  fullfile(top_folder, "Interface", "defineBus_HighVoltage.m")
  fullfile(top_folder, "Interface", "defineBus_Rotational.m")
  ...
  fullfile(top_folder, "Test", "CheckProject", "BEVProject_CheckProject.mlx")
  ...
  fullfile(top_folder, "Utility", "Checks", "checkCallbackButton.m")
  ...
  fullfile(top_folder, "Utility", "SignalDesigner", "+SignalDesignUtility", "buildTrace.m")
  fullfile(top_folder, "Utility", "SignalDesigner", "+SignalDesignUtility", "buildXYData.m")
  fullfile(top_folder, "Utility", "SignalDesigner", "+SignalSourceBlockCallback", "plotContinuous.m")
  fullfile(top_folder, "Utility", "SignalDesigner", "+SignalSourceBlockCallback", "plotContinuousMultiStep.m")
  fullfile(top_folder, "Utility", "SignalDesigner", "+SignalSourceBlockCallback", "plotPieceWiseConstant.m")
  fullfile(top_folder, "Utility", "SignalDesigner", "+SignalSourceBlockCallback", "plotTraceGenerator.m")
  fullfile(top_folder, "Utility", "SignalDesigner", "+SignalSourceBlockCallback", "setDataToLookupTableBlock.m")
  fullfile(top_folder, "Utility", "SignalDesigner", "SignalDesigner.m")
  fullfile(top_folder, "Utility", "SignalDesigner", "SignalDesigner_example.mlx")
  ...
  fullfile(top_folder, "Utility", "AboutBEVProject.mlx")
  fullfile(top_folder, "Utility", "adjustFigureHeightAndWindowYPosition.m")
  fullfile(top_folder, "Utility", "atProjectStartUp.m")
  fullfile(top_folder, "Utility", "generateHTML.m")
  fullfile(top_folder, "Utility", "getSimscapeValueFromBlockParameter.m")
  fullfile(top_folder, "Utility", "plotSimulationResultSignal.m")
  fullfile(top_folder, "Utility", "setMinimumYRange.m")
  fullfile(top_folder, "Utility", "verifyBlockCheckbox_custom.m")
  fullfile(top_folder, "Utility", "verifyBlockDropdown_custom.m")
  fullfile(top_folder, "Utility", "verifyBlockInitialPriority_custom.m")
  fullfile(top_folder, "Utility", "verifyBlockParameter_custom.m")
  ], ...
  Producing = coverage_report_object );

addPlugin(runner, plugin)

%% Run tests

results = run(runner, suite);

assertSuccess(results)

end  % function
