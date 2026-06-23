classdef uptodateTest_Vehicle1D < matlab.unittest.TestCase
  % Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser (testBrowser)
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2021-2026 The MathWorks, Inc.

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
    % Before a function in this section runs, the TestSetup function
    % defined in the "TestMethodSetup" section runs.

    %% Up-to-date tests

    function description_html_is_uptodate(testcase)
      %%

      % Make sure the description HTML file is up to date.

      source_fullpath = FileUtil1.getFileFullPath("Vehicle1D_Description.m");
      destination_fullpath = FileUtil1.getFileFullPath("Vehicle1D_Description.html");

      % This test uses a conditional branch as a special case because it is practical.
      newer = FileUtil1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if newer
        % The export command saves the generated file in the current working folder (pwd).
        % When this test runs, pwd is the folder where this test code file exists.
        actual_path = string(export(source_fullpath, Run=true, Format="html", HideCode=true));
        expected_path = destination_fullpath;
        verifyEqual(testcase, actual_path, expected_path)
      end  % if

      newer = FileUtil1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath, DisplayInfo=true);
      verifyFalse(testcase, newer)

    end  % function

    function markdown_files_exist(testcase)
      %%

      % Check that Markdown files exist for all plain-text Live Script files in pwd.
      % Markdowns files are assumed to be in the markdown folder in pwd.

      % Use FileCollection to select Live Scripts.
      mfile_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(pwd, "*.m"));

      % Select Live Scripts.
      % https://www.mathworks.com/help/matlab/ref/matlab.buildtool.io.filecollection.select.html
      live_script_file_collection = select(mfile_collection, @(p) FileUtil1.isPlainTextLiveScript(p));

      [folder_path, base_file_name, ~] = fileparts(live_script_file_collection.paths');
      markdown_files = fullfile(folder_path, "markdown", base_file_name + ".md");

      file_exists = isfile(markdown_files);

      actual = nnz(file_exists);
      expected = numel(live_script_file_collection.paths);

      verifyTrue(testcase, actual > 0)
      verifyEqual(testcase, actual, expected)

    end  % function

    function markdowns_are_uptodate(testcase)
      %%

      % Make sure that all Live Scripts have been converted to markdown files.
      n = FileUtil1.batchGenerateMarkdowns( ...
        LiveScriptFolderNames = pwd, ...
        MarkdownFolderPath = "markdown");

      if n > 0
        n = FileUtil1.batchGenerateMarkdowns( ...
          LiveScriptFolderNames = pwd, ...
          MarkdownFolderPath = "markdown", DisplayInfo = true);
      end  % if

      % Add created files under the markdown folder to the project.
      addFolderIncludingChildFiles(currentProject, fullfile(pwd, "markdown"));

      verifyEqual(testcase, n, 0)

    end  % function

    function model_screenshot_is_uptodate(testcase)
      %%

      top_folder = fullfile(currentProject().RootFolder, "Components", "Vehicle1D");
      verifyTrue(testcase, isfolder(top_folder))

      model_name = "HarnessModel_Vehicle1D";
      image_filename = "screenshot-" + model_name + ".png";

      source_fullpath = fullfile(top_folder, model_name + ".mdl");
      verifyTrue(testcase, isfile(source_fullpath))

      destination_fullpath = fullfile(top_folder, "Utility", image_filename);
      if isfile(destination_fullpath)
        source_is_newer = FileUtil1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      else
        source_is_newer = true;
      end  % if

      if source_is_newer
        disp("Taking screenshot: " + source_fullpath)

        load_system(model_name)

        % Update the model before taking screenshot.
        % This ensures that the model is properly updated without errors and ready to run.
        % This also updates the canvas rendering.
        set_param(model_name, SimulationCommand = "update")

        ModelUtil1.screenshotSimulink( ...
          OutputFileName = destination_fullpath, ...
          SimulinkModelName = model_name);

        disp("Saved: " + destination_fullpath)
      end  % if

      destination_is_newer = not(FileUtil1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath));
      verifyTrue(testcase, destination_is_newer)

    end  % function

    function plot_screenshot_is_uptodate(testcase)
      %%

      top_folder = fullfile(currentProject().RootFolder, "Components", "Vehicle1D");
      verifyTrue(testcase, isfolder(top_folder))

      % Use the Utility API.
      target_function = @Vehicle1D1.plotVehicle1DPerformance;
      source_fullpath = fullfile(currentProject().RootFolder, "Utility", "+Vehicle1D1", "plotVehicle1DPerformance.m");
      verifyTrue(testcase, isfile(source_fullpath))

      destination_fullpath = fullfile(top_folder, "Utility", "screenshot-Vehicle1D-force-plot.png");
      if isfile(destination_fullpath)
        do_export = FileUtil1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      else
        do_export = true;
      end  % if

      if do_export
        disp("Generating a PNG file: " + destination_fullpath)

        fig = figure;
        fig.Position(3) = 600;  % width
        fig.Position(4) = 500;  % height
        fig.Theme = "light";

        target_function(ParentAxes=axes(fig));

        exportgraphics(fig, destination_fullpath)

        delete(fig)

        disp("done.")
      end  % if

      destination_is_newer = not(FileUtil1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath));
      verifyTrue(testcase, destination_is_newer)

    end  % function

    function app_screenshot_is_uptodate(testcase)
      %%

      top_folder = fullfile(currentProject().RootFolder, "Components", "Vehicle1D");
      verifyTrue(testcase, isfolder(top_folder))

      % Use the Utility API.
      source_fullpath = fullfile(currentProject().RootFolder, "Utility", "Vehicle1DApp.m");
      verifyTrue(testcase, isfile(source_fullpath))

      destination_fullpath = fullfile(top_folder, "Utility", "screenshot-Vehicle1DApp.png");

      if isfile(destination_fullpath)
        needs_update = FileUtil1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      else
        needs_update = true;
      end  % if

      if needs_update
        app = Vehicle1DApp;  % !screenshot-target
        app.Window.MainFigure.Theme = "light";
        app.PresetDropDownUI.Value = "Large SUV";
        drawnow
        exportapp(app.Window.MainFigure, destination_fullpath)
        delete(app.Window.MainFigure)
      else
        disp("The screenshot is up to date.")
      end  % if

      destination_is_newer = not(FileUtil1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath));
      verifyTrue(testcase, destination_is_newer)

    end  % function

  end  % methods
end  % classdef
