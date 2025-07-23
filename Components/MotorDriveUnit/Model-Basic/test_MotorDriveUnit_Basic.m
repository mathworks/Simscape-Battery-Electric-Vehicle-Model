classdef test_MotorDriveUnit_Basic < matlab.unittest.TestCase
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

    ComponentID (1,1) string = "MotorDriveUnit"

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
      disp("# Starting test class with ModelID: " + testcase.ModelID)
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

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(testcase)
      % Run code, for example, MotorDriveUnit_Basic_params.
      target_name = testcase.ComponentID + "_" + testcase.ModelID + "_params";
      target_fullpath = FileTool1.getFileFullPath(target_name);
      disp("Testing: " + target_fullpath)
      evalin("base", target_name)  % !test-target
    end  % function

    function PassingTest_2(testcase)
      % Load system, for example, MotorDriveUnit_Basic_refsub.
      load_system(testcase.ComponentID + "_" + testcase.ModelID + "_refsub")  % !test-target
    end  % function

    function PassingTest_3(testcase)
      % Run code, for example, MotorDriveUnit_setRefsub_Basic.
      target_name = testcase.ComponentID + "_setRefsub_" + testcase.ModelID;
      target_fullpath = FileTool1.getFileFullPath(target_name);
      disp("Testing: " + target_fullpath)
      evalin("base", target_name)  % !test-target
    end  % function

    function PassingTest_4(~)
      target_name = "MotorDriveUnit_BasicModelEfficiencyPlot";
      target_fullpath = FileTool1.getFileFullPath(target_name);
      disp("Testing: " + target_fullpath)
      evalin("base", target_name)  % !test-target
    end  % function

    function PassingTest_5(~)
      target_name = "MotorDriveUnit_BasicModelEfficiencyDoc";
      target_fullpath = FileTool1.getFileFullPath(target_name);
      disp("Testing: " + target_fullpath)
      evalin("base", target_name)  % !test-target
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

    %% Up-to-date test

    function plot_image_is_uptodate(testcase)

      source_fullpath = FileTool1.getFileFullPath("MotorDriveUnit_BasicModelEfficiencyPlot.m");
      destination_fullpath = FileTool1.getFileFullPath("screenshot-MDU-BasicModelEfficiencyPlot.png");

      newer = FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if newer
        % Display the time stamps.
        FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath, DisplayInfo=true);

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

      newer = FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      verifyFalse(testcase, newer)

    end  % function

  end  % methods

end  % classdef
