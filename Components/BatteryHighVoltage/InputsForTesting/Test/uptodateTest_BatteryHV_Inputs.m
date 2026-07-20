classdef uptodateTest_BatteryHV_Inputs < matlab.unittest.TestCase
  % Class-based unit test

  % Author Class-Based Unit Tests in MATLAB 
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2026 The MathWorks, Inc.

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

    function screenshot_is_uptodate_1(testcase)
      %%
      model_name = "HarnessModel_BatteryHV_Inputs";  %!screenshot-target
      image_filename = "screenshot-" + model_name + ".png";

      source_fullpath = bevutil1.FileUtil.getFileFullPath(model_name + ".mdl");

      destination_folder = fullfile(currentProject().RootFolder, "Components", "BatteryHighVoltage", "InputsForTesting", "media");
      destination_fullpath = fullfile(destination_folder, image_filename);

      source_is_newer = bevutil1.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if source_is_newer
        disp("Taking screenshot: " + destination_fullpath)

        load_system(model_name)

        if not(bdIsSubsystem(model_name))
          % Update the model before taking a screenshot.
          % This ensures that the model is properly updated without errors and ready to run.
          % It also updates the canvas rendering.
          set_param(model_name, SimulationCommand = "update")
        end  % if

        bevutil1.ModelUtil.screenshotSimulink( ...
          OutputFileName = image_filename, ...
          SimulinkModelName = model_name, ...
          SaveFolder = destination_folder );

      else
        disp("Skipping. Screenshot is up to date.")

      end  % if

      source_is_newer = bevutil1.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      verifyFalse(testcase, source_is_newer)

    end  % function

    function screenshot_is_uptodate_2(testcase)
      %%
      model_name = "Inputs_BatteryHV_refsub";  %!screenshot-target
      image_filename = "screenshot-" + model_name + ".png";

      source_fullpath = bevutil1.FileUtil.getFileFullPath(model_name + ".mdl");

      destination_folder = fullfile(currentProject().RootFolder, "Components", "BatteryHighVoltage", "InputsForTesting", "media");
      destination_fullpath = fullfile(destination_folder, image_filename);

      source_is_newer = bevutil1.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if source_is_newer
        disp("Taking screenshot: " + destination_fullpath)

        load_system(model_name)

        if not(bdIsSubsystem(model_name))
          % Update the model before taking a screenshot.
          % This ensures that the model is properly updated without errors and ready to run.
          % It also updates the canvas rendering.
          set_param(model_name, SimulationCommand = "update")
        end  % if

        bevutil1.ModelUtil.screenshotSimulink( ...
          OutputFileName = image_filename, ...
          SimulinkModelName = model_name, ...
          SaveFolder = destination_folder );

      else
        disp("Skipping. Screenshot is up to date.")

      end  % if

      source_is_newer = bevutil1.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      verifyFalse(testcase, source_is_newer)

    end  % function

    function plot_image_is_uptodate_1(testcase)
      %%
      source_name = "BuildInputs_BatteryHV_Random.m";  %!screenshot-target
      image_filename = "plot-Inputs_BatteryHV_Random-LoadCurrent.png";

      source_fullpath = bevutil1.FileUtil.getFileFullPath(source_name);

      destination_folder = fullfile(currentProject().RootFolder, "Components", "BatteryHighVoltage", "InputsForTesting", "media");
      destination_fullpath = fullfile(destination_folder, image_filename);

      source_is_newer = bevutil1.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if source_is_newer
        disp("Saving plot image: " + destination_fullpath)

        % ---------------------------------------------------------------------
        % Create a plot.
        data = BuildInputs_BatteryHV_Random();
        fig = figure;
        fig.Position(3:4) = [1000 300];  % width height

        bevutil1.SignalUtil.plotLookupTable1D( ...
          data.Input_LoadCurrent_TimePoints.value("s"), ...
          data.Input_LoadCurrent_Data.value("A"), ...
          InterpolationInterval=0.5, ParentAxes=axes(fig))

        ax = fig.CurrentAxes;
        xlabel(ax, "Time (s)")
        ylabel(ax, "(A)")
        title(ax, "Load current")
        % ---------------------------------------------------------------------

        exportgraphics(fig, destination_fullpath)

      else
        disp("Skipping. Screenshot is up to date.")

      end  % if

      source_is_newer = bevutil1.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      verifyFalse(testcase, source_is_newer)

    end  % function

  end  % methods
end  % classdef
