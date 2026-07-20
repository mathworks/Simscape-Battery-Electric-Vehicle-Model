classdef unittest_MotorDriveUnit_Basic < matlab.unittest.TestCase
  % Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2021-2026 The MathWorks, Inc.

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

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(testcase)
      target_name = "MotorDriveUnit_Basic_params";
      target_fullpath = bevutil1.FileUtil.getFileFullPath(target_name);

      % Make sure that the target file is in the same folder as this test file.
      verifyTrue(testcase, fileparts(target_fullpath) == pwd)

      evalin("base", target_name)  % !test-target
    end  % function

    function PassingTest_2(testcase)
      target_name = "MotorDriveUnit_Basic_refsub";
      target_fullpath = bevutil1.FileUtil.getFileFullPath(target_name);

      % Make sure that the target file is in the same folder as this test file.
      verifyTrue(testcase, fileparts(target_fullpath) == pwd)

      load_system(target_name)  % !test-target
    end  % function

    %% Test Callback Button blocks

    function CallbackButton_1(testcase)
      %%
      % Test the command, ClickFcn, specified in Callback Button blocks.
      % Assume that the command text is one line.

      target_name = "MotorDriveUnit_Basic_params";
      target_fullpath = bevutil1.FileUtil.getFileFullPath(target_name);
      verifyTrue(testcase, fileparts(target_fullpath) == pwd)
      evalin("base", target_name)

      refsub_name = "MotorDriveUnit_Basic_refsub";
      refsub_fullpath = bevutil1.FileUtil.getFileFullPath(refsub_name);

      % Make sure that the target file is in the same folder as this test file.
      verifyTrue(testcase, fileparts(refsub_fullpath) == pwd)

      load_system(refsub_name)

      blocks = string(getfullname(Simulink.findBlocksOfType(refsub_name, "CustomCallbackButton")));

      num_blocks = numel(blocks);
      for k = 1 : num_blocks
        target_block = blocks(k);
        disp("Found a Custom Callback Button: " + target_block)
        ClickFcn_text = string(get_param(target_block, "ClickFcn"));
        disp("Evaluating ClickFcn...")
        eval(ClickFcn_text)  % !test-target
      end  % for
    end  % function

    %% other tests

    function test_MotorDriveUnit_getBasicModelBlockInfo_1(testcase)
      %%
      % Load workspace variables that are required by the test target.
      % Without them, the test fails.
      evalin("base", "MotorDriveUnit_Basic_params")

      model_name = "MotorDriveUnit_Basic_refsub";
      block_path = model_name + "/Motor & Drive (Driveline)";

      % Load the model and select the target block.
      load_system(model_name)
      [system_path, block_name, ~] = fileparts(block_path);
      set_param(0, "CurrentSystem", system_path)
      set_param(gcs, "CurrentBlock", block_name)

      info = MotorDriveUnit_getBasicModelBlockInfo;  % !test-target
      parameter_names = string(fieldnames(info));

      % Check that there are parameters "MaxTorque" and "MaxPower".
      % There are more parameters. This is not a comprehensive test.
      verifyEqual(testcase, nnz(startsWith(parameter_names, "MaxTorque")), 1)
      verifyEqual(testcase, nnz(startsWith(parameter_names, "MaxPower")), 1)

    end  % function

    function screenshot_plot(~)
      %%
      % Take the screenshot of a plot of motor efficiency map based on the block parameters.
      % !todo: Ideally, do not take a screenshot if it already exists and is newer than the source.

      % Load block parameters in the base workspace.
      evalin("base", "MotorDriveUnit_Basic_params")

      % Set up the data set using the target block in the model.
      ds = bevutil1.app.AbstractMotorEfficiency.AbstractMotorEfficiencyDataSet( ...
        BlockPath="MotorDriveUnit_Basic_refsub/Motor & Drive (Driveline)");

      % Create a plot.
      fig = bevutil1.app.AbstractMotorEfficiency.plotAbstractMotorEfficiency(DataSource="dataset", DataSet=ds);
      fig.Position(3:4) = [500, 400];  % width height

      % Take a screenshot.
      media_path = fullfile(currentProject().RootFolder, "Components", "MotorDriveUnit", "media");
      if not(isfolder(media_path))
        mkdir(media_path)
      end  % if
      pngfile_fullpath = fullfile(media_path, "screenshot-MDU-BasicModelEfficiencyPlot.png");
      disp("Exporting: " + pngfile_fullpath)
      exportgraphics(fig, pngfile_fullpath)

    end  % function

  end  % methods
end  % classdef
