%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr)

ComponentName = "BatteryHighVoltage";
ComponentShortName = "BatteryHV";

PrjRoot = currentProject().RootFolder;

TopFolder = fullfile(PrjRoot, "Components", ComponentName);
assert(isfolder(TopFolder))

HarnessFolder = fullfile(TopFolder, "harnessModels");
assert(isfolder(HarnessFolder))

UnitTestFolder = fullfile(TopFolder, "test");
assert(isfolder(UnitTestFolder))

TestCaseFolder = fullfile(TopFolder, "testcases");
assert(isfolder(TestCaseFolder))

UtilsFolder = fullfile(TopFolder, "utils");
assert(isfolder(UtilsFolder))

%% Test Suite & Runner

UnitTestFile = fullfile(UnitTestFolder, ComponentShortName+"_UnitTest.m");
assert(isfile(UnitTestFile))

suite = matlab.unittest.TestSuite.fromFile( UnitTestFile );

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
    fullfile(HarnessFolder, ComponentShortName+"_harness_setup.m"), ...
    fullfile(UnitTestFolder, ComponentShortName+"_UnitTest.m"), ...
    fullfile(TestCaseFolder, ComponentShortName+"_testcase_Charge.mlx"), ...
    fullfile(TestCaseFolder, ComponentShortName+"_testcase_Discharge.mlx"), ...
    fullfile(TestCaseFolder, ComponentShortName+"_testcase_LoadCurrentStep3.mlx"), ...
    fullfile(UtilsFolder, ComponentShortName+"_InputSignalBuilder.m"), ...
    fullfile(UtilsFolder, ComponentShortName+"_plotInputs.m"), ...
    fullfile(UtilsFolder, ComponentShortName+"_plotResults.m"), ...
    fullfile(UtilsFolder, ComponentShortName+"_selectInput.m"), ...
    fullfile(UtilsFolder, ComponentShortName+"_takeScreenshots.m"), ...
    fullfile(TopFolder, ComponentShortName+"_main_script.mlx") ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%%

results = run(runner, suite);

disp(results)
