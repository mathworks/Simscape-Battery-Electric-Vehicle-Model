classdef unittest_Reducer_settings < matlab.unittest.TestCase
  % Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser (testBrowser)
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2025-2026 The MathWorks, Inc.

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

    %% Solver settings

    function solver_settings(testcase)
      load_system("HarnessModel_Reducer")
      verifyTrue(testcase, get_param(gcs, "SolverType") == "Variable-step")
      verifyTrue(testcase, get_param(gcs, "SolverName") == "daessc")
    end  % function

    %% Subsystem Reference block settings

    function subsystem_reference_block_settings_1(testcase)
      model_name = "HarnessModel_Reducer";
      block_path = "HarnessModel_Reducer/Reducer";

      load_system(model_name)

      % The OpenFcn callback has to have the following code.
      %   open_system(gcb, "force")
      openFcn_text = string(get_param(block_path, "OpenFcn"));
      target_text = lineBoundary("start") + "open_system(gcb, ""force"")";
      verifyTrue(testcase, contains(openFcn_text, target_text));

      % IO port labels must be visible, i.e.,
      % the Icon Transparency must be "Opaque with Ports". (Default is "Opaque".)
      actual = string(get_param(block_path, "MaskIconOpaque"));
      verifyEqual(testcase, actual, "opaque-with-ports")
    end  % function

    %% Callback Button blocks

    function Click_callback_1(testcase)
      %%
      model_name = "HarnessModel_Reducer";
      load_system(model_name)

      ClickFcn_text = get_param(model_name + "/Select torque inputs 1", "ClickFcn");  % !test-target

      % Check that the ClickFcn text contains the expected commands.
      verifyTrue(testcase, contains(ClickFcn_text, "loadLUTData_Reducer_Motor_Constant"))  % !test-target
      verifyTrue(testcase, contains(ClickFcn_text, "loadLUTData_Reducer_Axle_Constant"))  % !test-target

      eval(ClickFcn_text)  % !test-target

    end  % function

    function Click_callback_2(testcase)
      %%
      model_name = "HarnessModel_Reducer";
      load_system(model_name)

      ClickFcn_text = get_param(model_name + "/Select torque inputs 2", "ClickFcn");  % !test-target

      % Check that the ClickFcn text contains the expected commands.
      verifyTrue(testcase, contains(ClickFcn_text, "loadLUTData_Reducer_Motor_FlipTorque"))  % !test-target
      verifyTrue(testcase, contains(ClickFcn_text, "loadLUTData_Reducer_Axle_FlipTorque"))  % !test-target

      eval(ClickFcn_text)  % !test-target

    end  % function

    function Click_callback_3(testcase)
      %%
      model_name = "HarnessModel_Reducer";
      load_system(model_name)

      ClickFcn_text = get_param(model_name + "/Plot toque inputs", "ClickFcn");  % !test-target

      eval(ClickFcn_text)  % !test-target

    end  % function

  end  % methods
end  % classdef
