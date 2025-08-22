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

    %% Solver settings

    function solver_settings(testcase)
      load_system("HarnessModel_MotorDriveUnit")

      s = string(get_param(gcs, "SolverType"));
      verifyEqual(testcase, s, "Variable-step")

      s = string(get_param(gcs, "SolverName"));
      verifyEqual(testcase, s, "daessc")
    end  % function

    %% Parameter settings

    function preload_parameters(testcase)
      % Check that the model loads parameters in the callback.
      parameter_filename = "HarnessSetup_MotorDriveUnit";  % without ".m"
      load_system("HarnessModel_MotorDriveUnit")
      callback_text = string(get_param(gcs, "PreLoadFcn"));
      verifyTrue(testcase, contains(callback_text, lineBoundary("start") + parameter_filename + alphanumericBoundary))
    end  % function

    %% Subsystem Reference block settings

    function subsystem_reference_block_settings(testcase)
      % Check the settings of the Subsystem Reference block in the specified model.

      model_name = "HarnessModel_MotorDriveUnit";

      load_system(model_name)
      block_paths = string(getfullname(Simulink.findBlocksOfType(bdroot, "SubSystem", "ReferencedSubsystem", ".", ...
        Simulink.FindOptions("RegExp", 1))));
      num_blocks = numel(block_paths);
      if num_blocks == 0

        return

      end  % if
      for ii = 1 : num_blocks
        target_block_path = block_paths(ii);
        disp("Checking: " + target_block_path)

        % The OpenFcn callback has to have the following code.
        %   open_system(gcb, "force")
        openFcn_text = string(get_param(target_block_path, "OpenFcn"));
        target_text = lineBoundary("start") + "open_system(gcb, ""force"")";
        verifyTrue(testcase, contains(openFcn_text, target_text));

        % IO port labels must be visible, i.e.,
        % the Icon Transparency must be "Opaque with Ports". (Default is "Opaque".)
        actual = string(get_param(target_block_path, "MaskIconOpaque"));
        verifyEqual(testcase, actual, "opaque-with-ports")

      end  % for
    end  % function

    %% Button callback settings

    function Button_callback_set_referenced_subsystems_1(testcase)
      % A callback in a Button block sets referenced subsystems.
      %
      % Check if the callback uses the set_param command with ReferencedSubsystem:
      %   set_param(block_path, ReferencedSubsystem="target_refsub")
      % If yes, check that the target_refsub exists.
      %
      % One callback can be setting multiple referenced subsystems.

      model_name = "HarnessModel_MotorDriveUnit";

      load_system(model_name)
      block_paths = string(getfullname(Simulink.findBlocksOfType(model_name, "CustomCallbackButton")));
      num_blocks = numel(block_paths);
      if num_blocks == 0

        return

      end  % if
      for ii = 1 : num_blocks
        target_block_path = block_paths(ii);
        disp("Checking: " + target_block_path)
        ClickFcn_text = string(get_param(target_block_path, "ClickFcn"));
        lines = CodeTool1.cleanupCodeText(ClickFcn_text);
        if isempty(lines)

          verifyFail(testcase, "Callback must contain code.")

        end  % if

        for jj = 1 : numel(lines)
          target_line = lines(jj);
          is_target = startsWith(target_line, "set_param(") & contains(target_line, "ReferencedSubsystem");
          if not(is_target)

            continue

          end  % if
          disp(" Command: " + target_line)
          sp = optionalPattern(whitespacePattern);
          target_argument = extractBetween(target_line, "ReferencedSubsystem"+sp+"="+sp+"""", """"+sp+")");
          target_fullpath = string(which(target_argument));  % !test-target
          verifyTrue(testcase, target_fullpath ~= "")
        end  % for
      end  % for
    end  % function

    %% Link check

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
