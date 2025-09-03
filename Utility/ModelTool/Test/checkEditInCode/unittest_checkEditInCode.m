classdef unittest_checkEditInCode < matlab.unittest.TestCase
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
      verifyError(testcase, @test_target, "MATLAB:minrhs")
      function test_target()
        % The function requires an argument to be passed.
        ModelTool2.checkEditInCode  % !test-target
      end  % nested function
    end  % function

    function ErrorTest_2(testcase)
      verifyError(testcase, @test_target, "checkEditInCode:EmptyCode")
      function test_target()
        % The passed argument must not be zero-length text.
        ModelTool2.checkEditInCode("")  % !test-target
      end  % nested function
    end  % function

    function ErrorTest_3(testcase)
      verifyError(testcase, @test_target, "checkEditInCode:TooMany")
      function test_target()
        % There are more code lines than the threshold.
        ModelTool2.checkEditInCode( ...
          "edit(""line1"")" + newline + "edit(""line2"")" + newline + "edit(""line3"")", ... !test-target
          MaxThreshold = 2, ...  !test-target
          DisplayInfo = true);
      end  % nested function
    end  % function

    function Test_1(testcase)
      result = ModelTool2.checkEditInCode(repmat("This code text has no matching lines.", 3, 1));
      verifyTrue(testcase, isempty(result))
    end  % function

    function Test_2(testcase)
      % name-value pair, double quotes
      result = ModelTool2.checkEditInCode("edit(""demo_checkEditInCode"")");
      verifyEqual(testcase, result.ArgumentPassedToEdit, "demo_checkEditInCode")
      verifyEqual(testcase, result.Found, true)
    end  % function

    function Test_3(testcase)
      % name-value pair, double quotes
      result = ModelTool2.checkEditInCode("edit(""ModelTool2.checkEditInCode"")");
      verifyEqual(testcase, result.ArgumentPassedToEdit, "ModelTool2.checkEditInCode")
      verifyEqual(testcase, result.Found, true)
    end  % function

    %% Minimum quality check
    % Make sure that scripts, functions, classes, and models run right out of the box.

    function PassingTest_1(~)
      demo_checkEditInCode
    end  % function

  end  % methods

end  % classdef
