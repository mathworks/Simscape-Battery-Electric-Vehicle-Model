classdef uitest_EnabledButton2 < matlab.uitest.TestCase
  %% Class-based unit test for app

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

    function app_launches_without_warnings_1(testcase)
      % Warnings can be displayed even when the app opens and starts working seemingly normally.
      % Make surfe there is no warning when opening an app.
      verifyWarningFree(testcase, @() target())
      function target()
        testcase.App = testapp_EnabledButton2_1_bare_minimum;  % !test-target
      end  % nested function
    end  % function

    function app_launches_without_warnings_2(testcase)
      % Warnings can be displayed even when the app opens and starts working seemingly normally.
      % Make surfe there is no warning when opening an app.
      verifyWarningFree(testcase, @() target())
      function target()
        testcase.App = testapp_EnabledButton2_2_fit;  % !test-target
      end  % nested function
    end  % function

    function app_launches_without_warnings_3(testcase)
      % Warnings can be displayed even when the app opens and starts working seemingly normally.
      % Make surfe there is no warning when opening an app.
      verifyWarningFree(testcase, @() target())
      function target()
        testcase.App = testapp_EnabledButton2_3_horizontal_alignment;  % !test-target
      end  % nested function
    end  % function

    function app_launches_without_warnings_4(testcase)
      % Warnings can be displayed even when the app opens and starts working seemingly normally.
      % Make surfe there is no warning when opening an app.
      verifyWarningFree(testcase, @() target())
      function target()
        testcase.App = testapp_EnabledButton2_align_1;  % !test-target
      end  % nested function
    end  % function

  end  % methods

end  % classdef
