function VehSpdRef_runtests()
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

suite = matlab.unittest.TestSuite.fromFolder(TopFolder, IncludingSubfolders=true);

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed );

%% JUnit Style Test Result

% Test result file is created. Don't check its existance.
TestResultFile = "VehSpdRef-test-result.xml";

plugin = matlab.unittest.plugins.XMLPlugin.producingJUnitFormat( ...
  fullfile(TopFolder, TestResultFile));

addPlugin(runner, plugin)

%% MATLAB Code Coverage Report

CoverageReportFolder = fullfile(TopFolder, "coverage-" + RelStr);
if not(isfolder(CoverageReportFolder))
  mkdir(CoverageReportFolder)
end

CoverageReportFile = "VehSpdRef-coverage.html";

coverageReport = matlab.unittest.plugins.codecoverage.CoverageReport( ...
  CoverageReportFolder, ...
  MainFile = CoverageReportFile );

plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFile( ...
  [ ...
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_Case_Constant.mlx")
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_Case_FTP75.mlx")
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_Case_HighSpeed.mlx")
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_Case_SimpleDrivePattern.mlx")
  ...
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_loadCase.m")
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_loadCase_Constant.m")
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_loadCase_FTP75.m")
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_loadCase_HighSpeed.m")
  fullfile(TopFolder, "SimulationCases", "VehSpdRef_loadCase_SimpleDrivePattern.m")
  ...
  fullfile(TopFolder, "Utility", "VehSpdRef_plotResults.m")
  ], ...
  Producing = coverageReport );

addPlugin(runner, plugin)

%% Run tests
results = run(runner, suite);
assertSuccess(results)

end  % function
