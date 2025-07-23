classdef test_BEVProject < matlab.unittest.TestCase
  %% Class-based unit test
  % This is for testing files in the BEV project top folder.
  % Testing the entire project is done by the buildtool command with buildfile.m

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2021-2025 The MathWorks, Inc.

  methods (Test)
    % Functions in this "Test" section are the tests.
    % Before a function in this section runs, the TestSetup function
    % defined in the "TestMethodSetup" section runs.

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(testcase)
      % The source of the description page is a MATLAB script. Check that it runs cleanly.
      verifyWarningFree(testcase, @() test_target())
      function test_target()
        BEVProject_Description  % !test-target
      end  % nested function
    end  % function

    function PassingTest_2(testcase)
      % Make sure that the app runs cleanly.
      verifyWarningFree(testcase, @() test_target())
      function test_target()
        BEVProjectNavigator  % !test-target
      end  % nested function
    end  % function

    %% Other tests

    function project_has_description_html(testcase)
      % Check that the project has the HTML version of the description page.
      all_project_files = [currentProject().Files.Path]';
      logical_index = endsWith(all_project_files, "BEVProject_Description.html");  % !test-target
      verifyEqual(testcase, nnz(logical_index), 1)
    end  % function

    function description_html_is_uptodate(testcase)
      % Make sure the description HTML file is up to date.

      source_fullpath = FileTool1.getFileFullPath("BEVProject_Description.m");
      destination_fullpath = FileTool1.getFileFullPath("BEVProject_Description.html");

      % This test uses a conditional branch as a special case because it is practical.
      newer = FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if newer
        % The export command saves the generated file in the current working folder (pwd).
        % When this test runs, pwd is the folder where this test code file exists.
        actual_path = string(export(source_fullpath, Run=true, Format="html", HideCode=true));
        expected_path = destination_fullpath;
        verifyEqual(testcase, actual_path, expected_path)
      end  % if

      newer = FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath, DisplayInfo=true);
      verifyFalse(testcase, newer)
    end  % function

    function test_no_MLX_files(testcase)
      % Use plain-text Live Scripts (*.m) rather than binary ones.
      files = [currentProject().Files.Path]';
      result = files(endsWith(files, ".mlx"));
      num_MLX_files = numel(result);
      verifyEqual(testcase, num_MLX_files, 0);
    end  % function

    function test_no_SLX_files(testcase)
      % Use plain-text model files (*.mdl) rather than binary ones.
      files = [currentProject().Files.Path]';
      result = files(endsWith(files, ".slx"));
      num_SLX_files = numel(result);
      verifyEqual(testcase, num_SLX_files, 0);
    end  % function

  end  % methods

end  % classdef
