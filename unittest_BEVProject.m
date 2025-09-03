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

    %% Project startup

    function project_startup(testcase)
      % Make sure that the project startup is configured exactly as this test checks.

      files = [currentProject().StartupFiles]';

      % There are 2 files configured for the startup.
      verifyEqual(testcase, numel(files), 2)

      % These are the two files.
      verifyEqual(testcase, nnz(endsWith(files, "atProjectStartUp.m")), 1)
      verifyEqual(testcase, nnz(endsWith(files, "BEVProject_Description.html")), 1)
    end  % function

    %% Set up

    % -------------------------------------------------------------------------
    % Build Tool set up

    function code_analyzer_setup(testcase)
      % Check the validity of codeAnalyzerConfiguration.json.
      % For a MATLAB project, the configuration file must be in the following path.
      target_fullpath = fullfile(currentProject().RootFolder, "resources", "codeAnalyzerConfiguration.json");
      verifyTrue(testcase, isfile(target_fullpath))
      matlab.codeanalysis.refreshConfiguration
      issues = matlab.codeanalysis.validateConfiguration(target_fullpath);
      verifyTrue(testcase, isempty(issues))
    end  % function

    % -------------------------------------------------------------------------
    % Build Tool set up

    function check_buildfile_result_save_location(testcase)
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

    %% Project

    function project_shortcuts(testcase)
      % Check that the project shortcuts are linked to existing files.

      project_shortcut_files = [currentProject().Shortcuts.File]';

      if numel(project_shortcut_files) == 0

        return

      end  % if

      verifyTrue(testcase, all(isfile(project_shortcut_files)))

    end  % function

    %% Hyperlinks in Live Scripts

    function LinkedCommandTypes_in_LiveScript(testcase)
      % Check if there are hyperlinks in a Live Script that are MATLAB commands,
      % and if yes, check that the commands are expected commands.
      target_file = "BEVProject_Description.m";
      link_table = FileTool3.getLinkedCommandFromPlainTextLiveScript(target_file);
      if height(link_table) == 0
        disp("No hyperlinked MATLAB commands were found: " + target_file)

        return

      end  % if
      commands = link_table.Command;
      % Commands must be either openInProject or an app.
      verifyTrue(testcase, all(startsWith(commands, "openInProject(") | endsWith(commands, "App")))
    end  % function

    function openInProject_in_links_in_LiveScript(testcase)
      % Check that files passed to the openInProject command in hyperlinks in
      % plain-text Live Scripts exist.
      % This test assumes that the argument to the openInProject is a simple word
      % representing a MATLAB code file or a Simulink model file.
      % For example, "hello" in openInProject("hello") should be one of
      % "hello.m", "hello.mlx", "hello.mdl", or "hello.slx".
      target_file = "BEVProject_Description.m";
      link_table = FileTool3.getLinkedCommandFromPlainTextLiveScript(target_file);
      if height(link_table) == 0
        disp("No hyperlinked MATLAB commands were found: " + target_file)

        return

      end  % if
      commands = link_table.Command;
      logical_index = startsWith(commands, "openInProject(");
      if nnz(logical_index) == 0
        disp("No openInProject commands were found: " + target_file)

        return

      end  % if
      commands = commands(logical_index);
      for ii = 1 : numel(commands)
        matlab_command = commands(ii);
        disp("Checking argument: " + matlab_command)
        main_target = extractBetween(matlab_command, "("+("'"|""""), ("'"|"""")+")");
        fullpath = string( which(main_target));

        verifyTrue(testcase, isfile(fullpath))

      end  % for
    end  % function

    function Apps_in_links_in_LiveScript(testcase)
      % Check that apps that are hyperlinked in a live script exist.
      % This test assumes that the app name ends with "App".
      % This test checks that the app file exists.
      % This test does not open the app.
      target_file = "BEVProject_Description.m";
      link_table = FileTool3.getLinkedCommandFromPlainTextLiveScript(target_file);
      if height(link_table) == 0
        disp("No hyperlinked MATLAB commands were found: " + target_file)

        return

      end  % if
      commands = link_table.Command;
      logical_index = endsWith(commands, "App");
      if nnz(logical_index) == 0
        disp("No apps were found: " + target_file)

        return

      end  % if
      commands = commands(logical_index);
      for ii = 1 : numel(commands)
        matlab_command = commands(ii);
        disp("Checking app exists: " + matlab_command)
        app_fullpath = string( which(matlab_command));

        verifyTrue(testcase, isfile(app_fullpath))

      end  % for
    end  % function

    %% Model release

    function model_saved_release(testcase)
      % Check that models are saved in the current MATLAB release.
      N = ModelTool2.saveModels( DryRun=true, Target="Project", DisplayInfo=false );
      verifyEqual(testcase, N, 0)
    end  % function

    %% Other tests

    function no_untitled_files(testcase)
      topfolder = currentProject().RootFolder;
      file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(topfolder, "**/untitled.*")).paths';
      verifyEqual(testcase, numel(file_paths), 0);
    end  % function

    function no_Copy_of_files(testcase)
      topfolder = currentProject().RootFolder;
      file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(topfolder, "**/Copy_of_*")).paths';
      verifyEqual(testcase, numel(file_paths), 0);
    end  % function

    function no_MLX_files(testcase)
      % Use plain-text Live Scripts (*.m) rather than binary ones.
      topfolder = currentProject().RootFolder;
      file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(topfolder, "**/*.mlx")).paths';
      verifyEqual(testcase, numel(file_paths), 0);
    end  % function

    function no_SLX_files(testcase)
      % Use plain-text model files (*.mdl) rather than binary ones.
      topfolder = currentProject().RootFolder;
      file_paths_1 = matlab.buildtool.io.FileCollection.fromPaths(fullfile(topfolder, "BEV", "**/*.slx")).paths';
      file_paths_2 = matlab.buildtool.io.FileCollection.fromPaths(fullfile(topfolder, "Component", "**/*.slx")).paths';
      all_file_paths = [file_paths_1; file_paths_2];
      verifyEqual(testcase, numel(all_file_paths), 0);
    end  % function

  end  % methods

end  % classdef
