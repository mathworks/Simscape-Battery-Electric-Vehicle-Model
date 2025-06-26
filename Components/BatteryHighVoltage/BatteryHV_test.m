classdef BatteryHV_test < matlab.unittest.TestCase
  %% Class implementation of unit test
  % This is class-based unit test implementation.
  % To navigate test results and see code coverage, use Test Browser (testBrowser).
  %
  % Documentation
  %
  % - Author Class-Based Unit Tests in MATLAB
  %   https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % - matlab.unittest.TestCase Class
  %   https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % - Test Browser
  %   https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2025 The MathWorks, Inc.

  properties
    ModelName (1,1) string = "BatteryHV_harness_model"
  end  % properties

  methods (TestMethodSetup)
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
    % Functions in this "Test" section are the tests.
    % Before a function in this section runs, the TestSetup function
    % defined in the "TestMethodSetup" section runs.

    %% Minimum quality check (MQC)
    % Check that models, scripts, functions, and classes run right out of the box.

    function MQC_setup_1(~)
      BatteryHV_ComponentTestParameters  % !test-target
    end  % function

    function MQC_load_1(testcase)
      load_system(testcase.ModelName)  % !test-target
    end  % function

    function MQC_sim_1(testcase)
      load_system(testcase.ModelName)
      sim(testcase.ModelName)  % !test-target
    end  % function

    function MQC_main_script_1(~)
      BatteryHV_main_script  % !test-target
    end  % function

    %%

    function main_html_1(testcase)
      % Check that thete is an HTML version of the main script.
      all_project_files = [currentProject().Files.Path]';
      logical_index = endsWith(all_project_files, "BatteryHV_main_script.html");  % !test-target
      verifyEqual(testcase, nnz(logical_index), 1)
    end  % function

  end  % methods

end  % classdef
