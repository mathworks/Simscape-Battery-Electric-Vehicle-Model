classdef unittest_BatteryHV_settings < matlab.unittest.TestCase
  % Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2025-2026 The MathWorks, Inc.

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

    %% Solver settings

    function solver_settings(testcase)
      load_system("HarnessModel_Vehicle1D")
      verifyTrue(testcase, get_param(gcs, "SolverType") == "Variable-step")
      verifyTrue(testcase, get_param(gcs, "SolverName") == "daessc")
    end  % function

    %% Parameter settings

    function preload_parameters(testcase)
      % Check that the model loads parameters in the callback.
      parameter_filename = "setupHarness_BatteryHV";  % without ".m"
      load_system("HarnessModel_BatteryHV")
      callback_text = string(get_param(gcs, "PreLoadFcn"));
      verifyTrue(testcase, contains(callback_text, lineBoundary("start") + parameter_filename + alphanumericBoundary))
    end  % function

    %% Subsystem Reference block settings

    function subsystem_reference_block_settings(testcase)
      % Check the settings of the Subsystem Reference block in the specified model.

      model_name = "HarnessModel_BatteryHV";

      load_system(model_name)
      block_paths = string(getfullname(Simulink.findBlocksOfType(bdroot, "SubSystem", "ReferencedSubsystem", ".", ...
        Simulink.FindOptions("RegExp", 1))));
      num_blocks = numel(block_paths);
      if num_blocks == 0

        return

      end  % if
      for k = 1 : num_blocks
        target_block_path = block_paths(k);
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

    function Button_callback_web_1(testcase)
      % Find Button blocks in the specified model and check if the callback uses the web command:
      %   web("target_file")
      % If yes, check that the target_file exists.
      %
      % Also check that there is only one web command in one callback.

      model_name = "HarnessModel_BatteryHV";
      target_command = "web";

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
        lines = bevutil1.CodeUtil.cleanupCodeText(ClickFcn_text);
        if isempty(lines)

          verifyFail(testcase, "Callback must contain code.")

        end  % if

        logical_index = startsWith(lines, target_command + "(");
        if not(any(logical_index))
          % There is no target command.

          continue

        end  % if
        if nnz(logical_index) ~= 1

          verifyFail(testcase, "Only one " + target_command + " command is allowed.")

          return

        end  % if
        % At this point, nnz(logical_index) == 1
        target_line = lines(logical_index);
        disp(" Command: " + target_line)
        sp = optionalPattern(whitespacePattern);
        target_argument = extractBetween(target_line, "("+sp+"""", """"+sp+")");
        target_fullpath = string(which(target_argument));  % !test-target
        verifyTrue(testcase, target_fullpath ~= "")
      end  % for
    end  % function

    %% Live Script's link settings

    function live_script_matlab_links(testcase)
      % Live scripts can have hyperlinks that are MATLAB commands.
      % An example is "command" in the text "[some text](matlab:command)"
      % where "some text" is rendered with a hyperlink "command" which
      % is passed to MATLAB when the link is clicked.
      %
      % This test makes sure there are no broken MATLAB links.

      target_fullpath = bevutil1.FileUtil.getFileFullPath("BatteryHV_Description.m");

      link_table = bevutil1.FileUtil.getLinkedCommandFromPlainTextLiveScript(target_fullpath);

      if height(link_table) == 0
        disp("No hyperlinked MATLAB commands were found.")

        return

      end  % if

      for ii = 1 : height(link_table)
        matlab_command = link_table.Command(ii);
        disp("Hyperlinked MATLAB command: " + matlab_command)

        if startsWith(matlab_command, "bevutil1.ProjectUtil.openInProject(")
          % Assume that the argument to the bevutil1.ProjectUtil.openInProject is a simple word representing
          % a MATLAB code file or a Simulink model file.
          % For example, "hello" in openInFile("hello") should be one of
          % "hello.m", "hello.mlx", "hello.mdl", or "hello.slx".
          %
          % This test checks that the main target file exists.
          % This test does not actually open it.

          main_target = extractBetween(matlab_command, "("+("'"|""""), ("'"|"""")+")");
          fullpath = strings(4, 1);
          fullpath(1) = bevutil1.FileUtil.getFileFullPath(main_target + ".m", ReturnIfNotFound=true);
          fullpath(2) = bevutil1.FileUtil.getFileFullPath(main_target + ".mlx", ReturnIfNotFound=true);
          fullpath(3) = bevutil1.FileUtil.getFileFullPath(main_target + ".mdl", ReturnIfNotFound=true);
          fullpath(4) = bevutil1.FileUtil.getFileFullPath(main_target + ".slx", ReturnIfNotFound=true);
          logical_index = fullpath ~= "";

          verifyEqual(testcase, nnz(logical_index), 1)

        elseif endsWith(matlab_command, "App")
          % Assume that the name of an app command always ends with "App".
          % This test checks that the app file exists.
          % This test should not actually open the app.

          main_target = matlab_command + ".m";
          fullpath = bevutil1.FileUtil.getFileFullPath(main_target, ReturnIfNotFound=true);

          verifyTrue(testcase, fullpath ~= "")

        else
          % If the MATLAB command is something else, evaluate it.
          % Ideally, the execution of this test should not come into this branch.
          % This branch is a passing test.
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
