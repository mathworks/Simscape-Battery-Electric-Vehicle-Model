classdef FileTool_test < matlab.unittest.TestCase
  %% Tests for file tools
  %
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
    % Functions in this "TestMethodSetup" section always run before
    % each test defined in the "Test" section runs.

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
    % Before a function in this section runs, the TestSetup function
    % defined in the "TestMethodSetup" section runs.

    % -------------------------------------------------------------------------
    % isPlainTextLiveScript

    function error_isPlainTextLiveScript_1(testcase)
      sourcefiles = mfilename + ".m";
      verifyFalse(testcase, FileTool.isPlainTextLiveScript(sourcefiles))
    end  % function

    function error_isPlainTextLiveScript_2(testcase)
      sourcefiles = FileTool.getFileFullPath("FileTool_livescript_for_test_1.mlx");
      verifyFalse(testcase, FileTool.isPlainTextLiveScript(sourcefiles))
    end  % function

    function error_isPlainTextLiveScript_3(testcase)
      sourcefiles = [mfilename + ".m", mfilename + ".m"];
      actual = FileTool.isPlainTextLiveScript(sourcefiles);
      expected = false(2, 1);
      verifyEqual(testcase, actual, expected)
    end  % function

    function test_isPlainTextLiveScript_1(testcase)
      sourcefiles = FileTool.getFileFullPath("FileTool_livescript_for_test_2.m");
      verifyTrue(testcase, FileTool.isPlainTextLiveScript(sourcefiles))
    end  % function

    function test_isPlainTextLiveScript_2(testcase)
      sourcefiles = [
        FileTool.getFileFullPath("FileTool_livescript_for_test_1.mlx")
        FileTool.getFileFullPath("FileTool_livescript_for_test_2.m")
        ];
      actual = FileTool.isPlainTextLiveScript(sourcefiles);
      expected = [false; true];
      verifyEqual(testcase, actual, expected)
    end  % function

    % -------------------------------------------------------------------------
    % isLiveScript

    function error_isLiveScript_1(testcase)
      sourcefiles = mfilename + ".m";
      verifyFalse(testcase, FileTool.isLiveScript(sourcefiles))
    end  % function

    function error_isLiveScript_2(testcase)
      sourcefiles = [mfilename + ".m", mfilename + ".m"];
      actual = FileTool.isLiveScript(sourcefiles);
      expected = false(2, 1);
      verifyEqual(testcase, actual, expected)
    end  % function

    function test_isLiveScript_1(testcase)
      sourcefiles = FileTool.getFileFullPath("FileTool_livescript_for_test_1.mlx");
      verifyTrue(testcase, FileTool.isLiveScript(sourcefiles))
    end  % function

    function test_isLiveScript_2(testcase)
      sourcefiles = FileTool.getFileFullPath("FileTool_livescript_for_test_2.m");
      verifyTrue(testcase, FileTool.isLiveScript(sourcefiles))
    end  % function

    function test_isLiveScript_3(testcase)
      sourcefiles = [
        FileTool.getFileFullPath("FileTool_livescript_for_test_1.mlx")
        FileTool.getFileFullPath("FileTool_livescript_for_test_2.m")
        ];
      actual = FileTool.isLiveScript(sourcefiles);
      expected = true(2, 1);
      verifyEqual(testcase, actual, expected)
    end  % function

    function test_isLiveScript_4(testcase)
      sourcefiles = [
        mfilename + ".m"
        FileTool.getFileFullPath("FileTool_livescript_for_test_1.mlx")
        FileTool.getFileFullPath("FileTool_livescript_for_test_2.m")
        ];
      actual = FileTool.isLiveScript(sourcefiles);
      expected = [false; true; true];
      verifyEqual(testcase, actual, expected)
    end  % function

    % -------------------------------------------------------------------------
    % mustBeLiveScript

    function error_mustBeLiveScript_1(testcase)
      sourcefile = mfilename + ".m";
      verifyError(testcase, @() FileTool.mustBeLiveScript(sourcefile), "mustBeLiveScript:NotLiveScript")
    end  % function

    function error_mustBeLiveScript_2(testcase)
      sourcefiles = [mfilename + ".m", mfilename + ".m"];
      verifyError(testcase, @() FileTool.mustBeLiveScript(sourcefiles), "mustBeLiveScript:NotLiveScript")
    end  % function

    function test_mustBeLiveScript_1(testcase)
      sourcefile = FileTool.getFileFullPath("FileTool_livescript_for_test_1.mlx");
      verifyWarningFree(testcase, @() FileTool.mustBeLiveScript(sourcefile))
    end  % function

    function test_mustBeLiveScript_2(testcase)
      sourcefiles = [
        FileTool.getFileFullPath("FileTool_livescript_for_test_1.mlx")
        FileTool.getFileFullPath("FileTool_livescript_for_test_2.m")
        ];
      verifyWarningFree(testcase, @() FileTool.mustBeLiveScript(sourcefiles))
    end  % function

    % -------------------------------------------------------------------------
    % exportToMarkdown

    function error_exportToMarkdown_1(testcase)
      sourcefile = mfilename + ".m";
      verifyError(testcase, @() FileTool.exportToMarkdown(sourcefile), "mustBeLiveScript:NotLiveScript")
    end  % function

    function test_exportToMarkdown_with_mlx_file_1(testcase)
      sourcefile = FileTool.getFileFullPath("FileTool_livescript_for_test_1.mlx");
      destination_mdfile = fullfile(pwd, "markdown", "FileTool_livescript_for_test_1.md");
      destination_pngfile = fullfile(pwd, "markdown", "media", "FileTool_livescript_for_test_1_media", "figure_0.png");

      FileTool.exportToMarkdown(sourcefile)  % !test-target

      verifyTrue(testcase, isfile(destination_mdfile))
      verifyTrue(testcase, isfile(destination_pngfile))

      % exportToMarkdown always creates a new Markdown file.
      % (This is indirectly testing sourceFileIsNewer.)
      verifyTrue(testcase, not(FileTool.sourceFileIsNewer(Source=sourcefile, Destination=destination_mdfile)))
      verifyTrue(testcase, not(FileTool.sourceFileIsNewer(Source=sourcefile, Destination=destination_pngfile)))
    end  % function

    function test_exportToMarkdown_with_m_file_1(testcase)
      sourcefile = FileTool.getFileFullPath("FileTool_livescript_for_test_2.m");
      destination_mdfile = fullfile(pwd, "markdown", "FileTool_livescript_for_test_2.md");
      destination_pngfile = fullfile(pwd, "markdown", "media", "FileTool_livescript_for_test_2_media", "figure_0.png");

      FileTool.exportToMarkdown(sourcefile)  % !test-target

      verifyTrue(testcase, isfile(destination_mdfile))
      verifyTrue(testcase, isfile(destination_pngfile))

      % exportToMarkdown always creates a new Markdown file.
      % (This is indirectly testing sourceFileIsNewer.)
      verifyTrue(testcase, not(FileTool.sourceFileIsNewer(Source=sourcefile, Destination=destination_mdfile)))
      verifyTrue(testcase, not(FileTool.sourceFileIsNewer(Source=sourcefile, Destination=destination_pngfile)))
    end  % function

    % -------------------------------------------------------------------------
    % generateMarkdownsFromLiveScripts

    function error_generateMarkdownsFromLiveScripts_1(testcase)
      sourcefiles = mfilename + ".m";
      verifyError(testcase, @() FileTool.generateMarkdownsFromLiveScripts(sourcefiles), "mustBeLiveScript:NotLiveScript")
    end  % function

    function error_generateMarkdownsFromLiveScripts_2(testcase)
      sourcefiles = [mfilename + ".m", mfilename + ".m"];
      verifyError(testcase, @() FileTool.generateMarkdownsFromLiveScripts(sourcefiles), "mustBeLiveScript:NotLiveScript")
    end  % function

    function test_generateMarkdownsFromLiveScripts_1(testcase)
      sourcefiles = [
        FileTool.getFileFullPath("FileTool_livescript_for_test_1.mlx")
        FileTool.getFileFullPath("FileTool_livescript_for_test_2.m")
        ];

      % First call may or may not do conversion.
      FileTool.generateMarkdownsFromLiveScripts(sourcefiles);

      % Second conversion must skip all conversions.
      converted = FileTool.generateMarkdownsFromLiveScripts(sourcefiles);  % !test-target

      verifyEqual(testcase, converted, false(1,2))
    end  % function

    % -------------------------------------------------------------------------

    function passing_test_batchGenerateMarkdowns_1(~)
      % Unit test starts in the folder where there is this unit test file.
      % batchGenerateMarkdowns searches live scripts in pwd if
      % LiveScriptFolderNames option is not specified.
      % Depending on the time stamps of Markdown files that are found,
      % running batchGenerateMarkdowns may or may not create new Markdown files.
      FileTool.batchGenerateMarkdowns
    end  % function

  end  % methods

end  % classdef
