function runTests_BEV_Basic
% Run tests and measure code coverage.

% Copyright 2026 The MathWorks, Inc.

top_folder = fullfile(currentProject().RootFolder, "BEV", "Model-Basic");

target_folder_1 = fullfile(top_folder, "SimulationCases");
assert(isfolder(target_folder_1))

test_file_1 = fullfile(top_folder, "Test", "unittest_BEV_Basic_SimulationCases.m");
assert(isfile(test_file_1))
test_file_2 = fullfile(top_folder, "Test", "uptodateTest_BEV_Basic_SimulationCases.m");
assert(isfile(test_file_2))

suite = testsuite([test_file_1, test_file_2]);

% -----------------------------------------------------------------------------

runner = matlab.unittest.TestRunner.withTextOutput( ...
  OutputDetail = matlab.unittest.Verbosity.Detailed);

cov_result_1 = matlab.unittest.plugins.codecoverage.CoverageResult;
cov_plugin_1 = matlab.unittest.plugins.CodeCoveragePlugin.forFolder( ...
  target_folder_1, ...
  Producing = cov_result_1, ...
  IncludeSubfolders = false, ...
  MetricLevel = "statement" );
addPlugin(runner, cov_plugin_1)

results = run(runner, suite);
assertSuccess(results)

disp(cov_result_1.Result)

end  % function
