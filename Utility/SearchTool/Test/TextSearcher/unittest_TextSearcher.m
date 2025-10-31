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
      SearchTool1.searchText("Copyright", FileTypes="*.m");
    end  % function

    function Error_1(testcase)
      verifyError(testcase, @test_target, "MATLAB:minrhs")
      function test_target()
        SearchTool1.searchText;  % !test-target
      end  % function
    end  % function

    function Error_2(testcase)
      verifyError(testcase, @test_target, "TextSearch:InvalidFileTypes")
      function test_target()
        SearchTool1.searchText("")  % !test-target
      end  % function
    end  % function

    function Error_3(testcase)
      verifyError(testcase, @test_target, "TextSearch:InvalidFileTypes")
      function test_target()
        SearchTool1.searchText("", FileType="")  % !test-target
      end  % function
    end  % function

    function Error_4(testcase)
      verifyError(testcase, @test_target, "TextSearch:InvalidFileTypes")
      function test_target()
        SearchTool1.searchText("", FileType=["*.m", ""])  % !test-target
      end  % function
    end  % function

    %% Tests
    % Unit test runs in the folder where the test file exists.

    function Test_1(testcase)
      % No matching files.
      result = SearchTool1.searchText("", FileType="*.test_extension");
      verifyTrue(testcase, isempty(result))
    end  % function

    function Test_2(testcase)
      % Check that the searchText does finds the specifed text pattern assuming
      % that 1) there are files ending with ".m", and
      % 2) text "Copyright" exists in the files.
      result = SearchTool1.searchText("Copyright", FileType = "*.m");
      verifyTrue(testcase, not(isempty(result)))
    end  % function

    function Test_3(testcase)
      % Test the MatchWholeWord option.
      % This test must hit only one line in this test unless there really are typo in other files.
      result = SearchTool1.searchText(...
        "Copyri", ... This line must be in the search result for testing searchText.
        FileType = "*.m", ...
        MatchWholeWord = true );  % !test-target
      verifyEqual(testcase, height(result), 1)
      verifyTrue(testcase, contains(result.LineText(1), "search result for testing searchText"))
    end  % function

    function Test_4(testcase)
      result = SearchTool1.searchText(...
        "cOPYRIGHT", ...
        FileType = "*.m", ...
        IgnoreCase = true );  % !test-target
      verifyTrue(testcase, height(result) > 1)
    end  % function

    function Test_5(testcase)
      % The search must go into subfolders.
      % This test assumes that *.m, *.md, and *.mdl files exist, and they gave
      % the text "Copyright".
      result = SearchTool1.searchText(...
        "Copyright", ...
        IgnoreCase = true, ...
        TargetFolder = pwd, ...
        FileTypes = ["*.m", "*.md", "*.mdl"], ...
        IncludeSubfolders = true );
      verifyTrue(testcase, any(endsWith(result.FilePath, ".m")))
      verifyTrue(testcase, any(endsWith(result.FilePath, ".md")))
      verifyTrue(testcase, any(endsWith(result.FilePath, ".mdl")))
      verifyTrue(testcase, all(contains(result.LineText, "Copyright", IgnoreCase=true)))
    end  % function

  end  % methods

end  % classdef
