classdef uptodateTest_Reducer_Inputs < matlab.unittest.TestCase
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

    function screenshot_is_uptodate_1(testcase)
      %%
      script_name = "loadLUTData_Reducer_Axle_FlipTorque";  %!screenshot-target
      image_filename = "plot-Reducer_Axle_FlipTorque.png";

      source_fullpath = bevutil1.FileUtil.getFileFullPath(script_name);

      destination_folder = fullfile(currentProject().RootFolder, "Components", "Reducer", "InputsForTesting", "media");
      destination_fullpath = fullfile(destination_folder, image_filename);

      source_is_newer = bevutil1.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if source_is_newer
        disp("Exporting: " + destination_fullpath)

        % ---------------------------------------------------------------------
        % Create a plot.

        % Populate the AxleTorqueInput table data in the base workspace.
        evalin("base", "loadLUTData_Reducer_Axle_FlipTorque")

        AxleTorqueInput = evalin("base", "AxleTorqueInput");

        torque_unit = "N*m";

        fig = bevutil1.SignalUtil.plotLookupTable1D( ...
          AxleTorqueInput.Time.value("s"), ...
          AxleTorqueInput.Torque.value(torque_unit), ...
          InterpolationInterval = 0.1, ...
          PlotXUpperBound = 80, ...
          Title="Axle torque input", XLabel="Time (s)", YLabel=("(" + torque_unit + ")") );

        fig.Position(3:4) = [600 300];  % width height

        % ---------------------------------------------------------------------

        exportgraphics(fig, destination_fullpath)

      else
        disp("Skipping. Screenshot is up to date.")

      end  % if

      source_is_newer = bevutil1.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      verifyFalse(testcase, source_is_newer)

    end  % function

    function screenshot_is_uptodate_2(testcase)
      %%
      script_name = "loadLUTData_Reducer_Motor_FlipTorque";  %!screenshot-target
      image_filename = "plot-Reducer_Motor_FlipTorque.png";

      source_fullpath = bevutil1.FileUtil.getFileFullPath(script_name);

      destination_folder = fullfile(currentProject().RootFolder, "Components", "Reducer", "InputsForTesting", "media");
      destination_fullpath = fullfile(destination_folder, image_filename);

      source_is_newer = bevutil1.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if source_is_newer
        disp("Exporting: " + destination_fullpath)

        % ---------------------------------------------------------------------
        % Create a plot.

        % Populate the MotorTorqueInput table data in the base workspace.
        evalin("base", "loadLUTData_Reducer_Motor_FlipTorque")

        MotorTorqueInput = evalin("base", "MotorTorqueInput");

        torque_unit = "N*m";

        fig = bevutil1.SignalUtil.plotLookupTable1D( ...
          MotorTorqueInput.Time.value("s"), ...
          MotorTorqueInput.Torque.value(torque_unit), ...
          InterpolationInterval = 0.1, ...
          PlotXUpperBound = 80, ...
          Title="Motor torque input", XLabel="Time (s)", YLabel=("(" + torque_unit + ")") );

        fig.Position(3:4) = [600 300];  % width height

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
