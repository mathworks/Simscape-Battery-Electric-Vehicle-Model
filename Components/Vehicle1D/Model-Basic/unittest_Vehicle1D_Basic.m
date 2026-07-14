classdef unittest_Vehicle1D_Basic < matlab.unittest.TestCase
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
      target_name = "Vehicle1D_Basic_params";
      target_fullpath = bev1mus.FileUtil.getFileFullPath(target_name);

      % Make sure that the target file is in the same folder as this test file.
      verifyTrue(testcase, fileparts(target_fullpath) == pwd)

      evalin("base", target_name)  % !test-target
    end  % function

    function PassingTest_2(testcase)
      target_name = "Vehicle1D_Basic_refsub";
      target_fullpath = bev1mus.FileUtil.getFileFullPath(target_name);

      % Make sure that the target file is in the same folder as this test file.
      verifyTrue(testcase, fileparts(target_fullpath) == pwd)

      load_system(target_name)  % !test-target
    end  % function

    %% Test callbacks

    function CallbackButtonBlock_1(testcase)
      %%
      % Check that the callback in Callback Button blocks works.

      evalin("base", "Vehicle1D_Basic_params")

      refsub_name = "Vehicle1D_Basic_refsub";
      refsub_fullpath = bev1mus.FileUtil.getFileFullPath(refsub_name);

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

    %% Other tests

    function screenshot_plot(~)
      %%
      % Take the screenshot of a plot of vehicle 1d force based on the block parameters.
      % !todo: Ideally, do not take a screenshot if it already exists and is newer than the source.

      % Load block parameters in the base workspace.
      evalin("base", "Vehicle1D_Basic_params")

      % Set up the data set using the target block in the model.
      ds = bev1mus.app.Vehicle1DForce.Vehicle1DForceDataSet( ...
        BlockPath="Vehicle1D_Basic_refsub/Longitudinal Vehicle");

      % Create a plot.
      fig = bev1mus.app.Vehicle1DForce.plotVehicle1DForce(DataSource="dataset", DataSet=ds);
      fig.Position(3:4) = [500, 400];  % width height

      % Take a screenshot.
      media_path = fullfile(currentProject().RootFolder, "Components", "Vehicle1D", "media");
      if not(isfolder(media_path))
        mkdir(media_path)
      end  % if
      pngfile_fullpath = fullfile(media_path, "screenshot-Vehicle1D-force-plot.png");
      disp("Exporting: " + pngfile_fullpath)
      exportgraphics(fig, pngfile_fullpath)

    end  % function

  end  % methods
end  % classdef
