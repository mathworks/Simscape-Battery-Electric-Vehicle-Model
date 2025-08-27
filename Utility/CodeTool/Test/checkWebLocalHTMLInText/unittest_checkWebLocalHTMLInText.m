classdef unittest_checkWebLocalHTMLInText < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2025 The MathWorks, Inc.

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

    function Test_1(testcase)
      result = CodeTool1.checkWebLocalHTMLInText;
      verifyTrue(testcase, isempty(result))
    end  % function

    function Test_2(testcase)
      result = CodeTool1.checkWebLocalHTMLInText("");
      verifyTrue(testcase, isempty(result))
    end  % function

    function Test_3(testcase)
      code_text = [
        "% This line is ignored."
        "web(""http:dummy.com/index.html"")"
        "  x = @() web(""https:dummy.com/index.html"");"
        "  txt = ""web(""""dummy.html"""")"";  % This line is ignored."
        "  callback = @() web(""testhtml_checkWebLocalHTMLInText.html"");"
        ];
      result = CodeTool1.checkWebLocalHTMLInText(code_text);
      verifyEqual(testcase, result.LineNumber, [2 3 5]')
      verifyEqual(testcase, result.IsLocal, [false false true]')
      verifyEqual(testcase, result.URL(result.LineNumber == 2), "http:dummy.com/index.html")
      verifyEqual(testcase, result.URL(result.LineNumber == 3), "https:dummy.com/index.html")
      verifyEqual(testcase, result.URL(result.LineNumber == 5), "testhtml_checkWebLocalHTMLInText.html")
    end  % function

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(~)
      demo_checkWebLocalHTMLInText
    end  % function

  end  % methods

end  % classdef
