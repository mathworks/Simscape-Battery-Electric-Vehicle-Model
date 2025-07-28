classdef test_BEV < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2024-2025 The MathWorks, Inc.

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
      BEV_setup
    end  % function

    function PassingTest_2(~)
      load_system("BEV_system_model");
    end  % function

    function PassingTest_3(~)
      sim("BEV_system_model");
    end  % function

    function PassingTest_4(~)
      evalin("base", "BEV_main_script");
    end  % function

    %% Up-to-date tests

    function html_is_uptodate(testcase)
      % Make sure the main script HTML file is up to date.

      source_fullpath = FileTool1.getFileFullPath("BEV_main_script.m");
      destination_fullpath = FileTool1.getFileFullPath("BEV_main_script.html");

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

    function markdown_files_exist(testcase)
      % Check that Markdown files exist for all plain-text Live Script files in pwd.
      % Markdowns files are assumed to be in the markdown folder in pwd.

      % Use FileCollection to select Live Scripts.
      mfile_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(pwd, "*.m"));

      % Select Live Scripts.
      % https://www.mathworks.com/help/matlab/ref/matlab.buildtool.io.filecollection.select.html
      live_script_file_collection = select(mfile_collection, @(p) FileTool1.isPlainTextLiveScript(p));

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
      n = FileTool1.batchGenerateMarkdowns( ...
        LiveScriptFolderNames = pwd, ...
        MarkdownFolderPath = "markdown");

      if n > 0
        n = FileTool1.batchGenerateMarkdowns( ...
          LiveScriptFolderNames = pwd, ...
          MarkdownFolderPath = "markdown", DisplayInfo = true);
      end  % if

      % Add created files under the markdown folder to the project.
      addFolderIncludingChildFiles(currentProject, fullfile(pwd, "markdown"));

      verifyEqual(testcase, n, 0)

    end  % function

    function model_screenshot_is_uptodate(testcase)
      model_name = "BEV_system_model";
      image_filename = "screenshot-BEV_system_model.png";

      source_fullpath = FileTool1.getFileFullPath(model_name + ".mdl");
      destination_fullpath = FileTool1.getFileFullPath(image_filename);

      newer = FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if newer
        load_system(model_name)

        % Update the model before taking screenshot.
        % This ensures that the model is properly updated without errors and ready to run.
        % This also updates the canvas rendering.
        set_param(model_name, SimulationCommand = "update")

        screenshotSimulink( ...
          OutputFileName = image_filename, ...
          SimulinkModelName = model_name, ...
          SaveFolder = pwd );
      end  % if

      newer = FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      verifyFalse(testcase, newer)

    end  % function

  end  % methods

end  % classdef
