classdef uptodateTest_BEV_Basic_SimulationCases < matlab.unittest.TestCase
  % Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2024-2026 The MathWorks, Inc.

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

    %% Up-to-date tests

    function markdowns_are_uptodate(testcase)
      % Make sure that all Live Scripts have been converted to markdown files.

      top_folder = fullfile(currentProject().RootFolder, "BEV", "Model-Basic");

      target_folder = fullfile(top_folder, "markdown");
      if not(isfolder(target_folder))
        mkdir(target_folder)
      end  % if

      num_conversions = bevutil1.FileUtil.batchGenerateMarkdowns( ...
        DryRun = false, ...
        LiveScriptFolderNames = fullfile(top_folder, "SimulationCases"), ...
        MarkdownFolderPath = target_folder);

      if num_conversions > 0
        % If one or more markdowns were generated, rerun the command and get the return value of 0.
        num_conversions = bevutil1.FileUtil.batchGenerateMarkdowns( ...
          DryRun = false, ...
          LiveScriptFolderNames = fullfile(top_folder, "SimulationCases"), ...
          MarkdownFolderPath = target_folder, ...
          DisplayInfo = true);
      end  % if

      % Add created files under the markdown folder to the project.
      addFolderIncludingChildFiles(currentProject, target_folder);

      verifyEqual(testcase, num_conversions, 0)

    end  % function

  end  % methods
end  % classdef
