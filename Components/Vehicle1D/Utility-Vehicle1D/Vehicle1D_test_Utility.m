classdef Vehicle1D_test_Utility < matlab.unittest.TestCase
  %% Class implementation of unit test
  % This is class-based unit test implementation.
  % To navigate test results and see code coverage, use Test Browser (testBrowser).
  %
  % Documentation
  %
  % - Author Class-Based Unit Tests in MATLAB
  %   https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % - matlab.unittest.TestCase Class
  %   https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % - Test Browser
  %   https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2021-2025 The MathWorks, Inc.

  methods (TestMethodSetup)
    % Functions/methods defined in this TestMethodSetup section run before
    % every test defined in the Test section starts.

    function test_method_setup(testcase)

      function close_all()
        close all
        bdclose all
      end  % nested function

      close_all()

      % Registering a clean up function to the testcase object here before
      % the test starts ensures that the clean up happens even when
      % a test terminates midway due to an error.
      addTeardown(testcase, @close_all)

    end % function

  end  % methods

  methods (Test)

    %% Minimum Quality Check (MQC)
    % Check that scripts, functions, classes, and models run right out of the box.

    function MQC_plot_input_signals_1(~)
      Vehicle1D_plotInputs;
    end  % function

    function MQC_reset_harness_model_1(~)
      Vehicle1D_resetHarnessModel
    end  % function

    function MQC_set_initial_conditions_1(~)
      % This creates the variable called initial in base workspace.
      Vehicle1D_setInitialConditions
      evalin("base", "clear initial")
    end  % function

    function MQC_setSimulationCase_1(~)
      Vehicle1D_setSimulationCase
    end  % function

    function MQC_setSimCase_Constant_1(~)
      Vehicle1D_setSimCase_Constant
    end  % function

    function MQC_setSimCase_Accelerate_1(~)
      Vehicle1D_setSimCase_Accelerate
    end  % function

    function MQC_setSimCase_Braking_1(~)
      Vehicle1D_setSimCase_Braking
    end  % function

    function MQC_setSimCase_Coastdown_1(~)
      Vehicle1D_setSimCase_Coastdown
    end  % function

    %% Other tests

    function check_markdowns_uptodate_1(testcase)
      % Check that the script-exported markdown files are up to date.
      num = Vehicle1D_generateMarkdown(DisplayInfo=false);
      verifyEqual(testcase, num, 0)
    end  % function

  end  % methods
end  % classdef
