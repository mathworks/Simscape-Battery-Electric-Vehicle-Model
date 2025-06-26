classdef Vehicle1DPerformance_test < matlab.unittest.TestCase
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

    function MQC_plot_1(~)
      Vehicle1DPerformancePlot
    end  % function

    function MQC_parameters_1(~)
      Vehicle1DPerformanceParameters;
    end  % function

    function MQC_parameter_presets_1(~)
      Vehicle1DPerformanceParameterPresets;
    end  % function

  end  % methods
end  % classdef
