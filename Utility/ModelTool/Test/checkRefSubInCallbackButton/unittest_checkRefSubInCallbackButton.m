classdef unittest_checkRefSubInCallbackButton < matlab.unittest.TestCase
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
      verifyError(testcase, @test_target, "checkRefSubInCallbackButton:InvalidModelName")
      function test_target()
        % The function requires a model name to be passed.
        ModelTool2.checkRefSubInCallbackButton  % !test-target
      end  % nested function
    end  % function

    function ErrorTest_2(testcase)
      verifyError(testcase, @test_target, "checkRefSubInCallbackButton:InvalidModelName")
      function test_target()
        % The passed argument must not be zero-length text.
        ModelTool2.checkRefSubInCallbackButton("")  % !test-target
      end  % nested function
    end  % function

    function Test_1(testcase)
      result = ModelTool2.checkRefSubInCallbackButton("testmodel_checkRefSubInCallbackButton_empty");
      verifyTrue(testcase, isempty(result))
    end  % function

    function Test_2(testcase)
      result = ModelTool2.checkRefSubInCallbackButton("testmodel_checkRefSubInCallbackButton");
      verifyEqual(testcase, result.Found(1), true)
      verifyEqual(testcase, result.Found(2), true)
      verifyEqual(testcase, result.Found(3), false)
    end  % function

    function Test_3(testcase)
      result = ModelTool2.checkRefSubInCallbackButton("testmodel_checkRefSubInCallbackButton");
      verifyEqual(testcase, result.IsRefSub(1), true)
      verifyEqual(testcase, result.IsRefSub(2), true)
      verifyEqual(testcase, result.IsRefSub(3), false)
    end  % function

    %% Minimum quality check
    % Make sure that scripts, functions, classes, and models run right out of the box.

    function PassingTest_1(~)
      demo_checkRefSubInCallbackButton
    end  % function

  end  % methods

end  % classdef
