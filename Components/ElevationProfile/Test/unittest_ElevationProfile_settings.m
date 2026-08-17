classdef unittest_ElevationProfile_settings < matlab.unittest.TestCase
  % Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2026 The MathWorks, Inc.

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
      load_system("HarnessModel_ElevationProfile")
      verifyTrue(testcase, get_param(gcs, "SolverType") == "Variable-step")
      verifyTrue(testcase, get_param(gcs, "SolverName") == "daessc")
    end  % function

    %% Parameter settings

    function preload_parameters(testcase)
      % Check that the model loads parameters in the callback.
      parameter_filename = "setupHarness_ElevationProfile";  % without ".m"
      load_system("HarnessModel_ElevationProfile")
      callback_text = string(get_param(gcs, "PreLoadFcn"));
      verifyTrue(testcase, contains(callback_text, lineBoundary("start") + parameter_filename + alphanumericBoundary))
    end  % function

    %% Unit settings in blocks

    % Unit settings in the block parameter value and the block parameter unit
    % must be the same.
    % For example, if the block parameter value has var1.value("s") or value(var1, "s"),
    % the block parameter unit must be s.

    function block_parameter_unit_1_1(testcase)
      %%
      model_name = "HarnessModel_ElevationProfile";
      load_system(model_name)

      % PS Lookup Table (1D) block
      block_path = model_name + "/Speed Reference";

      % x for the Table grid vector
      ok = bevutil1.ModelUtil.checkSimscapeUnitsInBlockParameters(block_path, "x");
      verifyTrue(testcase, ok)
    end  % function

    function block_parameter_unit_1_2(testcase)
      %%
      model_name = "HarnessModel_ElevationProfile";
      load_system(model_name)

      % PS Lookup Table (1D) block.
      block_path = model_name + "/Speed Reference";

      % f for Table values
      ok = bevutil1.ModelUtil.checkSimscapeUnitsInBlockParameters(block_path, "f");
      verifyTrue(testcase, ok)
    end  % function

    function block_parameter_unit_2_1(testcase)
      %%
      model_name = "HarnessModel_ElevationProfile";
      load_system(model_name)

      % Road Grade Profile block.
      block_path = model_name + "/Road";

      % x_vector for Horizontal distance for vertical profile
      ok = bevutil1.ModelUtil.checkSimscapeUnitsInBlockParameters(block_path, "x_vector");
      verifyTrue(testcase, ok)
    end  % function

    function block_parameter_unit_2_2(testcase)
      %%
      model_name = "HarnessModel_ElevationProfile";
      load_system(model_name)

      % Road Grade Profile block.
      block_path = model_name + "/Road";

      % left_elevation for Elevation at left most horizontal position
      ok = bevutil1.ModelUtil.checkSimscapeUnitsInBlockParameters(block_path, "x_vector");
      verifyTrue(testcase, ok)
    end  % function

    function block_parameter_unit_2_3(testcase)
      %%
      model_name = "HarnessModel_ElevationProfile";
      load_system(model_name)

      % Road Grade Profile block.
      block_path = model_name + "/Road";

      % initial_position for Initial horizontal position
      ok = bevutil1.ModelUtil.checkSimscapeUnitsInBlockParameters(block_path, "initial_position");
      verifyTrue(testcase, ok)
    end  % function

    %% Button block callback

    function Click_callback_1(~)
      model_name = "HarnessModel_ElevationProfile";
      load_system(model_name)
      ClickFcn = get_param(model_name + "/Plot inputs", "ClickFcn");
      eval(ClickFcn)  % !test-target
    end  % function

    function Click_callback_2(~)
      model_name = "HarnessModel_ElevationProfile";
      load_system(model_name)
      ClickFcn = get_param(model_name + "/Plot elevation and grade profiles", "ClickFcn");
      eval(ClickFcn)  % !test-target
    end  % function

  end  % methods
end  % classdef
