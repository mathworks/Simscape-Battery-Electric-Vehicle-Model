%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022-2023 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr + ".")

PrjRoot = currentProject().RootFolder;

TopFolder = fullfile(PrjRoot, "Components", "Vehicle1D");
assert(isfolder(TopFolder))

%% Test Suite & Runner

suite_1 = matlab.unittest.TestSuite.fromFile( ...
  fullfile(TopFolder, "Test", "Vehicle1D_UnitTest.m"));

suite_MQC = matlab.unittest.TestSuite.fromFile( ...
  fullfile(TopFolder, "Test", "Vehicle1D_UnitTest_MQC.m"));

suite = [suite_1, suite_MQC];

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed );

%% JUnit Style Test Result

% Test result file is created. Don't check its existance.
TestResultFile = "Vehicle1D_TestResults_" + RelStr + ".xml";

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
  fullfile(TopFolder, "Test", TestResultFile));

addPlugin(runner, plugin)

%% MATLAB Code Coverage Report

CoverageReportFolder = fullfile(TopFolder, "coverage" + RelStr);
if not(isfolder(CoverageReportFolder))
  mkdir(CoverageReportFolder)
end

CoverageReportFile = "Vehicle1D_coverage_" + RelStr + ".html";

coverageReport = matlab.unittest.plugins.codecoverage.CoverageReport( ...
  CoverageReportFolder, ...
  MainFile = CoverageReportFile );

plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile( ...
  [ ...
  fullfile(TopFolder, "Harness", "Vehicle1D_harness_setup.m")
  ...
  fullfile(TopFolder, "SimulationCases", "Vehicle1D_simulationCase_Accelerate.mlx")
  fullfile(TopFolder, "SimulationCases", "Vehicle1D_simulationCase_Braking.mlx")
  fullfile(TopFolder, "SimulationCases", "Vehicle1D_simulationCase_Coastdown.mlx")
  fullfile(TopFolder, "SimulationCases", "Vehicle1D_simulationCase_Constant.mlx")
  ...
  fullfile(TopFolder, "Utility", "Configuration", "Vehicle1D_loadSimulationCase.m")
  fullfile(TopFolder, "Utility", "Configuration", "Vehicle1D_loadSimulationCase_Accelerate.m")
  fullfile(TopFolder, "Utility", "Configuration", "Vehicle1D_loadSimulationCase_Braking.m")
  fullfile(TopFolder, "Utility", "Configuration", "Vehicle1D_loadSimulationCase_Coastdown.m")
  fullfile(TopFolder, "Utility", "Configuration", "Vehicle1D_loadSimulationCase_Constant.m")
  ...
  fullfile(TopFolder, "Utility", "Vehicle1D_getLongitudinalVehicleInfo.m")
  fullfile(TopFolder, "Utility", "Vehicle1D_plotInputs.m")
  fullfile(TopFolder, "Utility", "Vehicle1D_plotProperties_Basic.m")
  fullfile(TopFolder, "Utility", "Vehicle1D_plotResults.m")
  fullfile(TopFolder, "Utility", "Vehicle1D_resetHarnessModel.m")
  ...
  fullfile(TopFolder, "Vehicle1D_refsub_Basic_params.m")
  ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%% Run tests
results = run(runner, suite);
assertSuccess(results)
