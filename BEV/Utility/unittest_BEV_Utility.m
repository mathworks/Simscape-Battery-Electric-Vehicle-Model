classdef unittest_BEV_Utility < matlab.unittest.TestCase
  % Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2024-2026 The MathWorks, Inc.

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

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(~)
      BEV_findInitialConditions
    end  % function

    function PassingTest_2(~)
      BEV_plotResults
    end  % function

    function PassingTest_3(~)
      BEV_plotResults(PlotTemperature=false)
    end  % function

    function PassingTest_4(~)
      ax = axes(figure);

      BEV_plotResults(ParentContainer=ax)  % !test-target

    end  % function

    function PassingTest_5(~)
      speed = (0:10)';
      refspeed = (0:10)';
      g = (0:10)';
      torquecommand = (0:10)';
      motortemp = (0:10)';
      battsoc = (0:10)';
      battcurrent = (0:10)';
      battpower = (0:10)';
      batttemp = (0:10)';
      data = timetable(seconds(0:10)', speed, refspeed, g, torquecommand, motortemp, battsoc, battcurrent, battpower, batttemp, ...
        VariableNames = [ ...
        "Vehicle Speed kph", ...
        "Reference Vehicle Speed kph", ...
        "G-Force", ...
        "Motor Torque Command", ...
        "Motor Temperature", ...
        "HV Battery SOC", ...
        "HV Battery Current", ...
        "HV Battery Power", ...
        "HV Battery Temperature"]);

      BEV_plotResults(TimedData=data)  % !test-target

    end  % function

    function PassingTest_6(~)
      % The returned figure can be used to generate an image file with the exportgraphics command.
      % In this test, however, just check that the returned figure works.
      % To manually inspect the returned figure, select the code below and evaluate it.
      fig = BEV_plotResults;  % !test-target
      fig.Position(3) = 900;  % width
      fig.Position(4) = 600;  % height
    end  % function

  end  % methods
end  % classdef
