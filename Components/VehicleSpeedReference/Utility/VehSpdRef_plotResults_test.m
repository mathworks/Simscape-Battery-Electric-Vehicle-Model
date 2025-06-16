classdef VehSpdRef_plotResults_test < matlab.unittest.TestCase
  %% Class-based unit test implementation
  % https://www.mathworks.com/help/releases/R2025a/matlab/matlab_prog/class-based-unit-tests.html
  %
  % To navigate test results and see code coverage, use Test Browser (testBrowser).
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2021-2025 The MathWorks, Inc.

  methods(TestMethodSetup)
    % Functions in this "TestMethodSetup" section always run before
    % each test defined in the "Test" section runs.

    function TestSetup(testcase)
      function close_all
        close all
        bdclose all
      end  % nested function
      close_all
      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @close_all)
    end  % function

  end  % methods

  methods (Test)

    function MQC_Utility_1(~)
      mdl = "VehSpdRef_harness_model";
      load_system(mdl)
      VehSpdRef_loadCase
      simOut = sim(mdl);
      simData = extractTimetable(simOut.logsout);
      % Test target:
      VehSpdRef_plotResults(simData=simData)
    end  % function

  end  % methods

end  % classdef
