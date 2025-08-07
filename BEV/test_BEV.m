classdef test_BEV < matlab.unittest.TestCase
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
      BEV_setup
    end  % function

    function PassingTest_2(~)
      load_system("BEV_system_model");
    end  % function

    function PassingTest_3(~)
      sim("BEV_system_model");
    end  % function

    function PassingTest_4(~)
      evalin("base", "BEV_main_script");
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

        % There must be only one line after removing optional lines.
        verifyTrue(testcase, height(lines) == 1)

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

    %% Up-to-date tests

    function html_is_uptodate(testcase)
      % Make sure the main script HTML file is up to date.

      source_fullpath = FileTool2.getFileFullPath("BEV_main_script.m");
      destination_fullpath = FileTool2.getFileFullPath("BEV_main_script.html");

      % This test uses a conditional branch as a special case because it is practical.
      newer = FileTool2.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if newer
        % The export command saves the generated file in the current working folder (pwd).
        % When this test runs, pwd is the folder where this test code file exists.
        actual_path = string(export(source_fullpath, Run=true, Format="html", HideCode=true));
        expected_path = destination_fullpath;
        verifyEqual(testcase, actual_path, expected_path)
      end  % if

      newer = FileTool2.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath, DisplayInfo=true);
      verifyFalse(testcase, newer)
    end  % function

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

    function model_screenshot_is_uptodate(testcase)
      model_name = "BEV_system_model";
      image_filename = "screenshot-BEV_system_model.png";

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

  end  % methods

end  % classdef
