%% Run unit tests
% This script runs unit tests and generates a test result summary in XML
% and a MATLAB code coverage report in HTML.

% Copyright 2022 The MathWorks, Inc.

RelStr = matlabRelease().Release;
disp("This is MATLAB " + RelStr)

PrjRoot = currentProject().RootFolder;

TopFolder = fullfile(PrjRoot, "BEV");
assert(isfolder(TopFolder))

UnitTestFolder = fullfile(PrjRoot, "BEV", "test");
assert(isfolder(UnitTestFolder))

UtilsFolder = fullfile(PrjRoot, "BEV", "utils");
assert(isfolder(UtilsFolder))

%% Test Suite & Runner

UnitTestFile = fullfile(UnitTestFolder, "BEV_UnitTest.m");
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

CoverageReportFolder = fullfile(PrjRoot, "BEV", "coverage" + RelStr);
if not(isfolder(CoverageReportFolder))
  mkdir(CoverageReportFolder)
end

CoverageReportFile = RelStr + "_BEV.html";

coverageReport = matlab.unittest.plugins.codecoverage.CoverageReport( ...
                  CoverageReportFolder, ...
                  MainFile = CoverageReportFile );

plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile( ...
  [ ...
    fullfile(UnitTestFolder, "BEV_UnitTest.m"), ...
    fullfile(UtilsFolder, "BEV_plotResults.m"), ...
    fullfile(UtilsFolder, "BEV_resetReferencedSubsystems.m"), ...
    fullfile(TopFolder, "BEV_main_script.mlx") ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%%

results = run(runner, suite);

disp(results)
