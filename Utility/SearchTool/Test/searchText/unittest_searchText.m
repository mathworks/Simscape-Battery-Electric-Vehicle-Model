classdef unittest_searchText < matlab.unittest.TestCase
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
      TextSearchTool1.searchText(FileTypes="*.m");
    end  % function

    function PassingTest_2(~)
      demo_searchText
    end  % function

    function Error_1(testcase)
      verifyError(testcase, @test_target, "searchText:InvalidFileTypes")
      function test_target()
        TextSearchTool1.searchText;  % !test-target
      end  % function
    end  % function

    function Error_2(testcase)
      verifyError(testcase, @test_target, "searchText:InvalidFileTypes")
      function test_target()
        TextSearchTool1.searchText(FileType="")  % !test-target
      end  % function
    end  % function

    %% Tests

    % Unit test runs in the folder where the test file exists.
    % Assume that demo_*.m and unittest_*.m exist in the current folder.

    function Test_1(testcase)
      % No matching files.
      result = TextSearchTool1.searchText(FileType="*.test_extension");
      verifyTrue(testcase, isempty(result))
    end  % function

    function Test_2(testcase)
      % Check that the searchText does finds the specifed text pattern assuming
      % that the "Copyright" text exists in .m files.
      result = TextSearchTool1.searchText(...
        FileType = "*.m", ...
        SearchText = "Copyright" );
      verifyTrue(testcase, not(isempty(result)))
    end  % function

    function Test_3(testcase)
      % Test the MatchWholeWord option.
      % This test must hit only one line in this test unless there really are typo in other files.
      result = TextSearchTool1.searchText(...
        FileType = "*.m", ...
        SearchText = "Copyrigh", ... Omit "t" at the end for testing
        MatchWholeWord = true );  % !test-target
      verifyEqual(testcase, height(result), 1)
    end  % function

    function Test_4(testcase)
      result = TextSearchTool1.searchText(...
        FileType = "*.m", ...
        SearchText = "cOPYRIGHT", ...
        IgnoreCase = true );  % !test-target
      verifyTrue(testcase, not(isempty(result)))
    end  % function

    function Test_5(testcase)
      % The file search must go into the testfolder which has MDL files.
      % The result must have rows for the "Copyright" text in the MDL files.
      % Test that the file type works even when
      % file with the specified file type ("*.md") was not found.
      result = TextSearchTool1.searchText(...
        TargetFolder = pwd, ...
        IncludeSubfolders = true, ...
        FileTypes = ["*.m", "*.md", "*.mdl"], ...
        SearchText = "Copyright", ...
        IgnoreCase = true );
      verifyTrue(testcase, any(endsWith(result.FilePath, ".m")))
      verifyTrue(testcase, any(endsWith(result.FilePath, ".mdl")))
      verifyTrue(testcase, any(endsWith(result.FilePath, ".md")))
      verifyTrue(testcase, all(contains(result.LineText, "Copyright", IgnoreCase=true)))
    end  % function

  end  % methods

end  % classdef
