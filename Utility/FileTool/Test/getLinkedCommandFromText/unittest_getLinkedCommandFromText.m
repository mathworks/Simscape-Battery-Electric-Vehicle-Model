classdef unittest_getLinkedCommandFromText < matlab.unittest.TestCase
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
      demo_getLinkedCommandFromText
    end  % function

    %% Tests

    function Test_1(testcase)
      verifyError(testcase, @() test_target, "MATLAB:minrhs")
      function test_target
        FileTool3.getLinkedCommandFromText
      end  % nested function
    end  % function

    function Test_2(testcase)
      result = FileTool3.getLinkedCommandFromText("no linked command in the text");
      verifyTrue(testcase, isempty(result))
    end  % function

    function Test_3(testcase)
      target_text = "[Linked text 1](matlab:command1)";
      result = FileTool3.getLinkedCommandFromText(target_text);
      verifyEqual(testcase, result.Line, 1)
      verifyEqual(testcase, result.Command, "command1")
      verifyEqual(testcase, result.LinkText, "Linked text 1")
    end  % function

    function Test_4(testcase)
      target_text = "[Linked text 1](<matlab:command1>)";
      result = FileTool3.getLinkedCommandFromText(target_text);
      verifyEqual(testcase, result.Line, 1)
      verifyEqual(testcase, result.Command, "command1")
      verifyEqual(testcase, result.LinkText, "Linked text 1")
    end  % function

    function Test_5(testcase)
      target_text = "[Linked text 1](matlab:command1(arg1, arg2))";
      result = FileTool3.getLinkedCommandFromText(target_text);
      verifyEqual(testcase, result.Line, 1)
      verifyEqual(testcase, result.Command, "command1(arg1, arg2)")
      verifyEqual(testcase, result.LinkText, "Linked text 1")
    end  % function

    function Test_6(testcase)
      target_text = "[Linked text 1](<matlab:command1(arg1, arg2)>)";
      result = FileTool3.getLinkedCommandFromText(target_text);
      verifyEqual(testcase, result.Line, 1)
      verifyEqual(testcase, result.Command, "command1(arg1, arg2)")
      verifyEqual(testcase, result.LinkText, "Linked text 1")
    end  % function

    function Test_7(testcase)
      target_text = [
        ""
        "  [t21](matlab:c21)  [t22](matlab:c22)  [t23](matlab:c23)  "
        "  [t31](matlab:c31(a1,a2))  [t32](matlab:c32)  [t33](matlab:c33(c1, n1=v1, n2=v2))  "
        ""
        ];
      result = FileTool3.getLinkedCommandFromText(target_text);
      verifyEqual(testcase, result.Line, [2 2 2 3 3 3]')
      verifyEqual(testcase, result.Command, ["c21" "c22" "c23" "c31(a1,a2)" "c32" "c33(c1, n1=v1, n2=v2)"]')
      verifyEqual(testcase, result.LinkText, ["t21" "t22" "t23" "t31" "t32" "t33"]')
    end  % function

    function Test_8(testcase)
      % commands with or without angle brackets.
      target_text = [
        ""
        "  [t21](<matlab:c21>)  [t22](<matlab:c22>)  [t23](matlab:c23)  "
        "  [t31](matlab:c31(a1,a2))  [t32](<matlab:c32>)  [t33](<matlab:c33(c1, n1=v1, n2=v2)>)  "
        ""
        ];
      result = FileTool3.getLinkedCommandFromText(target_text);
      verifyEqual(testcase, result.Line, [2 2 2 3 3 3]')
      verifyEqual(testcase, result.Command, ["c21" "c22" "c23" "c31(a1,a2)" "c32" "c33(c1, n1=v1, n2=v2)"]')
      verifyEqual(testcase, result.LinkText, ["t21" "t22" "t23" "t31" "t32" "t33"]')
    end  % function

  end  % methods

end  % classdef
