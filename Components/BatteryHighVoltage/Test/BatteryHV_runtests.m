%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022-2023 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr + ".")

TopFolder = fullfile(currentProject().RootFolder, "Components", "BatteryHighVoltage");

%% Test Suite & Runner

suite_1 = matlab.unittest.TestSuite.fromFile( ...
  fullfile(TopFolder, "Test", "BatteryHV_UnitTest.m"));

suite_2 = matlab.unittest.TestSuite.fromFile( ...
  fullfile(TopFolder, "Test", "BatteryHV_UnitTest_MQC.m"));

suite= [suite_1, suite_2];

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed );

%% JUnit Style Test Result

TestResultFile = "BatteryHV_TestResults_" + RelStr + ".xml";

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
  fullfile(TopFolder, "Test", TestResultFile));

addPlugin(runner, plugin)

%% MATLAB Code Coverage Report

coverageReportFolder = fullfile(TopFolder, "coverage" + RelStr);
if not(isfolder(coverageReportFolder))
  mkdir(coverageReportFolder)
end

coverageReport = matlab.unittest.plugins.codecoverage.CoverageReport( ...
  coverageReportFolder, ...
  MainFile = "BatteryHV_Coverage_" + RelStr + ".html" );

plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile( ...
  [ ...
  fullfile(TopFolder, "Harness", "BatteryHV_harness_setup.m")
  ...
  fullfile(TopFolder, "Model-TabledBased", "BatteryHV_TableBased_buildParameters.mlx")
  fullfile(TopFolder, "Model-TabledBased", "BatteryHV_TableBased_visualizeParameters.mlx")
  ...
  fullfile(TopFolder, "SimulationCases", "BatteryHV_simulationCase_Charge.mlx")
  fullfile(TopFolder, "SimulationCases", "BatteryHV_simulationCase_Constant.mlx")
  fullfile(TopFolder, "SimulationCases", "BatteryHV_simulationCase_Discharge.mlx")
  fullfile(TopFolder, "SimulationCases", "BatteryHV_simulationCase_Random.mlx")
  ...
  fullfile(TopFolder, "Test", "BatteryHV_UnitTest.m")
  fullfile(TopFolder, "Test", "BatteryHV_UnitTest_MQC.m")
  ...
  fullfile(TopFolder, "Utility", "Configuration", "BatteryHV_loadSimulationCase.m")
  fullfile(TopFolder, "Utility", "Configuration", "BatteryHV_loadSimulationCase_Charge.m")
  fullfile(TopFolder, "Utility", "Configuration", "BatteryHV_loadSimulationCase_Constant.m")
  fullfile(TopFolder, "Utility", "Configuration", "BatteryHV_loadSimulationCase_Discharge.m")
  fullfile(TopFolder, "Utility", "Configuration", "BatteryHV_loadSimulationCase_Random.m")
  fullfile(TopFolder, "Utility", "Configuration", "BatteryHV_setInitialConditions.m")
  fullfile(TopFolder, "Utility", "Configuration", "BatteryHV_useRefsub.m")
  fullfile(TopFolder, "Utility", "Configuration", "BatteryHV_useRefsub_Basic.m")
  fullfile(TopFolder, "Utility", "Configuration", "BatteryHV_useRefsub_System.m")
  fullfile(TopFolder, "Utility", "Configuration", "BatteryHV_useRefsub_SystemSimple.m")
  fullfile(TopFolder, "Utility", "Configuration", "BatteryHV_useRefsub_SystemTable.m")
  ...
  fullfile(TopFolder, "Utility", "BatteryHV_buildOpenCircuitVoltageData.m")
  fullfile(TopFolder, "Utility", "BatteryHV_buildTerminalResistanceData.m")
  fullfile(TopFolder, "Utility", "BatteryHV_getAmpereHourRating.m")
  fullfile(TopFolder, "Utility", "BatteryHV_getBatteryPackParameters.m")
  fullfile(TopFolder, "Utility", "BatteryHV_getReferencedSubsystemFilename.m")
  fullfile(TopFolder, "Utility", "BatteryHV_plotInput_LoadCurrent.m")
  fullfile(TopFolder, "Utility", "BatteryHV_plotResults.m")
  ...
  fullfile(TopFolder, "BatteryHV_main_script.mlx")
  fullfile(TopFolder, "BatteryHV_refsub_Basic_params.m")
  fullfile(TopFolder, "BatteryHV_refsub_System_params.m")
  fullfile(TopFolder, "BatteryHV_refsub_SystemSimple_params.m")
  fullfile(TopFolder, "BatteryHV_refsub_SystemTable_params.m")
  ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%% Run tests
results = run(runner, suite);
assertSuccess(results)
