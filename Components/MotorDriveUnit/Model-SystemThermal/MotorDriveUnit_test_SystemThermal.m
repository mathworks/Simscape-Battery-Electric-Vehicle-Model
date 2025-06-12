classdef MotorDriveUnit_test_SystemThermal < matlab.unittest.TestCase
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

  % Copyright 2021-2025 The MathWorks, Inc.

  properties
    ModelName (1,1) string = "MotorDriveUnit_harness_model"
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

    function MQC_load_parameters_1(~)
      MotorDriveUnit_refsub_SystemThermal_params  % !test-target
    end  % function

    function MQC_load_refsub_1(testcase)
      load_system(testcase.ModelName)
      MotorDriveUnit_useRefsub_SystemThermal  % !test-target
    end  % function

    function MQC_set_refsub_1(~)
      MotorDriveUnit_useRefsub_SystemThermal  % !test-target
    end  % function

    function MQC_note_SystemModelEfficiency_1(~)
      evalin("base", "MotorDriveUnit_note_SystemThermalModelEfficiency")
    end  % function

    %% other tests

    function test_MotorDriveUnit_getBlockInfo_System_1(testcase)
      %%
      % Load workspace variables that are required by the test target.
      % Without them, the test fails.
      evalin("base", "MotorDriveUnit_refsub_SystemThermal_params")

      model_name = "MotorDriveUnit_refsub_SystemThermal";
      block_path = model_name + "/Motor Drive/Motor & Drive (System Level)";

      % Load the model and select the target block.
      load_system(model_name)
      [system_path, block_name, ~] = fileparts(block_path);
      set_param(0, "CurrentSystem", system_path)
      set_param(gcs, "CurrentBlock", block_name)

      info = MotorDriveUnit_getBlockInfo_SystemThermal;  % !test-target
      parameter_names = string(fieldnames(info));

      % Check that there are parameters "MaxTorque" and "MaxPower".
      % There are more parameters. This is not a comprehensive test.
      verifyEqual(testcase, nnz(startsWith(parameter_names, "MaxTorque")), 1)
      verifyEqual(testcase, nnz(startsWith(parameter_names, "MaxPower")), 1)

    end  % function

  end  % methods

end  % classdef
