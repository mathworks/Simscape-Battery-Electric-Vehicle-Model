classdef uptodateTest_BEV < matlab.unittest.TestCase
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
    % Functions in this "TestMethodSetup" section always run before
    % each test defined in the "Test" section runs.

    function test_method_setup_1(testcase)
      %%
      % Close all before test
      close all
      bdclose all
      evalin("base", "clearvars")

      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @closeAllAfterTest)
      function closeAllAfterTest
        % Close/delete all figure windows. This closes/deletes not only the test targets but also
        % all the other figure windows too to provide clean state for the next test.
        figs = findall(0, Type="Figure");
        if not(any(isempty(figs)))
          disp("Deleting figures (" + numel(figs) + ")")
          delete(figs)
        end  % if

        bdclose all

        % Do not clear variables in the base workspace at the end of a test
        % to make it easy to debug after test if necessary.

      end  % nested function
    end  % function

  end  % methods

  methods (Test)
    % Functions in this "Test" section are the tests.
    % Before each function in this section runs, functions defined in the TestMethodSetup section run.

    %% Up-to-date tests

    function html_is_uptodate(testcase)
      %%
      % Make sure the main script HTML file is up to date.

      top_folder = fullfile(currentProject().RootFolder, "BEV");

      source_fullpath = fullfile(top_folder, "BEV_main_script.m");
      verifyTrue(testcase, isfile(source_fullpath))

      destination_fullpath = fullfile(top_folder, "BEV_main_script.html");
      if isfile(destination_fullpath)
        do_export = bevutil1.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      else
        do_export = true;
      end  % if

      if do_export
        disp("Exporting HTML from: " + source_fullpath)
        % This can take time, for example, if it runs simulation.
        result_path = export(source_fullpath, destination_fullpath, Run=true, Format="html", HideCode=true);
        disp("Generated: " + result_path)
      end  % if

      is_newer = bevutil1.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      verifyFalse(testcase, is_newer)
    end  % function

    function model_screenshot_is_uptodate(testcase)
      %%

      top_folder = fullfile(currentProject().RootFolder, "BEV");
      verifyTrue(testcase, isfolder(top_folder))

      model_name = "BEV_system_model";
      image_filename = "screenshot-BEV_system_model.png";

      source_fullpath = fullfile(top_folder, model_name+".mdl");
      verifyTrue(testcase, isfile(source_fullpath))

      destination_fullpath = fullfile(top_folder, "Utility", image_filename);

      is_newer = bevutil1.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if is_newer
        disp("Taking screenshot: " + model_name)

        load_system(model_name)

        % Update the model before taking screenshot.
        % This ensures that the model is properly updated without errors and ready to run.
        % This also updates the canvas rendering.
        set_param(model_name, SimulationCommand = "update")

        result = bevutil1.ModelUtil.screenshotSimulink( ...
          OutputFileName = destination_fullpath, ...
          SimulinkModelName = model_name);

        disp("Generated: " + result.OutputFullPath)
      end  % if

      is_newer = bevutil1.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);

      verifyFalse(testcase, is_newer)

    end  % function

  end  % methods
end  % classdef
