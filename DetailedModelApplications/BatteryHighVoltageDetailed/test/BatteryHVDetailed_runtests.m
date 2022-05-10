%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr)

ComponentName = "BatteryHighVoltageDetailed";
ComponentShortName = "BatteryHVDetailed";

PrjRoot = currentProject().RootFolder;

TopFolder = fullfile(PrjRoot, "DetailedModelApplications", ComponentName);
assert(isfolder(TopFolder))

LibFolder = fullfile(TopFolder, "lib");
assert(isfolder(LibFolder))

UnitTestFolder = fullfile(TopFolder, "test");
assert(isfolder(UnitTestFolder))

UtilsFolder = fullfile(TopFolder, "utils");
assert(isfolder(UtilsFolder))

%% Test Suite & Runner

UnitTestFile1 = fullfile(UnitTestFolder, "BatteryHVDetailed_UnitTest.m");
assert(isfile(UnitTestFile1))
suite1 = matlab.unittest.TestSuite.fromFile( UnitTestFile1 );

UnitTestFile2 = fullfile(UnitTestFolder, "BatteryHVDetailed_BEV_UnitTest.m");
assert(isfile(UnitTestFile2))
suite2 = matlab.unittest.TestSuite.fromFile( UnitTestFile2 );

suites = [suite1, suite2];

runner = matlab.unittest.TestRunner.withTextOutput( ...
            OutputDetail = matlab.unittest.Verbosity.Detailed );

%% JUnit Style Test Result

% Test result file is created. Don't check its existance.
TestResultFile = "TestResults_" + RelStr + ".xml";

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
            fullfile(UnitTestFolder, TestResultFile));

addPlugin(runner, plugin)

%% MATLAB Code Coverage Report

CoverageReportFolder = fullfile(TopFolder, "coverage" + RelStr);
if not(isfolder(CoverageReportFolder))
  mkdir(CoverageReportFolder)
end

CoverageReportFile = RelStr + "_" + ComponentShortName + ".html";

coverageReport = matlab.unittest.plugins.codecoverage.CoverageReport( ...
                  CoverageReportFolder, ...
                  MainFile = CoverageReportFile );

plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile( ...
  [ ...
    fullfile(UnitTestFolder, "BatteryHVDetailed_BEV_UnitTest.m"), ...
    fullfile(UnitTestFolder, "BatteryHVDetailed_UnitTest.m"), ...
    fullfile(LibFolder, "BatteryHVDetailed_buildLibrary.m"), ...
    fullfile(UtilsFolder, "BevDriveCycle_params_Basic.m"), ...
    fullfile(UtilsFolder, "BevDriveCycle_params_Common.m"), ...
    fullfile(UtilsFolder, "BevDriveCycle_params_DetailedMulti.m"), ...
    fullfile(UtilsFolder, "BevDriveCycle_params_DetailedSingle.m"), ...
    fullfile(UtilsFolder, "BevDriveCycle_setBasic.m"), ...
    fullfile(UtilsFolder, "BevDriveCycle_setDetailedMulti.m"), ...
    fullfile(UtilsFolder, "BevDriveCycle_setDetailedSingle.m"), ...
    fullfile(UtilsFolder, "BevDriveCycle_setSimulationTime.m"), ...
    fullfile(TopFolder, "BatteryHVDetailed_harness_params.m"), ...
    fullfile(TopFolder, "BatteryHVDetailed_harness_params.m"), ...
    fullfile(TopFolder, "BEV_Battery_Plant_Workflow.mlx"), ...
    fullfile(TopFolder, "BevDriveCycle_params.m") ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%%

results = run(runner, suites);

disp(results)
