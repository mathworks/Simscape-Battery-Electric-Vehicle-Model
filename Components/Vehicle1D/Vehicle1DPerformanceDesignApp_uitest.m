classdef Vehicle1DPerformanceDesignApp_uitest < matlab.uitest.TestCase
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

    %% Minimum quality check (MQC)
    % Check that models, scripts, functions, and classes run right out of the box.

    function MQC_App_1(testcase)
      verifyWarningFree(testcase, @() target())
      function target()
        testcase.App = Vehicle1DPerformanceDesignApp;  % !test-target
      end  % nested function
    end  % function

    %% UI test
    % Vehicle1DPerformanceDesignApp is tested here for a few simple test cases because
    % Vehicle1DPerformanceDesignAppMain is tested elsewhere more exstensively.

    function uitest_EditField_Mass(testcase)
      testcase.App = Vehicle1DPerformanceDesignApp;
      % Plot must update when a new value is typed in.
      type(testcase, testcase.App.VehicleMassUI.ValueEditFieldUI.MainEditField, "1000")
    end  % function

    function uitest_Preset(testcase)
      testcase.App = Vehicle1DPerformanceDesignApp;
      % Plot must update as a new preset is selected.
      choose(testcase, testcase.App.PresetUI.MainListBox, 1)
      choose(testcase, testcase.App.PresetUI.MainListBox, 2)
      choose(testcase, testcase.App.PresetUI.MainListBox, 3)
    end  % function

  end  % methods

end  % classdef
