classdef CheckBox_UITest < matlab.uitest.TestCase
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
      % The app window may not appear in the screen.
      testcase.App = apptest_CheckBox_1_simplest;
    end  % function

    function MQC_2(testcase)
      % The app window may not appear in the screen.
      testcase.App = apptest_CheckBox_2a_align_inside;
    end  % function

    function MQC_3(testcase)
      % The app window may not appear in the screen.
      testcase.App = apptest_CheckBox_2_align_inside;
    end  % function

    function MQC_4(testcase)
      % The app window may not appear in the screen.
      testcase.App = apptest_CheckBox_3_tiling;
    end  % function

    %% Gesture test

    function Gesture_1(testcase)
      % Click check box programmatically using press().
      % This tests that pressing a check box does not produce any errors.
      testcase.App = apptest_CheckBox_2a_align_inside;
      t = 0.4;
      pause(t)

  	  % Check box 1
      v1 = testcase.App.CheckBox_1.Value;
      press(testcase, testcase.App.CheckBox_1.MainCheckBox)
      pause(t)
      press(testcase, testcase.App.CheckBox_1.MainCheckBox)
      v2 = testcase.App.CheckBox_1.Value;
      assert(v1 == v2)
      pause(t)

  	  % Check box 2
      press(testcase, testcase.App.CheckBox_2.MainCheckBox)
      pause(t)
      press(testcase, testcase.App.CheckBox_2.MainCheckBox)
      pause(t)

  	  % Check box 3
      press(testcase, testcase.App.CheckBox_3.MainCheckBox)
      pause(t)
      press(testcase, testcase.App.CheckBox_3.MainCheckBox)
      pause(t)
    end  % function

  end  % methods

end  % classdef
