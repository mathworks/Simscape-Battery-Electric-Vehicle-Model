%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022-2023 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr + ".")

TopFolder = fullfile(currentProject().RootFolder, "Components", "MotorDriveUnit");

%% Test suite and runner

suite = matlab.unittest.TestSuite.fromFile( ...
  fullfile(TopFolder, "Test", "MotorDriveUnit_UnitTest_MQC.m"));

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed );

%% JUnit Style Test Result

TestResultFile = "MotorDriveUnit_TestResults_" + RelStr + ".xml";

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
  fullfile(TopFolder, "Test", TestResultFile));

addPlugin(runner, plugin)

%% MATLAB Code Coverage Report

CoverageReportFolder = fullfile(TopFolder, "coverage" + RelStr);
if not(isfolder(CoverageReportFolder))
  mkdir(CoverageReportFolder)
end

coverageReport = matlab.unittest.plugins.codecoverage.CoverageReport( ...
  CoverageReportFolder, ...
  MainFile = "MotorDriveUnit_Coverage_" + RelStr + ".html" );

plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile( ...
  [ ...
  fullfile(TopFolder, "Configuration", "MotorDriveUnit_loadSimulationCase.m")
  fullfile(TopFolder, "Configuration", "MotorDriveUnit_loadSimulationCase_Constant.m")
  fullfile(TopFolder, "Configuration", "MotorDriveUnit_loadSimulationCase_Drive.m")
  fullfile(TopFolder, "Configuration", "MotorDriveUnit_loadSimulationCase_Random.m")
  fullfile(TopFolder, "Configuration", "MotorDriveUnit_loadSimulationCase_RegenBrake.m")
  fullfile(TopFolder, "Configuration", "MotorDriveUnit_setInitialConditions.m")
  fullfile(TopFolder, "Configuration", "MotorDriveUnit_useRefsub.m")
  fullfile(TopFolder, "Configuration", "MotorDriveUnit_useRefsub_Basic.m")
  fullfile(TopFolder, "Configuration", "MotorDriveUnit_useRefsub_BasicThermal.m")
  fullfile(TopFolder, "Configuration", "MotorDriveUnit_useRefsub_Tabulated.m")
  fullfile(TopFolder, "Harness", "MotorDriveUnit_harness_setup.m")
  fullfile(TopFolder, "Notes", "MotorDriveUnit_note_Efficiency_Basic.mlx")
  fullfile(TopFolder, "Notes", "MotorDriveUnit_note_Efficiency_BasicThermal.mlx")
  fullfile(TopFolder, "TestCases", "MotorDriveUnit_testcase_Constant.mlx")
  fullfile(TopFolder, "TestCases", "MotorDriveUnit_testcase_Drive.mlx")
  fullfile(TopFolder, "TestCases", "MotorDriveUnit_testcase_Random.mlx")
  fullfile(TopFolder, "TestCases", "MotorDriveUnit_testcase_RegenBrake.mlx")
  fullfile(TopFolder, "Utility", "MotorDriveUnit_getBlockInfo_Basic.m")
  fullfile(TopFolder, "Utility", "MotorDriveUnit_plotEfficiency.m")
  fullfile(TopFolder, "Utility", "MotorDriveUnit_plotEfficiency_Basic.m")
  fullfile(TopFolder, "MotorDriveUnit_refsub_Basic_params.m")
  fullfile(TopFolder, "MotorDriveUnit_refsub_BasicThermal_params.m")
  fullfile(TopFolder, "MotorDriveUnit_refsub_Tabulated_params.m")
  ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%% Run tests
results = run(runner, suite);
assertSuccess(results)
