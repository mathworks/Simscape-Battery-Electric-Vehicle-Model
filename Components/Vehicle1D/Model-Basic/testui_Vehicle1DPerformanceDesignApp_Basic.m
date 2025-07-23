classdef testui_Vehicle1DPerformanceDesignApp_Basic < matlab.uitest.TestCase
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
        testcase.App = Vehicle1DPerformanceDesignApp_Basic;  % !test-target
      end  % nested function
    end  % function

    %% Other tests

    function test_vehicle_mass(testcase)
      % Check that the parameter values are loaded as expected.
      testcase.App = Vehicle1DPerformanceDesignApp_Basic;
      sscval = testcase.App.VehicleMassUI.SimscapeValue;
      expected = value(sscval, "kg");
      actual = 2400;
      verifyEqual(testcase, expected, actual)
    end  % function

    function test_frontal_area(testcase)
      % Check that the parameter values are loaded as expected.
      testcase.App = Vehicle1DPerformanceDesignApp_Basic;
      sscval = testcase.App.FrontalAreaUI.SimscapeValue;
      expected = value(sscval, "m^2");
      actual = 0.9 * 1.921 * 1.624;
      verifyEqual(testcase, expected, actual, RelTol=0.01)
    end  % function

  end  % methods

end  % classdef
