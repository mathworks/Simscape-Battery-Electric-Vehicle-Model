classdef BatteryHV_test_SystemTable_Utility < matlab.unittest.TestCase
  % This is class-based unit test implementation.
  %
  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html

  % Copyright 2025 The MathWorks, Inc.

  methods (TestMethodSetup)
    % Functions in this section always run before each test defined in the Test section runs.

    function test_method_setup_1(testcase)
      function closeAll
        close all
        bdclose all
      end  % nested function
      closeAll
      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @closeAll)
    end  % function

  end  % methods

  methods (Test)
    % Functions in this "Test" section are the tests.
    % Before each function in this section runs, functions defined in the TestMethodSetup section run.

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function MQC_BatteryHV_buildData_sample_script_1(~)
      BatteryHV_SystemTable_DataBuild_sample_script  % !test-target
    end  % function

    function MQC_BatteryHV_SystemTable_ParameterPlot_sample_script_1(~)
      BatteryHV_SystemTable_ParameterPlot_sample_script  % !test-target
    end  % function

    %% Other tests

    function check_markdowns(testcase)
      % Check that all live scripts have been converted to markdown files.
      n = FileTool1.batchGenerateMarkdowns( ...
        LiveScriptFolderNames = pwd, ...
        MarkdownFolderPath = "markdown", ...
        DisplayInfo = true);

      verifyEqual(testcase, n, 0)  % !test-target

    end  % function

  end  % methods

end  % classdef
