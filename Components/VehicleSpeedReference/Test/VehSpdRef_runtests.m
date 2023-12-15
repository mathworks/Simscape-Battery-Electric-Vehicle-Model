%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022-2023 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr + ".")

PrjRoot = currentProject().RootFolder;

TopFolder = fullfile(PrjRoot, "Components", "VehicleSpeedReference");
assert(isfolder(TopFolder))

%% Test Suite & Runner

suite_MQC = matlab.unittest.TestSuite.fromFile( ...
  fullfile(TopFolder, "Test", "VehSpdRef_UnitTest_MQC.m"));

suite = suite_MQC;

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed );

%% JUnit Style Test Result

% Test result file is created. Don't check its existance.
TestResultFile = "VehSpdRef_TestResults_" + RelStr + ".xml";

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
  fullfile(TopFolder, "Test", TestResultFile));

addPlugin(runner, plugin)

%% MATLAB Code Coverage Report

CoverageReportFolder = fullfile(TopFolder, "coverage" + RelStr);
if not(isfolder(CoverageReportFolder))
  mkdir(CoverageReportFolder)
end

CoverageReportFile = "VehSpdRef_coverage_" + RelStr + ".html";

coverageReport = matlab.unittest.plugins.codecoverage.CoverageReport( ...
  CoverageReportFolder, ...
  MainFile = CoverageReportFile );

plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile( ...
  [ ...
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_simulationCase_Constant.mlx")
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_simulationCase_FTP75.mlx")
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_simulationCase_HighSpeed.mlx")
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_simulationCase_SimpleDrivePattern.mlx")
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_simulationCase_WLTP.mlx")
  ...
  fullfile(TopFolder, "Utility", "Configuration", "VehSpdRef_loadSimulationCase.m")
  fullfile(TopFolder, "Utility", "Configuration", "VehSpdRef_loadSimulationCase_Constant.m")
  fullfile(TopFolder, "Utility", "Configuration", "VehSpdRef_loadSimulationCase_FTP75.m")
  fullfile(TopFolder, "Utility", "Configuration", "VehSpdRef_loadSimulationCase_HighSpeed.m")
  fullfile(TopFolder, "Utility", "Configuration", "VehSpdRef_loadSimulationCase_SimpleDrivePattern.m")
  fullfile(TopFolder, "Utility", "Configuration", "VehSpdRef_loadSimulationCase_WLTP.m")
  ...
  fullfile(TopFolder, "Utility", "VehSpdRef_plotResults.m")
  ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%% Run tests
results = run(runner, suite);
assertSuccess(results)
