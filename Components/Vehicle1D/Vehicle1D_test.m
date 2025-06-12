classdef Vehicle1D_test < matlab.unittest.TestCase
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

  methods (TestMethodSetup)
    % Functions in this "TestMethodSetup" section always run before
    % each test defined in the "Test" section runs.

    function test_method_setup(testcase)
      %%
      close all
      bdclose all

      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      % This is useful, for example, to close a model or a figure after test failure.
      addTeardown(testcase, @close_all)

      function close_all
        close all
        bdclose all
      end  % nested function
    end  % function

  end  % methods

  methods (Test)
    % Functions in this "Test" section are the tests.
    % Before a function in this section runs, the TestSetup function
    % defined in the "TestMethodSetup" section runs.

    %% Minimum Quality Check (MQC)
    % Check that scripts, functions, classes, and models run right out of the box.

    function MQC_harness_setup_1(~)
      Vehicle1D_harness_setup
    end  % function

  end  % methods

end  % classdef
