classdef testui_BEVProjectNavigationApp < matlab.uitest.TestCase
  %% Class-based unit test for app
  % This uitest class is the App.m file.
  % There is another uitest class for the AppMain.m file and the related files.

  % Overview of App Testing Framework
  % https://www.mathworks.com/help/matlab/matlab_prog/overview-of-app-testing-framework.html
  %
  % Table of Verifications, Assertions, and Other Qualifications
  % https://www.mathworks.com/help/matlab/matlab_prog/types-of-qualifications.html

  % Copyright 2024-2025 The MathWorks, Inc.

  properties

    % Do not specify the class name for a property to hold a handle to an app.
    % For class-based test apps, the class name is the app name, making
    % it difficult to use a common teardown if the class name is specified here.
    App (1,1)

  end  % properties

  methods (TestMethodSetup)
    % Functions in the TestMethodSetup section always run before
    % each test defined in the Test section runs.

    function test_method_setup(testcase)
      %%
      function closeAll
        % Delete the app's figure object from memory.
        if class(testcase.App) ~= "double"
          if isstruct(testcase.App)
            % Function-based app
            if not(isfield(testcase.App, "Window"))
              % There is no window to close.

              return

            end  % if
            % App.Window is a struct field which does not trigger destructor.
            % Delete the figure directly.
            delete(testcase.App.Window.MainFigure)
          else
            % Class-based app
            % App.Window's destructor deletes the figure.
            delete(testcase.App.Window)
          end  % if
        end  % if
        close all
        bdclose all
      end  % nested function

      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @closeAll)

      close all
      bdclose all
    end  % function

  end  % methods

  methods (Test)
    % Functions in the Test section are the tests.
    % Before a function in this section runs, the functions defined in the TestMethodSetup section run.

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function WarningFreeTest_1(testcase)
      % Warnings can be displayed even when the app opens and starts working seemingly normally.
      % Make surfe there is no warning when opening an app.
      verifyWarningFree(testcase, @() target())
      function target()
        testcase.App = BEVProjectNavigationApp;  % !test-target
      end  % nested function
    end  % function

    %% Up-to-date test

    function app_screenshot_is_uptodate(testcase)

      target_app = @BEVProjectNavigationApp;

      % This test class is for App.m, not for AppMain.m, but in this particular test function,
      % use AppMain.m instead of App.m as the source for comparison.
      source_fullpath = FileTool2.getFileFullPath("BEVProjectNavigationAppMain.m");

      destination_fullpath = FileTool2.getFileFullPath("screenshot-BEVProjectNavigationApp.png");

      newer = FileTool2.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if newer
        % Display the time stamps.
        FileTool2.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath, DisplayInfo=true);

        testcase.App = target_app();

        % Take screenshot
        disp("Update screenshot")
        exportapp(testcase.App.Window.MainFigure, destination_fullpath)

      else
        % The closeAll function checks class(testcase.App) ~= "double"
        % when finishing the execution of a test.
        testcase.App = 0;
      end  % if

      newer = FileTool2.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      verifyFalse(testcase, newer)

    end  % function

  end  % methods

end  % classdef
