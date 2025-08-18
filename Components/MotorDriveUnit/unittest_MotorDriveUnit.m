classdef unittest_MotorDriveUnit < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2021-2025 The MathWorks, Inc.

  properties
    ModelName (1,1) string = "HarnessModel_MotorDriveUnit"
  end  % properties

  methods (TestMethodSetup)
    % Functions in this section always run before each test defined in the Test section runs.

    function test_method_setup_1(testcase)
      function closeAll
        close all
        bdclose all
      end  % nested function
      closeAll
      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @closeAll)
    end  % function

  end  % methods

  methods (Test)
    % Functions in this "Test" section are the tests.
    % Before each function in this section runs, functions defined in the TestMethodSetup section run.

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(~)
      MotorDriveUnit_Description  % !test-target
    end  % function

    function PassingTest_2(~)
      HarnessSetup_MotorDriveUnit  % !test-target
    end  % function

    function PassingTest_3(testcase)
      load_system(testcase.ModelName)  % !test-target
    end  % function

    function PassingTest_4(testcase)
      sim(testcase.ModelName);  % !test-target
    end  % function

    function PassingTest_5(~)
      MotorDriveUnit_Description  % !test-target
    end  % function

    %% Link check

    function test_OpenApp_CallbackButton_1(testcase)
      % This test validates the followings:
      % - The model has "Open app" button at the top layer.
      % - The button contains a callback function pointing to the app.
      %
      % This test does not launch the app.
      % Testing the app must be done separately.

      app_name = "MotorDriveUnitSimulationApp";

      open_system(testcase.ModelName)

      target_block_path = testcase.ModelName + "/Open app";

      block_paths = string(getfullname(Simulink.findBlocksOfType(gcs, "CallbackButton")));
      logical_index = target_block_path == block_paths;
      verifyEqual(testcase, nnz(logical_index), 1)

      % !todo: Avoid using pause.
      % For now, pause is necessary for get_param to return the expected value.
      % Without the pause, get_param returns "" for ClickFcn.
      pause(3)
      click_function_string = string(get_param(target_block_path, "ClickFcn"));
      click_function_string = strtrim(click_function_string);

      actual = click_function_string;
      expected = app_name;
      verifyEqual(testcase, actual, expected)
    end  % function

  end  % methods

end  % classdef
