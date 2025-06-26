classdef BEV_Basic_passing_test < matlab.unittest.TestCase
  %% Pass/fail tests
  % Check that models, scripts, functions, and classes run right out of the box.
  %
  % This is class-based unit test implementation.
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

  methods (TestMethodSetup)
    % Functions in this "TestMethodSetup" section always run before
    % each test defined in the "Test" section runs.

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
    % Before a function in this section runs, the TestSetup function
    % defined in the "TestMethodSetup" section runs.

    %% Minimum quality check (MQC) / passing test
    % Check that models, scripts, functions, and classes run right out of the box.

    function MQC_BEV_useBasic_1(~)
      BEV_useBasic  % !test-target
    end  % function

    function MQC_BEV_Basic_Constant_1(~)
      BEV_Basic_Constant  % !test-target
    end  % function

    function MQC_BEV_Basic_SimpleDrivePattern_1(~)
      BEV_Basic_SimpleDrivePattern  % !test-target
    end  % function

    function MQC_BEV_Basic_HighSpeed_1(~)
      BEV_Basic_HighSpeed  % !test-target
    end  % function

    function MQC_BEV_Basic_FTP75_1(~)
      BEV_Basic_FTP75  % !test-target
    end  % function

  end  % methods

end  % classdef
