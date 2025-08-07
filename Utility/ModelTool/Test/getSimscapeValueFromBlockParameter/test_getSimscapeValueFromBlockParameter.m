classdef test_getSimscapeValueFromBlockParameter < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2023-2025 The MathWorks, Inc.

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

    function ErrorTest_1(testcase)
      verifyError(testcase, @test_target, "getSimscapeValueFromBlockParameter:EmptyBlockPath")
      function test_target()
        ModelTool1.getSimscapeValueFromBlockParameter
      end  % nested function
    end  % function

    function ErrorTest_2(testcase)
      verifyError(testcase, @test_target, "getSimscapeValueFromBlockParameter:EmptyBlockParameterName")
      function test_target()
        ModelTool1.getSimscapeValueFromBlockParameter("dummy_model_name")
      end  % nested function
    end  % function

    function PassingTest_1(~)
      getSimscapeValueFromBlockParameter_sample_script
    end  % function

  end  % methods

end  % classdef
