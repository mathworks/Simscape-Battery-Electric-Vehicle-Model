classdef uiUptodateTest_BEVProject < matlab.uitest.TestCase
  % Class-based unit test for app
  % This uitest class is the App.m file.
  % There is another uitest class for the AppMain.m file and the related files.

  % Overview of App Testing Framework
  % https://www.mathworks.com/help/matlab/matlab_prog/overview-of-app-testing-framework.html
  %
  % Table of Verifications, Assertions, and Other Qualifications
  % https://www.mathworks.com/help/matlab/matlab_prog/types-of-qualifications.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2024-2026 The MathWorks, Inc.

  properties
    % Some of the tests in this test class run only if test is running locally under the LocalTopFolder.
    LocalTopFolder (1,1) pattern = "C:\local"
  end  % properties

  methods (TestMethodSetup)
    % Functions in this "TestMethodSetup" section always run before
    % each test defined in the "Test" section runs.

    function test_method_setup_1(testcase)
      %%
      % Close all before test
      close all
      bdclose all

      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @closeAllAfterTest)
      function closeAllAfterTest
        % Close all figure windows. This closes not only the test targets but also other figure windows.
        figs = findall(0, Type="Figure");
        if not(any(isempty(figs)))
          disp("Deleting figures (" + numel(figs) + ")")
          delete(figs)
        end  % if
        bdclose all
      end  % nested function
    end  % function

  end  % methods

  methods (Test)
    % Functions in the Test section are the tests.
    % Before a function in this section runs, the functions defined in the TestMethodSetup section run.

    function app_screenshot_1_dark(testcase)
      %%
      if bev1mus.TestUtil.isR2024bOrOlder || bev1mus.TestUtil.isNonLocal(testcase.LocalTopFolder)
        disp("!Skipping")

        return

      end  % if
      % R2025a or newer

      top_folder = currentProject().RootFolder;

      target_app = @BEVProjectNavigationApp;

      source_fullpath = fullfile(top_folder, "BEVProjectNavigationApp.m");
      verifyTrue(testcase, isfile(source_fullpath))

      destination_fullpath = fullfile(top_folder, "BEVProjectUtility", "screenshot-BEVProjectNavigationApp-dark.png");

      if isfile(destination_fullpath)
        needs_update = bev1mus.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      else
        needs_update = true;
      end  % if

      if needs_update
        disp("Taking screenshot: " + source_fullpath)
        app = target_app();  % !screenshot-target
        app.MainFigure.Theme = "dark";
        drawnow
        exportapp(app.MainFigure, destination_fullpath)
        disp("Saved: " + destination_fullpath)
      else
        disp("Screenshot is up to date.")
      end  % if

      destination_is_newer = not(bev1mus.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath));
      verifyTrue(testcase, destination_is_newer)
    end  % function

    function app_screenshot_1_light(testcase)
      %%
      if bev1mus.TestUtil.isNonLocal(testcase.LocalTopFolder)
        disp("!Skipping")

        return

      end  %if

      top_folder = currentProject().RootFolder;

      target_app = @BEVProjectNavigationApp;

      source_fullpath = fullfile(top_folder, "BEVProjectNavigationApp.m");
      verifyTrue(testcase, isfile(source_fullpath))

      destination_fullpath = fullfile(top_folder, "BEVProjectUtility", "screenshot-BEVProjectNavigationApp-light.png");

      if isfile(destination_fullpath)
        needs_update = bev1mus.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      else
        needs_update = true;
      end  % if

      if needs_update
        disp("Taking screenshot: " + source_fullpath)
        app = target_app();  % !screenshot-target
        app.MainFigure.Theme = "light";
        drawnow
        exportapp(app.MainFigure, destination_fullpath)
        disp("Saved: " + destination_fullpath)
      else
        disp("Screenshot is up to date.")
      end  % if

      destination_is_newer = not(bev1mus.FileUtil.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath));
      verifyTrue(testcase, destination_is_newer)

    end  % function

  end  % methods
end  % classdef
