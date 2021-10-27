classdef BEV_UnitTest_local < matlab.unittest.TestCase
% BEV_UnitTest_local implements tests that should be run locally.

% Copyright 2021 The MathWorks, Inc.

methods (Test)

  function projectRunChecks(testCase)
  %% Programatically run the projects's Run Check.
  % This corresponds to Project > Run Checks.
  % This test checks that Run Checks ends with all clean.
    prj = currentProject;
    updateDependencies(prj);
    checkResults = runChecks(prj);
    resultTable = table(checkResults);  % *.Passed, *.ID, *.Description
    verifyEqual(testCase, all(resultTable.Passed==true), true);
  end

  function test_BevBatteryPlantWorkflow(~)
  %% Run the BEV Battery Plant workflow script.
  % This can take time as it runs a complete FTP-75 drive cycle simulation
  % with the detailed high-voltage battery pack component.
    evalin("base", "BEV_Battery_Plant_Workflow");
  end

end  % methods (Test)
end  % classdef
