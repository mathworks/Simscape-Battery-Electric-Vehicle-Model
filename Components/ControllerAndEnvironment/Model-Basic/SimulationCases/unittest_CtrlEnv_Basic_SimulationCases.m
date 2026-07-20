classdef unittest_CtrlEnv_Basic_SimulationCases < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2024-2025 The MathWorks, Inc.

  properties

    % Keyword representing the model.
    % This is defined by extracting text after "Model-" in a folder name.
    % For example, "Basic" from the "Model-Basic" folder, or
    % "SystemThermal" from the "Model-SystemThermal" folder.
    ModelID (1,1) string

  end  % properties

  methods (TestClassSetup)
    % Functions in this section run only once before tests in the Test section runs.

    function setup_ModelID(testcase)
      % Extract text from the pwd path string.
      % For example, extract "Basic" from "Model-Basic/SimulationCases".
      testcase.ModelID = extractBetween(string(pwd), "Model-", filesep+"SimulationCase");

      % Extract text from the classname.
      % For example, extract "Basic" from "unittest_CtrlEnv_Basic_SimulationCases".
      id = extractBetween(string(mfilename), "unittest_CtrlEnv_", "_SimulationCases");

      % The texts extracted from the path and the class name must match.
      verifyEqual(testcase, testcase.ModelID, id)

      disp("# Starting tests with ModelID: " + testcase.ModelID)
    end  % function

  end  % methods

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

    function PassingTest_1(testcase)
      % Run script, for example, CtrlEnv_Basic_Constant.
      target_name = "CtrlEnv_" + testcase.ModelID + "_Constant";
      target_fullpath = bevutil1.FileUtil.getFileFullPath(target_name);
      disp("Testing: " + target_fullpath)
      evalin("base", target_name)  % !test-target
    end  % function

    function PassingTest_2(testcase)
      % Run script, for example, CtrlEnv_Basic_Constant.
      target_name = "CtrlEnv_" + testcase.ModelID + "_FTP75";
      target_fullpath = bevutil1.FileUtil.getFileFullPath(target_name);
      disp("Testing: " + target_fullpath)
      evalin("base", target_name)  % !test-target
    end  % function

    function PassingTest_3(testcase)
      % Run script, for example, CtrlEnv_Basic_Constant.
      target_name = "CtrlEnv_" + testcase.ModelID + "_Simple";
      target_fullpath = bevutil1.FileUtil.getFileFullPath(target_name);
      disp("Testing: " + target_fullpath)
      evalin("base", target_name)  % !test-target
    end  % function

  end  % methods

end  % classdef
