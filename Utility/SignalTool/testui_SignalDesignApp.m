classdef testui_SignalDesignApp < matlab.uitest.TestCase
  %% Class implementation of UI test
  % Overview of App Testing Framework
  % https://www.mathworks.com/help/matlab/matlab_prog/overview-of-app-testing-framework.html
  %
  % Table of Verifications, Assertions, and Other Qualifications
  % https://www.mathworks.com/help/matlab/matlab_prog/types-of-qualifications.html

  % Overview of App Testing Framework
  % https://www.mathworks.com/help/matlab/matlab_prog/overview-of-app-testing-framework.html

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
      close all
      bdclose all

      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @close_all)

      function close_all
        close all
        bdclose all

        % Delete the app's figure object from memory.
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
      end  % nested function
    end  % function

  end  % methods

  methods (Test)
    % Functions in the Test section are the tests.
    % Before a function in this section runs, the functions defined in the TestMethodSetup section run.

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(testcase)
      verifyWarningFree(testcase, @() target())
      function target()
        testcase.App = SignalDesignApp;  % !test-target
      end  % nested function
    end  % function

    %% UI test

    function uitest_1(testcase)
      testcase.App = SignalDesignApp;
      % Plot must update when a new value is typed in.
      type(testcase, testcase.App.MatrixTextUI.MainTextArea, "[0 2 10; 4 6 2; 8 12 6]")
    end  % function

    %% Up-to-date tests

    function app_screenshot_is_uptodate(testcase)

      source_fullpath = FileTool1.getFileFullPath("SignalDesignApp.m");
      destination_fullpath = FileTool1.getFileFullPath("screenshot-SignalDesignApp.png");

      newer = FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      if newer
        % Display the time stamps.
        FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath, DisplayInfo=true);

        testcase.App = SignalDesignApp;

        % Take screenshot
        disp("Update screenshot")
        exportapp(testcase.App.Window.MainFigure, destination_fullpath)

      else
        % The closeAll function checks class(testcase.App) ~= "double"
        % when finishing the execution of a test.
        testcase.App = 0;
      end  % if

      newer = FileTool1.sourceFileIsNewer(Source=source_fullpath, Destination=destination_fullpath);
      verifyFalse(testcase, newer)

    end  % function

  end  % methods

end  % classdef
