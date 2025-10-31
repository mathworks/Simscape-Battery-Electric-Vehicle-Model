classdef Button_UITest < matlab.uitest.TestCase
  %% Class implementation of UI test
  % Overview of App Testing Framework
  % - https://www.mathworks.com/help/matlab/matlab_prog/overview-of-app-testing-framework.html

  % Copyright 2024 The MathWorks, Inc.

  methods (TestMethodSetup)
    % Functions in this "TestMethodSetup" section always run before
    % each test defined in the "Test" section runs.

    function TestSetup(testcase)
      %%
      close all

      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      % This is useful, for example, to close figure windows
      % after a test which opens figure windows fails.
      addTeardown(testcase, @close_all)

      function close_all
        % Close app window
        if isstruct(testcase.App)
          % Function-based app
          close(testcase.App.Window.MainFigure)
        else
          % Class-based app
          delete(testcase.App.Window)
        end  % if

        close all
      end  % function
    end  % function

  end  % methods

  properties
    % Do not specify the class name for a property to hold a handle to an app.
    % For class-based test apps, the class name is the app name, making
    % it difficult to use a common teardown if the class name is specified here.
    App (1,1)
  end

  methods (Test)

    %% Minimum quality check (MQC)
    % MQC is to check that runnables (scripts, functions, classes, and models)
    % run right out of the box.

    function MQC_1(testcase)
      testcase.App = Button_testapp_1_bare_minimum;
    end  % function

    function MQC_1b(testcase)
      testcase.App = Button_testapp_1b_constructor_arguments;
    end  % function

    function MQC_2(testcase)
      testcase.App = Button_testapp_2_align_inside;
    end  % function

    function MQC_3(testcase)
      testcase.App = Button_testapp_3_icon;
    end  % function

    function MQC_4(testcase)
      testcase.App = Button_testapp_4_tiling;
    end  % function

    %% Gesture test

    function Gesture_1(testcase)
      % Click a button programmatically using press().
      % This tests that pressing a button does not produce any errors.
      testcase.App = Button_testapp_1_bare_minimum;
      press(testcase, testcase.App.ButtonUI.MainButton)
      press(testcase, testcase.App.ButtonUI.MainButton)
      press(testcase, testcase.App.ButtonUI.MainButton)
    end  % function

  end  % methods

end  % classdef
