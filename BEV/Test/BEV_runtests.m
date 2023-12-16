%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022-2023 The MathWorks, Inc.

relStr = matlabRelease().Release;
disp("This is MATLAB " + relStr + ".")

prjRoot = currentProject().RootFolder;

%% Test Suite & Runner

suite = matlab.unittest.TestSuite.fromFile( ...
  fullfile(prjRoot, "BEV", "Test", "BEV_UnitTest_MQC.m"));

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed );

%% JUnit Style Test Result

testResultFile = "TestResults_" + relStr + ".xml";

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
  fullfile(prjRoot, "BEV", "Test", testResultFile));

addPlugin(runner, plugin)

%% MATLAB Code Coverage Report

coverageReportFolder = fullfile(prjRoot, "BEV", "coverage" + relStr);
if not(isfolder(coverageReportFolder))
  mkdir(coverageReportFolder)
end

coverageReport = matlab.unittest.plugins.codecoverage.CoverageReport( ...
  coverageReportFolder, ...
  MainFile = "BEV_Coverage_" + relStr + "_BEV.html" );

plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile( ...
  [ ...
  fullfile(prjRoot, "BEV", "SimulationCases", "BEV_simulationCase_Constant_Basic.mlx")
  fullfile(prjRoot, "BEV", "SimulationCases", "BEV_simulationCase_Constant_Thermal.mlx")
  fullfile(prjRoot, "BEV", "SimulationCases", "BEV_simulationCase_FTP75_Basic.mlx")
  fullfile(prjRoot, "BEV", "SimulationCases", "BEV_simulationCase_HighSpeed_Basic.mlx")
  fullfile(prjRoot, "BEV", "SimulationCases", "BEV_simulationCase_SimpleDrivePattern_Basic.mlx")
  fullfile(prjRoot, "BEV", "SimulationCases", "BEV_simulationCase_SimpleDrivePattern_Thermal.mlx")
  fullfile(prjRoot, "BEV", "SimulationCases", "BEV_simulationCase_WLTP_Basic.mlx")
  ...
  fullfile(prjRoot, "BEV", "Utility", "Configuration", "BEV_useComponents_Basic.m")
  fullfile(prjRoot, "BEV", "Utility", "Configuration", "BEV_useComponents_Thermal.m")
  ...
  fullfile(prjRoot, "BEV", "Utility", "BEV_getMotorSpeedFromVehicleSpeed.m")
  fullfile(prjRoot, "BEV", "Utility", "BEV_plotResultsCompact.m")
  ...
  fullfile(prjRoot, "BEV", "BEV_main_script.mlx")
  fullfile(prjRoot, "BEV", "BEV_setup.m")
  ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%% Run tests
results = run(runner, suite);
assertSuccess(results)
