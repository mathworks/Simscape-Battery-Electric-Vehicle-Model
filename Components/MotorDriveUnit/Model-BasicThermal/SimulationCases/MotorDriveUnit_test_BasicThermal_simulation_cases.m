classdef MotorDriveUnit_test_BasicThermal_simulation_cases < matlab.unittest.TestCase
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

  % Copyright 2024-2025 The MathWorks, Inc.

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

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function MQC_Constant_1(~)
      MotorDriveUnit_BasicThermal_Constant  % !test-target
    end  % function

    function MQC_Drive_1(~)
      MotorDriveUnit_BasicThermal_Drive  % !test-target
    end  % function

    function MQC_Random_1(~)
      MotorDriveUnit_BasicThermal_Random  % !test-target
    end  % function

    function MQC_RegenBrake_1(~)
      MotorDriveUnit_BasicThermal_RegenBrake  % !test-target
    end  % function

  end  % methods

end  % classdef
