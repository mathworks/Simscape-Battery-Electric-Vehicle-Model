classdef unittest_checkRefSubInSetParam < matlab.unittest.TestCase
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
        ModelTool2.checkRefSubInSetParam  % !test-target
      end  % nested function
    end  % function

    function ErrorTest_2(testcase)
      verifyError(testcase, @test_target, "checkRefSubInSetParam:EmptyCode")
      function test_target()
        % The passed argument must not be zero-length text.
        ModelTool2.checkRefSubInSetParam("")  % !test-target
      end  % nested function
    end  % function

    function ErrorTest_3(testcase)
      verifyError(testcase, @test_target, "checkRefSubInSetParam:TooMany")
      function test_target()
        codelines = 5;
        thresh = 3;  % !test-target: Set this value to be greater than codelines for testing.
        ModelTool2.checkRefSubInSetParam( ...
          repmat("set_param(ReferencedSubsystem=""testmodel_checkRefSubInSetParam_refsub1.mdl"")", codelines, 1), ...
          MaxThreshold = thresh, ...
          DisplayInfo = true);
      end  % nested function
    end  % function

    function Test_1(testcase)
      result = ModelTool2.checkRefSubInSetParam(repmat("This code text has no matching lines.", 3, 1));
      verifyTrue(testcase, isempty(result))
    end  % function

    function Test_2(testcase)
      % name-value pair, double quotes
      result = ModelTool2.checkRefSubInSetParam("set_param(ReferencedSubsystem=""testmodel_checkRefSubInSetParam_refsub1.mdl"")");
      verifyEqual(testcase, result.FileName, "testmodel_checkRefSubInSetParam_refsub1.mdl")
      verifyEqual(testcase, result.Found, true)
      verifyEqual(testcase, result.IsRefSub, true)
    end  % function

    function Test_3(testcase)
      % name-value pair, single-quotes
      result = ModelTool2.checkRefSubInSetParam("set_param(ReferencedSubsystem='testmodel_checkRefSubInSetParam.mdl')");
      verifyEqual(testcase, result.FileName, "testmodel_checkRefSubInSetParam.mdl")
      verifyEqual(testcase, result.Found, true)
      verifyEqual(testcase, result.IsRefSub, false)
    end  % function

    function Test_4(testcase)
      % comma separated, double quotes
      result = ModelTool2.checkRefSubInSetParam("set_param(""ReferencedSubsystem"", ""testmodel_checkRefSubInSetParam_refsub2.mdl"")");
      verifyEqual(testcase, result.FileName, "testmodel_checkRefSubInSetParam_refsub2.mdl")
      verifyEqual(testcase, result.Found, true)
      verifyEqual(testcase, result.IsRefSub, true)
    end  % function

    function Test_5(testcase)
      % comma separated, single quotes
      result = ModelTool2.checkRefSubInSetParam("set_param('ReferencedSubsystem', 'testmodel_checkRefSubInSetParam_refsub2.mdl')");
      verifyEqual(testcase, result.FileName, "testmodel_checkRefSubInSetParam_refsub2.mdl")
      verifyEqual(testcase, result.Found, true)
      verifyEqual(testcase, result.IsRefSub, true)
    end  % function

    %% Minimum quality check
    % Make sure that scripts, functions, classes, and models run right out of the box.

    function PassingTest_1(~)
      demo_checkRefSubInSetParam
    end  % function

  end  % methods

end  % classdef
