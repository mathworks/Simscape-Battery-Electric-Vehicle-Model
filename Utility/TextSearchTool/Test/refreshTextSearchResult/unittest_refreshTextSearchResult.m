classdef unittest_refreshTextSearchResult < matlab.unittest.TestCase
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
      TextSearchTool1.refreshTextSearchResult
    end  % function

    function PassingTest_2(~)
      demo_refreshTextSearchResult
    end  % function

    %% Tests

    function Test_1(testcase)
      % In a real scenario, some of the files in the first search result may be
      % modified after the search, and the modifications may impact the refresh.
      % However, in this test, no edits are made between search and refesh.
      % Thus, refresh must produce the same result.

      original_result = TextSearchTool1.searchText(...
        TargetFolder = pwd, ...
        IncludeSubfolders = false, ...
        FileTypes = ["*.m", "*.md"], ...
        TextPattern = "Copyright 2024" );

      new_result = TextSearchTool1.refreshTextSearchResult(original_result);  % !test-target

      verifyEqual(testcase, new_result, original_result)
    end  % function

  end  % methods

end  % classdef
