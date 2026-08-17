classdef unittest_BEVProject_settings < matlab.unittest.TestCase
  % Class-based unit test
  %
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

  % Copyright 2021-2026 The MathWorks, Inc.

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

    % -------------------------------------------------------------------------
    % Project's initial Live Script

    function project_initial_live_script(testcase)
      %%
      target_file = "BEVProject_Description.m";

      % Make sure that the target file is not open. Close it if it is.
      docs_in_editor = matlab.desktop.editor.getAll;
      logical_index = endsWith(string({docs_in_editor.Filename}'), target_file);
      if nnz(logical_index) == 1
        close(docs_in_editor(logical_index))
      end  % if
      verifyTrue(testcase, nnz(logical_index) == 0)

      % This must open the intended Live Script in the Editor.
      bevutil1.ProjectUtil.openInProject(target_file)  % !test-target

      % Find the target Live Script in the Editor and close it.
      docs_in_editor = matlab.desktop.editor.getAll;
      logical_index = endsWith(string({docs_in_editor.Filename}'), target_file);
      verifyTrue(testcase, nnz(logical_index) == 1)
      close(docs_in_editor(logical_index))
    end  % function

    % -------------------------------------------------------------------------
    % Project description

    function project_description_linked_commands(~)
      %%
      % Make sure that the linked MATLAB commands in the project description file are valid.

      % Use the full path to the target file because unit test may change working folder.
      target_fullpath = bevutil1.FileUtil.getFileFullPath("BEVProject_Description.m");

      linktable = bevutil1.FileUtil.getLinkedCommandFromPlainTextLiveScript(target_fullpath);
      if height(linktable) == 0

        return

      end  % if
      for k = 1 : height(linktable)
        target_command = linktable.Command(k);
        disp("Evaluating linked command: " + target_command)

        % The linked MATLAB command can open an app, a figure, a model, or whatever.
        eval(target_command)

        % Close apps, figures, and models.
        figs = findall(0, Type="Figure");
        if not(any(isempty(figs)))
          delete(figs)
        end  % if
        close all
        bdclose all
      end  % for
    end  % function

    % -------------------------------------------------------------------------
    % Project startup

    function project_startup(testcase)
      % Make sure that the project startup is configured exactly as this test checks.

      files = [currentProject().StartupFiles]';

      % There are 2 files configured for the startup.
      verifyEqual(testcase, numel(files), 2)

      % These are the two files.
      verifyEqual(testcase, nnz(endsWith(files, "atProjectStartUp.m")), 1)
      verifyEqual(testcase, nnz(endsWith(files, "BEVProject_Description.html")), 1)
    end  % function

    % -------------------------------------------------------------------------
    % Set up

    function code_analyzer_setup(testcase)
      % Check the validity of codeAnalyzerConfiguration.json.
      % For a MATLAB project, the configuration file must be in the following path.
      target_fullpath = fullfile(currentProject().RootFolder, "resources", "codeAnalyzerConfiguration.json");
      verifyTrue(testcase, isfile(target_fullpath))
      matlab.codeanalysis.refreshConfiguration
      issues = matlab.codeanalysis.validateConfiguration(target_fullpath);
      verifyTrue(testcase, isempty(issues))
    end  % function

    function check_gitignore_file(testcase)
      % Check that, if git is used, git is configured to ignore the .buildtool and test-result folders.
      %
      % The Build Tool uses .buildtool folder which git must ignore.
      % The buildfile.m files in this project are configured to save results in the test-result folder,
      % which git must ignore too.
      %
      % This test assumes that this test file, the .git folder, and the .gitignore file are
      % in the same folder.
      %
      % See the documentation about Cache Folder section in MATLAB Incremental Builds.
      % https://www.mathworks.com/help/matlab/matlab_prog/improve-performance-with-incremental-builds.html#mw_55e5581e-57fd-4abb-9b38-a3de482e713f

      top_folder = currentProject().RootFolder;

      if isfile(fullfile(top_folder, ".git"))
        % Assume this is a Git worktree.
        disp("This repo seems to be a Git worktree. Skipping this test.")

        return

      elseif not(isfolder(fullfile(top_folder, ".git")))
        % .git is not a file nor a folder.

        verifyFail("Git must be used.")

      end  % if

      has_gitignore = isfile(fullfile(top_folder,".gitignore"));
      verifyTrue(testcase, has_gitignore)

      gitignore_lines = readlines(fullfile(top_folder,".gitignore"));

      target_pattern = lineBoundary("start") + ".buildtool" + optionalPattern("/");
      ignore = contains(gitignore_lines, target_pattern);
      verifyTrue(testcase, any(ignore))

      target_pattern = lineBoundary("start") + "test-result" + optionalPattern("/");
      ignore = contains(gitignore_lines, target_pattern);
      verifyTrue(testcase, any(ignore))

    end  % function

    % -------------------------------------------------------------------------
    % Project

    function project_shortcuts(testcase)
      % Check that the project shortcuts are linked to existing files.

      project_shortcuts = currentProject().Shortcuts;

      project_shortcut_files = [project_shortcuts.File]';

      if numel(project_shortcut_files) == 0
        disp("No project shortcuts were found.")

        return

      end  % if

      disp("Project shortcuts were found: " + numel(project_shortcuts))

      verifyTrue(testcase, all(isfile(project_shortcut_files)))

    end  % function

    % -------------------------------------------------------------------------
    % Check specific file types

    function no_untitled_files(testcase)
      top_folder = currentProject().RootFolder;
      file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(top_folder, "**/untitled*")).paths';
      verifyEqual(testcase, numel(file_paths), 0);
    end  % function

    function no_Copy_of_files(testcase)
      top_folder = currentProject().RootFolder;
      file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(top_folder, "**/Copy_of*")).paths';
      verifyEqual(testcase, numel(file_paths), 0);
    end  % function

    function no_MLX_files(testcase)
      % Use plain-text live script files (*.m) rather than binary ones.
      top_folder = currentProject().RootFolder;
      file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(top_folder, "**/*.mlx")).paths';
      verifyEqual(testcase, numel(file_paths), 0);
    end  % function

    function no_SLX_files(testcase)
      % Use plain-text model files (*.mdl) rather than binary ones.
      top_folder = currentProject().RootFolder;
      file_paths = matlab.buildtool.io.FileCollection.fromPaths(fullfile(top_folder, "**/*.slx")).paths';
      verifyEqual(testcase, numel(file_paths), 0);
    end  % function

  end  % methods
end  % classdef
