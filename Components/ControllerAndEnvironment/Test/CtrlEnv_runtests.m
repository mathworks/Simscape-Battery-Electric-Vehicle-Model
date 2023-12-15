%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2023 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr + ".")

PrjRoot = currentProject().RootFolder;

TopFolder = fullfile(PrjRoot, "Components", "ControllerAndEnvironment");
assert(isfolder(TopFolder))

%% Test Suite & Runner

suite_MQC = matlab.unittest.TestSuite.fromFile( ...
  fullfile(TopFolder, "Test", "CtrlEnv_UnitTest_MQC.m"));

suite = suite_MQC;

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed );

%% JUnit Style Test Result

% Test result file is created. Don't check its existance.
TestResultFile = "CtrlEnv_TestResults_" + RelStr + ".xml";

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
  fullfile(TopFolder, "Test", TestResultFile));

addPlugin(runner, plugin)

%% MATLAB Code Coverage Report

CoverageReportFolder = fullfile(TopFolder, "coverage" + RelStr);
if not(isfolder(CoverageReportFolder))
  mkdir(CoverageReportFolder)
end

CoverageReportFile = "CtrlEnv_coverage_" + RelStr + ".html";

coverageReport = matlab.unittest.plugins.codecoverage.CoverageReport( ...
  CoverageReportFolder, ...
  MainFile = CoverageReportFile );

plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile( ...
  [ ...
  fullfile(TopFolder, "Harness", "CtrlEnv_harness_setup.m")
  ...
  fullfile(TopFolder, "SimulationCases", "CtrlEnv_simulationCase_Constant.mlx")
  fullfile(TopFolder, "SimulationCases", "CtrlEnv_simulationCase_FTP75.mlx")
  fullfile(TopFolder, "SimulationCases", "CtrlEnv_simulationCase_HighSpeed.mlx")
  fullfile(TopFolder, "SimulationCases", "CtrlEnv_simulationCase_SimpleDrivePattern.mlx")
  fullfile(TopFolder, "SimulationCases", "CtrlEnv_simulationCase_WLTP.mlx")
  ...
  fullfile(TopFolder, "Utility", "Configuration", "CtrlEnv_loadSimulationCase.m")
  fullfile(TopFolder, "Utility", "Configuration", "CtrlEnv_loadSimulationCase_Constant.m")
  fullfile(TopFolder, "Utility", "Configuration", "CtrlEnv_loadSimulationCase_FTP75.m")
  fullfile(TopFolder, "Utility", "Configuration", "CtrlEnv_loadSimulationCase_HighSpeed.m")
  fullfile(TopFolder, "Utility", "Configuration", "CtrlEnv_loadSimulationCase_SimpleDrivePattern.m")
  fullfile(TopFolder, "Utility", "Configuration", "CtrlEnv_loadSimulationCase_WLTP.m")
  ...
  fullfile(TopFolder, "Utility", "CtrlEnv_plotResults.m")
  ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%% Run tests
results = run(runner, suite);
assertSuccess(results)
