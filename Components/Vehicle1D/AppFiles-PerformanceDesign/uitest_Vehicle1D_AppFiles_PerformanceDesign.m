classdef uitest_Vehicle1D_AppFiles_PerformanceDesign < matlab.uitest.TestCase
  %% Class-based unit test for app
  % This uitest class is for the AppMain.m file and the related files.
  % There is another uitest class for the App.m file.

  % Overview of App Testing Framework
  % https://www.mathworks.com/help/matlab/matlab_prog/overview-of-app-testing-framework.html
  %
  % Table of Verifications, Assertions, and Other Qualifications
  % https://www.mathworks.com/help/matlab/matlab_prog/types-of-qualifications.html

  % Copyright 2024-2025 The MathWorks, Inc.

  properties

    ModelName (1,1) string = "Vehicle1DPerformance_model_for_test"

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

    function PassingTest_1(testcase)
      % Warnings can be displayed even when the app opens and starts working seemingly normally.
      % Make surfe there is no warning when opening an app.
      verifyWarningFree(testcase, @() target())
      function target()
        testcase.App = Vehicle1DPerformanceDesignAppMain;  % !test-target
      end  % nested function
    end  % function

    %% Test options for app functions

    function test_option_BlockPath_1(testcase)
      verifyWarningFree(testcase, @() target())
      function target()
        testcase.App = Vehicle1DPerformanceDesignAppMain(BlockPath=testcase.ModelName+"/Longitudinal Vehicle 1");
        % !todo: validate something in the app to make sure that the specified block is really loaded.
      end  % nested function
    end  % function

    function test_option_BlockPath_2(testcase)
      verifyWarningFree(testcase, @() target())
      function target()
        testcase.App = Vehicle1DPerformanceDesignAppMain(BlockPath=testcase.ModelName+"/Longitudinal Vehicle 2");
        % !todo: validate something in the app to make sure that the specified block is really loaded.
      end  % nested function
    end  % function

    function test_option_BlockPath_warning_1(testcase)
      verifyWarning(testcase, @() target(), "Vehicle1DPerformanceDesignAppMain:ErrorInGetParametersFromBlock")
      function target()
        testcase.App = Vehicle1DPerformanceDesignAppMain(BlockPath="Vehicle1DPerformance_model_for_test/Longitudinal (road-load)");
      end  % nested function
    end  % function

    %% UI test

    function uitest_EditField_Mass(testcase)
      testcase.App = Vehicle1DPerformanceDesignAppMain;
      % Plot must update when a new value is typed in.
      type(testcase, testcase.App.VehicleMassUI.ValueEditFieldUI.MainEditField, "1000")
    end  % function

    function uitest_Preset(testcase)
      testcase.App = Vehicle1DPerformanceDesignAppMain;
      % Plot must update as a new preset is selected.
      choose(testcase, testcase.App.PresetUI.MainListBox, 1)
      choose(testcase, testcase.App.PresetUI.MainListBox, 2)
      choose(testcase, testcase.App.PresetUI.MainListBox, 3)
    end  % function

    function uitest_OpenFigure(testcase)
      testcase.App = Vehicle1DPerformanceDesignAppMain;
      % A new figure window must open when the link is clicked.
      press(testcase, testcase.App.OpenFigureWindowUI.MainHyperlink)
    end  % function

    function uitest_UpdateButton(testcase)
      testcase.App = Vehicle1DPerformanceDesignAppMain;
      % Select the final item in the preset.
      choose(testcase, testcase.App.PresetUI.MainListBox, testcase.App.PresetUI.MainListBox.Items(end))
      % Update a base workspace variable which is used in the app.
      str = "Vehicle.Mass = simscape.Value(1000, ""kg"");";
      evalin("base", str);
      disp("Evaluate in base workspace:" + newline + str)
      % Use a base workspace variable.
      type(testcase, testcase.App.VehicleMassUI.ValueEditFieldUI.MainEditField, "Vehicle.Mass")
      % Click the Update button.
      % This must update the plot.
      press(testcase, testcase.App.UpdateButtonUI.MainButton)
      evalin("base", "clear Vehicle");
    end  % function

  end  % methods

end  % classdef
