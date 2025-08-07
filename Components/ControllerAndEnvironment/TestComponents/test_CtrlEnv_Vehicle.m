classdef test_CtrlEnv_Vehicle < matlab.unittest.TestCase
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
      CtrlEnv_Vehicle_getMotorSpeedFromVehicleSpeed
    end  % function

    function PassingTest_2(~)
      CtrlEnv_Vehicle_params
    end  % function

    function PassingTest_3(~)
      load_system("CtrlEnv_Vehicle_refsub")
    end  % function

    function PassingTest_4_error(testcase)
      verifyError(testcase, @() CtrlEnv_Vehicle_ResultsPlot(), "MATLAB:nonExistentField")
    end  % function

    function PassingTest_5(~)
      CtrlEnv_Vehicle_setInitialConditions
    end  % function

    function PassingTest_6(~)
      CtrlEnv_Vehicle_setSimCase
    end  % function

    function PassingTest_7(~)
      CtrlEnv_Vehicle_Simplistic_Case1
    end  % function

    function PassingTest_8(~)
      load_system("CtrlEnv_Vehicle_TestModel")
    end  % function

    function PassingTest_9(~)
      CtrlEnv_Vehicle_TestModelSetup
    end  % function

    %% Test

    function simulation_ends_quickly(testcase)
      target_model = "CtrlEnv_Vehicle_TestModel";
      load_system(target_model)
      %setup_command = "CtrlEnv_setRefsub_" + testcase.ModelID;
      %evalin("base", setup_command)
      % Test that default simulation ends reasonably quickly.
      tic
      sim(target_model);
      verifyThat(testcase, @toc, ...
        matlab.unittest.constraints.Eventually( ...
        matlab.unittest.constraints.IsLessThan(10), WithTimeoutOf = 10))  % !test-target
    end  % function

    %% Up-to-date tests

    function markdown_files_exist(testcase)
      % Check that Markdown files exist for all plain-text Live Script files in pwd.
      % Markdowns files are assumed to be in the markdown folder in pwd.

      % Use FileCollection to select Live Scripts.
      mfile_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(pwd, "*.m"));

      % Select Live Scripts.
      % https://www.mathworks.com/help/matlab/ref/matlab.buildtool.io.filecollection.select.html
      live_script_file_collection = select(mfile_collection, @(p) FileTool2.isPlainTextLiveScript(p));

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
      n = FileTool2.batchGenerateMarkdowns( ...
        LiveScriptFolderNames = pwd, ...
        MarkdownFolderPath = "markdown");

      if n > 0
        n = FileTool2.batchGenerateMarkdowns( ...
          LiveScriptFolderNames = pwd, ...
          MarkdownFolderPath = "markdown", DisplayInfo = true);
      end  % if

      % Add created files under the markdown folder to the project.
      addFolderIncludingChildFiles(currentProject, fullfile(pwd, "markdown"));

      verifyEqual(testcase, n, 0)

    end  % function

  end  % methods

end  % classdef
