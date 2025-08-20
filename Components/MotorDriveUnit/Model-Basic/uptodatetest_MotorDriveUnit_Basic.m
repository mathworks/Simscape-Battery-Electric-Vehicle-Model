classdef uptodatetest_MotorDriveUnit_Basic < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2021-2025 The MathWorks, Inc.

  properties

    % Keyword representing the model.
    % This is defined by extracting text after "Model-" in a folder name.
    % For example, "Basic" from the "Model-Basic" folder, or
    % "SystemThermal" from the "Model-SystemThermal" folder.
    ModelID (1,1) string

  end  % properties

  methods (TestClassSetup)
    % Functions in this section run only once before tests in the Test section runs.

    function test_class_setup_1(testcase)
      [~, folder_name, ~] = fileparts(pwd);
      testcase.ModelID = extractAfter(folder_name, "Model-");
      verifyTrue(testcase, endsWith(mfilename, testcase.ModelID))
      disp("# Starting tests with ModelID: " + testcase.ModelID)
    end  % function

  end  % methods

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

    %% Up-to-date test

    function plot_image_is_uptodate(testcase)

      source_fullpath = FileTool2.getFileFullPath("MotorDriveUnit_BasicModelEfficiencyPlot.m");
      destination_fullpath = FileTool2.getFileFullPath("screenshot-MDU-BasicModelEfficiencyPlot.png");

      newer = FileTool2.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if newer
        % Display the time stamps.
        FileTool2.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath, DisplayInfo=true);

        fig = figure;
        fig.Position(3) = 400;  % width
        fig.Position(4) = 300;  % height
        fig.Theme = "light";

        ax = axes(fig);

        fig = MotorDriveUnit_BasicModelEfficiencyPlot( ...
          ParentAxes = ax, ...
          ContourLevelsPercent = simscape.Value([1 60 80 90 92 94 96 97 98 99], "1") );

        disp("Update the screenshot image of a figure.")
        exportgraphics(fig, destination_fullpath)

      end  % if

      newer = FileTool2.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      verifyFalse(testcase, newer)

    end  % function

    function markdown_files_exist(testcase)
      % Check that Markdown files exist for all plain-text Live Script files in pwd.
      % Markdowns files are assumed to be in the markdown folder in pwd.

      % Use FileCollection to select Live Scripts.
      mfile_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(pwd, "*.m"));

      % Select Live Scripts.
      % https://www.mathworks.com/help/matlab/ref/matlab.buildtool.io.filecollection.select.html
      live_script_file_collection = select(mfile_collection, @(p) FileTool2.isPlainTextLiveScript(p));

      [folder_path, base_file_name, ~] = fileparts(live_script_file_collection.paths');
      markdown_files = fullfile(folder_path, "markdown", base_file_name + ".md");

      file_exists = isfile(markdown_files);

      actual = nnz(file_exists);
      expected = numel(live_script_file_collection.paths);

      verifyTrue(testcase, actual > 0)
      verifyEqual(testcase, actual, expected)

    end  % function

    function markdowns_are_uptodate(testcase)
      % Make sure that all Live Scripts have been converted to markdown files.
      n = FileTool2.batchGenerateMarkdowns( ...
        LiveScriptFolderNames = pwd, ...
        MarkdownFolderPath = "markdown");

      if n > 0
        n = FileTool2.batchGenerateMarkdowns( ...
          LiveScriptFolderNames = pwd, ...
          MarkdownFolderPath = "markdown", DisplayInfo = true);
      end  % if

      % Add created files under the markdown folder to the project.
      addFolderIncludingChildFiles(currentProject, fullfile(pwd, "markdown"));

      verifyEqual(testcase, n, 0)

    end  % function

  end  % methods

end  % classdef
