classdef unittest_replaceText < matlab.unittest.TestCase
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

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(~)
      demo_replaceText_1
    end  % function

    function PassingTest_2(~)
      demo_replaceText_2
    end  % function

    function Error_1(testcase)
      verifyError(testcase, @test_target, "MATLAB:minrhs")
      function test_target()
        SearchTool1.replaceText()  % !test-target
      end  % function
    end  % function

    function Error_2(testcase)
      target_file = which("samplefile_replaceText.txt");
      verifyError(testcase, @test_target, "replaceText:InvalidTextPattern")
      function test_target()
        SearchTool1.replaceText(target_file)  % !test-target
      end  % function
    end  % function

    function Error_3(testcase)
      target_file = which("samplefile_replaceText.txt");
      verifyError(testcase, @test_target, "replaceText:InvalidNewText")
      function test_target()
        SearchTool1.replaceText(target_file, TextPattern="programmatically")  % !test-target
      end  % function
    end  % function

    %% Tests

    function Test_1(testcase)
      target_file = which("samplefile_replaceText.txt");
      original_lines = readlines(target_file);
      verifyTrue(testcase, contains(original_lines(2), "modified"))

      session = SearchTool1.replaceText(target_file, DryRun=false, TextPattern="modified", NewText="edited");  % !test-target
      verifyEqual(testcase, height(session.NumLines), 1)
      actual_lines = readlines(target_file);
      verifyTrue(testcase, contains(actual_lines(2), "edited"))

      session = SearchTool1.replaceText(target_file, DryRun=false, TextPattern="edited", NewText="modified");  % !test-target
      verifyEqual(testcase, height(session.NumLines), 1)
      actual_lines = readlines(target_file);
      verifyTrue(testcase, contains(actual_lines(2), "modified"))
    end  % function

  end  % methods
end  % classdef
