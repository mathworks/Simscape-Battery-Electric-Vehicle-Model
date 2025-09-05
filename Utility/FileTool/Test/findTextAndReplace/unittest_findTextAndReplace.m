classdef unittest_findTextAndReplace < matlab.unittest.TestCase
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
      FileTool3.findTextAndReplace;
    end  % function

    function PassingTest_2(~)
      FileTool3.findTextAndReplace(DisplayInfo=true);
    end  % function

    function Error_1(testcase)
      verifyError(testcase, @test_target, "findTextAndReplace:InvalidFileType")
      function test_target()
        FileTool3.findTextAndReplace(FileType="")  % !test-target
      end  % function
    end  % function

    %% Tests

    % Unit test runs in the folder where the test file exists.
    % Assume that demo_*.m and unittest_*.m exist in the current folder.

    function Test_1(testcase)
      % No matching files.
      result = FileTool3.findTextAndReplace(FileType="*.test_extension", DisplayInfo=true);
      verifyTrue(testcase, isempty(result))
    end  % function

    function Test_2(testcase)
      result = FileTool3.findTextAndReplace(...
        FileType = "*.m", ...
        TextPattern = "MathWorks" );
      verifyTrue(testcase, not(isempty(result)))
    end  % function

    function Test_3(testcase)
      result = FileTool3.findTextAndReplace(...
        FileType = "*.m", ...
        TextPattern = "Math", ...
        MatchWholeWord = true, ...
        DisplayInfo = true );
      verifyTrue(testcase, isempty(result))
    end  % function

    function Test_4(testcase)
      result = FileTool3.findTextAndReplace(...
        FileType = "*.m", ...
        TextPattern = "mATHwORKS", ...
        IgnoreCase = true );
      verifyTrue(testcase, not(isempty(result)))
    end  % function

    function Test_5(testcase)
      result = FileTool3.findTextAndReplace(...
        FileType = "*.m", ...
        TextPattern = "classdef" );
      verifyTrue(testcase, not(isempty(result)))
    end  % function

    function Test_6(testcase)
      top_folder = fullfile(pwd, "testfolder");
      result = FileTool3.findTextAndReplace(...
        TopFolders = [fullfile(top_folder, "subfolder1"), fullfile(top_folder, "subfolder2"), fullfile(top_folder, "subfolder3")], ...
        SearchSubfolders = true, ...
        FileType = "*.m", ...
        TextPattern = "MathWorks", ...
        Filter = @(x) contains(x, "testscript") );
      verifyTrue(testcase, nnz(endsWith(result.FilePath, "testscript21.m")) == 1)
      verifyTrue(testcase, nnz(endsWith(result.FilePath, "testscript31.m")) == 1)
      verifyTrue(testcase, nnz(endsWith(result.FilePath, "testscript32.m")) == 1)
    end  % function

    function Test_7(testcase)
      % The file search must go into the testfolder which has MDL files.
      % The result must have rows for the "MathWorks" text in the MDL files.
      result = FileTool3.findTextAndReplace(...
        DryRun = true, ...
        TopFolder = pwd, ...
        SearchSubfolders = true, ...
        FileType = ["*.m", "*.mdl"], ...
        TextPattern = "MathWorks" );
      verifyTrue(testcase, any(endsWith(result.FilePath, ".mdl")))
      verifyTrue(testcase, all(contains(result.LineText, "MathWorks")))
    end  % function

    function Test_8(testcase)
      % Modifty text. Case-sensitive (default).
      result = FileTool3.findTextAndReplace(...
        DryRun = false, ...
        SearchSubfolders = true, ...
        FileType = "*.mdl", ...
        TextPattern = "===testing===", ...
        NewText = "+++TEST+++" );

      verifyTrue(testcase, height(result) == 1)
      targetfile_fullpath = result.FilePath;
      lines = readlines(targetfile_fullpath);
      verifyTrue(testcase, nnz(contains(lines, "+++TEST+++")) == 1)

      % Modify text. Case-insensitive.
      result = FileTool3.findTextAndReplace(...
        DryRun = false, ...
        SearchSubfolders = true, ...
        FileType = "*.mdl", ...
        TextPattern = "+++test+++", ...
        IgnoreCase = true, ... case-insensitive text matching
        NewText = "===testing===" );

      verifyTrue(testcase, height(result) == 1)
      targetfile_fullpath = result.FilePath;
      lines = readlines(targetfile_fullpath);
      verifyTrue(testcase, nnz(contains(lines, "===testing===")) == 1)
    end  % function

  end  % methods

end  % classdef
