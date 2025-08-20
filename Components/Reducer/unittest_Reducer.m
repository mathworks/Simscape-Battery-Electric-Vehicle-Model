classdef unittest_Reducer < matlab.unittest.TestCase
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
    ModelName (1,1) string = "HarnessModel_Reducer"
  end  % properties

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
      HarnessSetup_Reducer  % !test-target
    end  % function

    function PassingTest_2(testcase)
      load_system(testcase.ModelName)  % !test-target
    end  % function

    function PassingTest_3(testcase)
      sim(testcase.ModelName);  % !test-target
    end  % function

    %% Up-to-date tests

    function screenshot_is_uptodate(testcase)
      model_name = "HarnessModel_Reducer";
      image_filename = "screenshot-" + model_name + ".png";

      source_fullpath = FileTool2.getFileFullPath(model_name + ".mdl");
      destination_fullpath = FileTool2.getFileFullPath(image_filename);

      newer = FileTool2.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if newer
        load_system(model_name)

        % Update the model before taking screenshot.
        % This ensures that the model is properly updated without errors and ready to run.
        % This also updates the canvas rendering.
        set_param(model_name, SimulationCommand = "update")

        ModelTool1.screenshotSimulink( ...
          OutputFileName = image_filename, ...
          SimulinkModelName = model_name, ...
          SaveFolder = pwd );
      end  % if

      newer = FileTool2.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      verifyFalse(testcase, newer)

    end  % function

    %% Link check

    function test_CallbackButton_setting_1(testcase)
      % This test checks the setting and does not test the callback action.

      open_system(testcase.ModelName)

      target_block_path = testcase.ModelName + "/Input/Edit motor side input torque";

      block_paths = string(getfullname(Simulink.findBlocksOfType(gcs, "CallbackButton")));
      logical_index = target_block_path == block_paths;
      verifyEqual(testcase, nnz(logical_index), 1)

      % !todo: Avoid using pause.
      % For now, pause is necessary for get_param to return the expected value.
      % Without the pause, get_param returns "" for ClickFcn.
      pause(3)
      click_function_string = string(get_param(target_block_path, "ClickFcn"));
      click_function_string = strtrim(click_function_string);

      actual = click_function_string;
      expected = "SignalDesignApp(gcs + ""/Motor side input torque"")";
      verifyEqual(testcase, actual, expected)
    end  % function

    function test_CallbackButton_setting_2(testcase)
      % This test checks the setting and does not test the callback action.

      open_system(testcase.ModelName)

      target_block_path = testcase.ModelName + "/Input/Edit axle side input torque";

      block_paths = string(getfullname(Simulink.findBlocksOfType(gcs, "CallbackButton")));
      logical_index = target_block_path == block_paths;
      verifyEqual(testcase, nnz(logical_index), 1)

      % !todo: Avoid using pause.
      % For now, pause is necessary for get_param to return the expected value.
      % Without the pause, get_param returns "" for ClickFcn.
      pause(3)
      click_function_string = string(get_param(target_block_path, "ClickFcn"));
      click_function_string = strtrim(click_function_string);

      actual = click_function_string;
      expected = "SignalDesignApp(gcs + ""/Axle side input torque"")";
      verifyEqual(testcase, actual, expected)
    end  % function

  end  % methods

end  % classdef
