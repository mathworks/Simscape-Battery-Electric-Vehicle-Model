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

    %% Button callback settings

    function Button_callback_edit_1(testcase)
      % Find Button blocks in the specified model and check if the callback uses the edit command:
      %   edit("target_file")
      % If yes, check that the target_file exists.
      %
      % Also check that there is only one edit command in one callback.

      model_name = "BEV_system_model";
      target_command = "edit";

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

    %% Link tests

    function LinkTest_1(testcase)
      % Check all the Callback Button blocks in a model.
      % Different tests are done depending on the name of the block.
      % - "Plot ..." makes a visualization/plot using some block parameters.
      % - "Open ... app" opens an app.
      % - "Open ... script" opens the script in the Editor.
      % - Something else, which is assumed to be in a script call style, not in a function call style.
      %
      % Get the ClickFcn property of the Callback Button block and validate it.
      % ClickFcn should call one main action, optionally with the disp command, comment lines, or empty lines.

      model_name = "BEV_system_model";

      load_system(model_name)

      block_paths = string(getfullname(Simulink.findBlocksOfType(model_name, "CustomCallbackButton")));

      num_blocks = numel(block_paths);
      for idx = 1 : num_blocks
        target_block_path = block_paths(idx);

        disp("Found a Custom Callback Button: " + target_block_path)

        [system_path, block_name, ~] = fileparts(target_block_path);

        find_options = Simulink.FindOptions(SearchDepth = 1);
        all_found_blocks = string(getfullname(Simulink.findBlocks(system_path, find_options)));

        ClickFcn_text = string(get_param(target_block_path, "ClickFcn"));

        lines = splitlines(ClickFcn_text);

        if height(lines) > 1
          % Remove comment lines.
          logical_index = not(startsWith(lines, "%"));
          lines = lines(logical_index);

          % Remove empty lines.
          logical_index = not(lines == "");
          lines = lines(logical_index);

          % Remove lines containing the disp command.
          % This assumes that the target text is not in the same line as disp.
          logical_index = not(contains(lines, "disp("));
          lines = lines(logical_index);
        end  % if

        if height(lines) > 1
          % Skip testing if there are 2 or more lines remaining at this point.
          % !todo: Test the callback code even when it has 2 or more lines.

          continue

        end  % if

        target_line = lines;
        disp("Target: " + target_line)

        if startsWith(block_name, "Plot")
          % Plot button.
          %
          % The text lines must be in the following style.
          %   plotFunction(gcs + "/Target block")
          %
          % Check the plotFunction and the target block.

          % Use which to get the full path to the plot function.
          target_function_name = extractBefore(target_line, "(");
          disp("Plot: " + target_function_name)
          target_function_fullpath = string(which(target_function_name));  % !test-target
          verifyTrue(testcase, target_function_fullpath ~= "")

          % Get
          %   /Target block
          % from
          %   (gcs + "/Target block", ...)
          sp = optionalPattern(whitespacePattern);
          extracted_block_name = extractBetween(target_line, "("+sp+"gcs"+sp+"+"+sp+"""", """"+optionalPattern(sp+","+wildcardPattern("Except",""""))+sp+")");
          % Construct a full block path and check it.
          constructed_block_path = system_path + extracted_block_name;
          logical_index = constructed_block_path == all_found_blocks;  % !test-target
          verifyEqual(testcase, nnz(logical_index), 1)

        elseif startsWith(block_name, "Open") && endsWith(block_name, whitespacePattern+("A"|"a")+"pp")
          % App button.
          %
          % The text lines must be in the following style.
          %   SomeApp
          % or
          %   SomeApp(gcs + "/Target block")
          %
          % Check the SomeApp and the target block.
          % - The app name must end with "App".

          verifyTrue(testcase, contains(target_line, "App" + alphanumericBoundary))

          if contains(target_line, "App(")
            target_app_name = extractBefore(target_line, "(");
          else
            target_app_name = target_line;
          end  % if
          disp("App: " + target_app_name)

          % Use which to get the full path to the plot function.
          target_app_fullpath = string(which(target_app_name));  % !test-target
          verifyTrue(testcase, target_app_fullpath ~= "")

          if contains(target_line, "App(")
            % Get
            %   /Target block
            % from
            %   (gcs + "/Target block", ...)
            sp = optionalPattern(whitespacePattern);
            extracted_block_name = extractBetween(target_line, "("+sp+"gcs"+sp+"+"+sp+"""", """"+optionalPattern(sp+","+wildcardPattern("Except",""""))+sp+")");
            % Construct a full block path and check it.
            constructed_block_path = system_path + extracted_block_name;
            logical_index = constructed_block_path == all_found_blocks;  % !test-target
            verifyEqual(testcase, nnz(logical_index), 1)
          end  % if

        elseif startsWith(block_name, "Open") && endsWith(block_name, whitespacePattern+("S"|"s")+"cript")
          % Open a script in the Editor.
          %   edit("script_name")
          %
          % Check that the script_name exists.

          verifyTrue(testcase, startsWith(target_line, "edit("))

          sp = optionalPattern(whitespacePattern);
          script_name = extractBetween(target_line, "("+sp+"""", """"+sp+")");
          disp("Script: " + script_name)

          target_fullpath = string(which(script_name));  % !test-target
          verifyTrue(testcase, target_fullpath ~= "")

        else
          disp("Not plot, not app, not edit.")
          % Assume that the target text is in a script style, not a function style.
          target_fullpath = string(which(target_line));  % !test-target
          verifyTrue(testcase, target_fullpath ~= "")

        end  % if
      end  % for
    end  % function

  end  % methods

end  % classdef
