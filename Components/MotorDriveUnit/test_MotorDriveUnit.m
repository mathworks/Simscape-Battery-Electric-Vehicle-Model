classdef test_MotorDriveUnit < matlab.unittest.TestCase
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
    ModelName (1,1) string = "MotorDriveUnit_TestModel"
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
      MotorDriveUnit_Description  % !test-target
    end  % function

    function PassingTest_2(~)
      MotorDriveUnit_TestModelSetup  % !test-target
    end  % function

    function PassingTest_3(testcase)
      load_system(testcase.ModelName)  % !test-target
    end  % function

    function PassingTest_4(testcase)
      sim(testcase.ModelName);  % !test-target
    end  % function

    function PassingTest_5(~)
      MotorDriveUnit_Description  % !test-target
    end  % function

    function PassingTest_6(~)
      MotorDriveUnit_setRefsub
    end  % function

    function PassingTest_7(~)
      MotorDriveUnit_setRefsub_Basic
    end  % function

    function PassingTest_8(~)
      MotorDriveUnit_setRefsub_BasicThermal
    end  % function

    function PassingTest_9(~)
      MotorDriveUnit_setRefsub_SystemTable
    end  % function

    function PassingTest_10(~)
      MotorDriveUnit_setRefsub_SystemThermal
    end  % function

    %% Up-to-date tests

    function html_is_uptodate(testcase)
      source_fullpath = FileTool1.getFileFullPath("MotorDriveUnit_Description.m");
      destination_fullpath = FileTool1.getFileFullPath("MotorDriveUnit_Description.html");

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

    function markdown_is_uptodate(testcase)
      % Make sure that all Live Scripts have been converted to markdown files.
      n = FileTool1.batchGenerateMarkdowns( ...
        LiveScriptFolderNames = pwd, ...
        MarkdownFolderPath = "markdown");

      if n > 0
        n = FileTool1.batchGenerateMarkdowns( ...
          LiveScriptFolderNames = pwd, ...
          MarkdownFolderPath = "markdown", DisplayInfo = true);
      end  % if

      verifyEqual(testcase, n, 0)

    end  % function

    function screenshot_is_uptodate(testcase)
      model_name = "MotorDriveUnit_TestModel";
      image_filename = "screenshot-" + model_name + ".png";

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

    %% Link check

    function test_OpenApp_CallbackButton_1(testcase)
      % This test validates the followings:
      % - The model has "Open app" button at the top layer.
      % - The button contains a callback function pointing to the app.
      %
      % This test does not launch the app.
      % Testing the app must be done separately.

      app_name = "MotorDriveUnitApp";

      open_system(testcase.ModelName)

      target_block_path = testcase.ModelName + "/Open app";

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
      expected = app_name;
      verifyEqual(testcase, actual, expected)
    end  % function

  end  % methods

end  % classdef
