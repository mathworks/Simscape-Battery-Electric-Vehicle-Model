classdef test_BEVProject < matlab.unittest.TestCase
  %% Class-based unit test
  % This is for testing files in the BEV project top folder.
  % Testing the entire project is done by the buildtool command with buildfile.m

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2021-2025 The MathWorks, Inc.

  methods (Test)
    % Functions in this "Test" section are the tests.
    % Before a function in this section runs, the TestSetup function
    % defined in the "TestMethodSetup" section runs.

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(testcase)
      % The source of the description page is a MATLAB script. Check that it runs cleanly.
      verifyWarningFree(testcase, @() test_target())
      function test_target()
        BEVProject_Description  % !test-target
      end  % nested function
    end  % function

    %% Up-to-date tests

    % -------------------------------------------------------------------------
    % Description

    function project_has_description_html(testcase)
      % Check that the project has the HTML version of the description page.
      all_project_files = [currentProject().Files.Path]';
      logical_index = endsWith(all_project_files, "BEVProject_Description.html");  % !test-target
      verifyEqual(testcase, nnz(logical_index), 1)
    end  % function

    function description_html_is_uptodate(testcase)
      % Make sure the description HTML file is up to date.

      source_fullpath = FileTool1.getFileFullPath("BEVProject_Description.m");
      destination_fullpath = FileTool1.getFileFullPath("BEVProject_Description.html");

      % This test uses a conditional branch as a special case because it is practical.
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

    % -------------------------------------------------------------------------
    % Markdown files

    function markdown_files_exist(testcase)
      % Check that Markdown files exist for all plain-text Live Script files in pwd.
      % Markdowns files are assumed to be in the markdown folder in pwd.

      % Use FileCollection to select Live Scripts.
      mfile_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(pwd, "*.m"));

      % Select Live Scripts.
      % https://www.mathworks.com/help/matlab/ref/matlab.buildtool.io.filecollection.select.html
      live_script_file_collection = select(mfile_collection, @(p) FileTool1.isPlainTextLiveScript(p));

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
      n = FileTool1.batchGenerateMarkdowns( ...
        LiveScriptFolderNames = pwd, ...
        MarkdownFolderPath = "markdown");

      if n > 0
        n = FileTool1.batchGenerateMarkdowns( ...
          LiveScriptFolderNames = pwd, ...
          MarkdownFolderPath = "markdown", DisplayInfo = true);
      end  % if

      % Add created files under the markdown folder to the project.
      addFolderIncludingChildFiles(currentProject, fullfile(pwd, "markdown"));

      verifyEqual(testcase, n, 0)

    end  % function

    %% Set up tests

    % -------------------------------------------------------------------------
    % Build Tool set up

    function check_buildfile(testcase)
      % This project has a number of the buildfile.m files.
      % Check that they are configured to save the result in the "test-result" folder.

      buildfile_pattern = fullfile(pwd, "**/buildfile.m");
      buildfile_collection = matlab.buildtool.io.FileCollection.fromPaths(buildfile_pattern);
      verifyTrue(testcase, not(isempty(buildfile_collection)))

      buildfile_paths = transpose(buildfile_collection.paths);
      num_files = numel(buildfile_paths);
      verifyTrue(testcase, num_files > 0)

      disp("Number of the buildfile.m files found: " + num_files)

      for idx = 1 : num_files
        target_buildfile = buildfile_paths(idx);
        disp(idx + ": Checking: " + target_buildfile)

        has_gitignore = isfile(".gitignore");
        verifyTrue(testcase, has_gitignore)
        buildfile_lines = readlines(target_buildfile);

        match_index = contains(buildfile_lines, """test-result/");
        num_matches = nnz(match_index);
        verifyTrue(testcase, num_matches > 0)

      end  % for
    end  % function

    % -------------------------------------------------------------------------
    % .gitignore set up

    function check_gitignore_file(testcase)
      % Check that, if git is used, git is configured to ignore the .buildtool and test-result folders.
      %
      % The Build Tool uses .buildtool folder which git must ignore.
      % The buildfile.m files in this project are configured to save results iin the test-result folder,
      % which git must ignore too.
      %
      % This test assumes that this test file, the .git folder, and the .gitignore file are
      % in the same folder.
      %
      % See the documentation about Cache Folder section in MATLAB Incremental Builds.
      % https://www.mathworks.com/help/matlab/matlab_prog/improve-performance-with-incremental-builds.html#mw_55e5581e-57fd-4abb-9b38-a3de482e713f

      if not(isfolder(".git"))
        % Skip this test if git is not used.
        disp("Git is not used in this project. Skipping this test.")
        return
      end  % if

      has_gitignore = isfile(".gitignore");
      verifyTrue(testcase, has_gitignore)

    end  % function

    function check_git_ignores_1(testcase)
      % Check that, if git is used, git is configured to ignore the .buildtool folders.
      %
      % The Build Tool uses .buildtool folder which git must ignore.
      %
      % This test assumes that this test file, the .git folder, and the .gitignore file are
      % in the same folder.
      %
      % See the documentation about Cache Folder section in MATLAB Incremental Builds.
      % https://www.mathworks.com/help/matlab/matlab_prog/improve-performance-with-incremental-builds.html#mw_55e5581e-57fd-4abb-9b38-a3de482e713f

      if not(isfolder(".git"))
        % Skip this test if git is not used.
        disp("Git is not used in this project. Skipping this test.")

        return

      end  % if
      verifyTrue(testcase, isfile(".gitignore"))
      gitignore_lines = readlines(".gitignore");

      target_pattern = lineBoundary("start") + ".buildtool" + optionalPattern("/");
      ignore = contains(gitignore_lines, target_pattern);
      verifyTrue(testcase, any(ignore))

    end  % function

    function check_git_ignores_2(testcase)
      % Check that, if git is used, git is configured to ignore the test-result folders.
      %
      % The buildfile.m files in this project are configured to save results in the test-result folder,
      % which git must ignore. The name of the folder, "test-result", is set in the buildfile.m.
      % This test assumes that "test-result" is used in all buildfile.m files in the project.

      if not(isfolder(".git"))
        % Skip this test if git is not used.
        disp("Git is not used in this project. Skipping this test.")

        return

      end  % if
      verifyTrue(testcase, isfile(".gitignore"))
      gitignore_lines = readlines(".gitignore");

      target_pattern = lineBoundary("start") + "test-result" + optionalPattern("/");
      ignore = contains(gitignore_lines, target_pattern);
      verifyTrue(testcase, any(ignore))

    end  % function

    %% Link tests

    function PassingTest_hyperlinked_command_1(~)
      % Make sure there are no broken links.
      % This test executes all the discovered MATLAB commands.

      link_table = FileTool1.getLinkedCommandFromPlainTextLiveScript("BEVProject_Description.m");

      if height(link_table) == 0
        disp("No hyperlinked MATLAB commands were found.")

        return

      end  % if

      for idx = 1 : height(link_table)
        matlab_command = link_table.Command(idx);
        disp("Hyperlinked MATLAB command: " + matlab_command)

        % !todo: Check matlab_command and decide what to do, rather than just passing it to eval.
        %
        % If matlab_command is like "openFile('Some_TestModel')",
        % maybe just check that 'Some_TestModel'exists.
        % If matlab_command is "SomeApp", maybe just check SomeApp.m exists.
        % These could be fine here because target files must be tested anyway.
        %
        % This might open a model, a script, an app, an HTML page, ...
        eval(matlab_command)

        % Close what opened to keep memory consumption low.
        % !todo: Find a way to close an app.
        close all
        bdclose all
      end  % for
    end  % function

    %% Other tests

    function test_no_MLX_files(testcase)
      % Use plain-text Live Scripts (*.m) rather than binary ones.
      file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(pwd, "**/*.mlx")).paths';
      verifyEqual(testcase, numel(file_paths), 0);
    end  % function

    function test_no_SLX_files(testcase)
      % Use plain-text model files (*.mdl) rather than binary ones.
      file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(pwd, "**/*.slx")).paths';
      verifyEqual(testcase, numel(file_paths), 0);
    end  % function

  end  % methods

end  % classdef
