classdef unittest_MotorDriveUnit_settings < matlab.unittest.TestCase
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

    %% Link check

    function test_OpenApp_CallbackButton_1(testcase)
      % This test validates the followings:
      % - The model has "Open app" button at the top layer.
      % - The button contains a callback function pointing to the app.
      %
      % This test does not launch the app.
      % Testing the app must be done separately.

      app_name = "MotorDriveUnitSimulationApp";

      open_system("HarnessModel_MotorDriveUnit")

      target_block_path = "HarnessModel_MotorDriveUnit/Open app";

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

    function linked_commands_in_live_script_1(testcase)
      % Live scripts can have hyperlinks that are MATLAB commands.
      % An example is "command" in the text "[some text](matlab:command)"
      % where "some text" is rendered with a hyperlink "command" which
      % is passed to MATLAB when the link is clicked.
      %
      % This test makes sure there are no broken links.

      target_fullpath = FileTool2.getFileFullPath("MotorDriveUnit_Description.m");

      link_table = FileTool2.getLinkedCommandFromPlainTextLiveScript(target_fullpath);

      if height(link_table) == 0
        disp("No hyperlinked MATLAB commands were found.")

        return

      end  % if

      for ii = 1 : height(link_table)
        matlab_command = link_table.Command(ii);
        disp("Hyperlinked MATLAB command: " + matlab_command)

        if startsWith(matlab_command, "openInProject(")
          % Assume that the argument to the openInProject is a simple word representing
          % a MATLAB code file or a Simulink model file.
          % For example, "hello" in openInFile("hello") should be one of
          % "hello.m", "hello.mlx", "hello.mdl", or "hello.slx".
          %
          % This test checks that the main target file exists.
          % This test should not actually open it.

          main_target = extractBetween(matlab_command, "("+("'"|""""), ("'"|"""")+")");
          fullpath = strings(4, 1);
          fullpath(1) = FileTool2.getFileFullPath(main_target + ".m", ReturnIfNotFound=true);
          fullpath(2) = FileTool2.getFileFullPath(main_target + ".mlx", ReturnIfNotFound=true);
          fullpath(3) = FileTool2.getFileFullPath(main_target + ".mdl", ReturnIfNotFound=true);
          fullpath(4) = FileTool2.getFileFullPath(main_target + ".slx", ReturnIfNotFound=true);
          logical_index = fullpath ~= "";

          verifyEqual(testcase, nnz(logical_index), 1)

        elseif endsWith(matlab_command, "App")
          % Assume that the name of an app command always ends with "App".
          % This test checks that the app file exists.
          % This test should not actually open the app.

          main_target = matlab_command + ".m";
          fullpath = FileTool2.getFileFullPath(main_target, ReturnIfNotFound=true);

          verifyTrue(testcase, fullpath ~= "")

        else
          % If the MATLAB command is something else, evaluate it.
          % Ideally, the execution of this test should not come into this branch.
          % This is a passing test.
          disp("Evaluating: " + matlab_command)

          eval(matlab_command)

          verifyTrue(testcase, true)

        end  % if

        % Close what opened to keep memory consumption low.
        % !todo: Find a way to close an app.
        close all
        bdclose all
      end  % for
    end  % function

  end  % methods

end  % classdef
