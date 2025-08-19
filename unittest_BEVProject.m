classdef unittest_BEVProject < matlab.unittest.TestCase
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

    %% Set up

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

    %% Links

    function project_shortcuts(testcase)
      % Check that the project shortcuts are linked to existing files.

      project_shortcut_files = [currentProject().Shortcuts.File]';

      if numel(project_shortcut_files) == 0

        return

      end  % if

      verifyTrue(testcase, all(isfile(project_shortcut_files)))

    end  % function

    function linked_commands_in_live_script_1(testcase)
      % Live scripts can have hyperlinks that are MATLAB commands.
      % An example is "command" in the text "[some text](matlab:command)"
      % where "some text" is rendered with a hyperlink "command" which
      % is passed to MATLAB when the link is clicked.
      %
      % This test makes sure there are no broken links.

      link_table = FileTool2.getLinkedCommandFromPlainTextLiveScript("BEVProject_Description.m");

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

    %% Other tests

    function no_untitled_files(testcase)
      file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(pwd, "**/untitled.*")).paths';
      verifyEqual(testcase, numel(file_paths), 0);
    end  % function

    function no_Copy_of_files(testcase)
      file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(pwd, "**/Copy_of_*")).paths';
      verifyEqual(testcase, numel(file_paths), 0);
    end  % function

    function no_MLX_files(testcase)
      % Use plain-text Live Scripts (*.m) rather than binary ones.
      file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(pwd, "**/*.mlx")).paths';
      verifyEqual(testcase, numel(file_paths), 0);
    end  % function

    function no_SLX_files(testcase)
      % Use plain-text model files (*.mdl) rather than binary ones.
      file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(pwd, "**/*.slx")).paths';
      verifyEqual(testcase, numel(file_paths), 0);
    end  % function

  end  % methods

end  % classdef
