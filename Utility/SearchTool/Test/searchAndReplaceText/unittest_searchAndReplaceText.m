classdef unittest_searchAndReplaceText < matlab.unittest.TestCase
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
      TextSearchTool1.searchAndReplaceText;
    end  % function

    function PassingTest_2(~)
      TextSearchTool1.searchAndReplaceText(DisplayInfo=true);
    end  % function

    function PassingTest_3(~)
      demo_searchAndReplaceText
    end  % function

    function Error_1(testcase)
      verifyError(testcase, @test_target, "searchText:InvalidFileType")
      function test_target()
        TextSearchTool1.searchAndReplaceText(FileType="")  % !test-target
      end  % function
    end  % function

    %% Tests

    % Unit test runs in the folder where the test file exists.
    % Assume that demo_*.m and unittest_*.m exist in the current folder.

    function Test_1(testcase)
      % No matching files.
      result = TextSearchTool1.searchAndReplaceText(FileType="*dummy_file_type");
      verifyTrue(testcase, isempty(result))
    end  % function

  end  % methods

end  % classdef
