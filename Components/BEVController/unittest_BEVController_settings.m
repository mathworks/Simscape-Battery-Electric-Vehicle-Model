classdef unittest_BEVController_settings < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

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

    function Solver(testcase)
      load_system("HarnessModel_BEVController")

      s = string(get_param(gcs, "SolverType"));
      verifyEqual(testcase, s, "Variable-step")

      s = string(get_param(gcs, "SolverName"));
      verifyEqual(testcase, s, "daessc")
    end  % function

    function PreLoadParameters(testcase)
      % Check that the model loads parameters in the callback.
      parameter_filename = "HarnessSetup_BEVController";  % without ".m"
      load_system("HarnessModel_BEVController")
      callback_text = string(get_param(gcs, "PreLoadFcn"));
      verifyTrue(testcase, contains(callback_text, lineBoundary("start") + parameter_filename + alphanumericBoundary))
    end  % function

    function SubsystemReferenceBlockSettings(testcase)
      % Check the settings of the Subsystem Reference block in the harness model.

      model_name = "HarnessModel_BEVController";
      block_path = "HarnessModel_BEVController/Inputs";

      load_system(model_name)

      % IO port labels must be visible, i.e.,
      % the Icon Transparency must be "Opaque with Ports". (Default is "Opaque".)
      actual = string(get_param(block_path, "MaskIconOpaque"));
      verifyEqual(testcase, actual, "opaque-with-ports")
    end  % function

  end  % methods

end  % classdef
