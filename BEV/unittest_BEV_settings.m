classdef unittest_BEV_settings < matlab.unittest.TestCase
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

    %% Callback Button blocks

    function CallbackButtons_ClickFcn_nonempty_1(testcase)
      % Check that all Callback Button blocks in a model have some code in the ClickFcn callback.
      % This test does not check the content of the code.

      target_model = "BEV_system_model";

      load_system(target_model)
      block_paths = string( getfullname( Simulink.findBlocksOfType(target_model, "CustomCallbackButton")));
      num_blocks = numel(block_paths);
      if num_blocks == 0
        disp("No CustomCallbackButton was found in the model: " + target_model)

        return

      end  % if
      disp("Number of Callback Button blocks: " + num_blocks)
      for ii = 1 : num_blocks
        target_block_path = block_paths(ii);
        ClickFcn_text = string( get_param(target_block_path, "ClickFcn"));
        lines = CodeTool1.cleanupCodeText(ClickFcn_text);  % !test-target

        verifyTrue(testcase, all(lines ~= ""))

      end  % for
    end  % function

    function CallbackButtons_ClickFcn_setRefSub_1(testcase)
      % Check if the model has Callback Button blocks that have ClickFcn callback calling set_param with ReferencedSubsystem.
      % If yes, check that the specified refsub files exist.

      target_model = "BEV_system_model";

      load_system(target_model)
      block_paths = string( getfullname( Simulink.findBlocksOfType(target_model, "CustomCallbackButton")));
      num_blocks = numel(block_paths);
      if num_blocks == 0
        disp("No CustomCallbackButtons were found in the model: " + target_model)

        return

      end  % if

      result = ModelTool2.checkRefSubInCallbackButton(target_model, Callback="ClickFcn");
      if isempty(result)
        disp("No referenced subsystems were found in Callback Button blocks.")

        return

      end  % if
      verifyTrue(testcase, all(result.IsRefSub))
    end  % function

    function CallbackButtons_ClickFcn_edit_1(testcase)
      % Check if there are edit commands in Callback Button blocks' ClickFcn callback in a model.
      % If yes, check that the files passed to the edit commands exist.

      target_model = "BEV_system_model";

      load_system(target_model)
      block_paths = string( getfullname( Simulink.findBlocksOfType(target_model, "CustomCallbackButton")));
      num_blocks = numel(block_paths);
      if num_blocks == 0
        disp("No CustomCallbackButtons were found in the model: " + target_model)

        return

      end  % if

      result = ModelTool2.checkEditInCallbackButton(target_model);
      if isempty(result)
        disp("No edit commands were found in Callback Button blocks.")

        return

      end  % if
      verifyTrue(testcase, all(result.Found))
    end  % function

    function CallbackButtons_ClickFcn_plot_1(testcase)
      % Check if there are plot* commands in Callback Button blocks in a model.
      % If yes, check that the plot* commands exist.
      % Example code to check:
      %   SignalTool3.plotSimulink1DLookupTableBlock(gcs + "/Vehicle speed reference")

      target_model = "BEV_system_model";

      load_system(target_model)
      block_paths = string( getfullname( Simulink.findBlocksOfType(target_model, "CustomCallbackButton")));
      num_blocks = numel(block_paths);
      if num_blocks == 0
        disp("No CustomCallbackButton was found in the model: " + target_model)

        return

      end  % if
      ospace = optionalPattern(whitespacePattern);
      namepattern = wildcardPattern(Except="(");
      for ii = 1 : num_blocks
        target_block_path = block_paths(ii);
        ClickFcn_text = string( get_param(target_block_path, "ClickFcn"));
        lines = CodeTool1.cleanupCodeText(ClickFcn_text);
        logical_index = startsWith(lines, lineBoundary("start") + ospace + optionalPattern(namepattern + ".") + "plot" + namepattern + "(");
        target_lines = lines(logical_index);
        if all(target_lines == "")

          continue

        end  % if
        % At this point, each line in the target_lines has a plot command.
        disp("Checking Button block for visualization: " + target_block_path)
        % Get the visualization command name.
        command_name = extractBetween(target_lines, lineBoundary("start") + ospace + textBoundary("start"), "(");
        for jj = 1 : numel(command_name)
          target_command = command_name(jj);

          disp("Visualization command: " + target_command)
          target_fullpath = string( which(target_command));  % !test-target

          verifyTrue(testcase, isfile(target_fullpath))
        end  % for
      end  % for
    end  % function

    function CallbackButtons_ClickFcn_app_1(testcase)
      % Check if there are *App commands in Callback Button blocks in a model.
      % If yes, check that the *App commands exist.
      % Example code to check:
      %   Vehicle1DPerformanceDesignApp(gcs + "/Longitudinal Vehicle")
      %   MotorDriveUnit_BasicModelEfficiencyApp

      target_model = "BEV_system_model";

      load_system(target_model)
      block_paths = string( getfullname( Simulink.findBlocksOfType(target_model, "CustomCallbackButton")));
      num_blocks = numel(block_paths);
      if num_blocks == 0
        disp("No CustomCallbackButton was found in the model: " + target_model)

        return

      end  % if
      ospace = optionalPattern(whitespacePattern);
      namepattern = wildcardPattern(Except="(");
      for ii = 1 : num_blocks
        target_block_path = block_paths(ii);
        ClickFcn_text = string( get_param(target_block_path, "ClickFcn"));
        lines = CodeTool1.cleanupCodeText(ClickFcn_text);
        logical_index = startsWith(lines, lineBoundary("start") + ospace + optionalPattern(namepattern + ".") + namepattern + "App" + (textBoundary("end")|"("));
        target_lines = lines(logical_index);
        if all(target_lines == "")

          continue

        end  % if
        % At this point, each line in the target_lines has an app command.
        disp("Checking Button block for launching app: " + target_block_path)
        for jj = 1 : numel(target_lines)
          target_command = target_lines(jj);
          if contains(target_command, "(")
            target_command = extractBefore(target_command, "(");
          end  % if
          disp("App command: " + target_command)
          target_fullpath = string( which(target_command));  % !test-target

          verifyTrue(testcase, isfile(target_fullpath))
        end  % for
      end  % for
    end  % function

  end  % methods

end  % classdef
