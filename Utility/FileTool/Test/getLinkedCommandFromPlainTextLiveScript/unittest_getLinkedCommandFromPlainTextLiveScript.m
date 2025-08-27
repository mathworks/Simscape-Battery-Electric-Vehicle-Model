classdef unittest_getLinkedCommandFromPlainTextLiveScript < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2024-2025 The MathWorks, Inc.

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
      demo_getLinkedCommandFromPlainTextLiveScript
    end  % function

    %% Tests

    function Test_1(testcase)
      verifyError(testcase, @() test_target, "MATLAB:minrhs")
      function test_target
        FileTool2.getLinkedCommandFromPlainTextLiveScript
      end  % nested function
    end  % function

    function Test_2(testcase)
      fullpath = string( which("testscript_getLinkedCommandFromPlainTextLiveScript"));
      result = FileTool2.getLinkedCommandFromPlainTextLiveScript(fullpath);
      verifyEqual(testcase, result.Line, [2 2 3 3]')
      verifyEqual(testcase, result.LinkText, ["linked text" "another link" "Yet another linked text" "This"]')
      verifyEqual(testcase, result.Command, ["disp(""test 1"")" "disp(""test 2"")" "datetime" "logo"]')
    end  % function

  end  % methods

end  % classdef
