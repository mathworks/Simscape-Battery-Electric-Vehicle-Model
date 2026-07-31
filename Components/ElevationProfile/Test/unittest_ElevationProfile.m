classdef unittest_ElevationProfile < matlab.unittest.TestCase
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

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(~)
      load_system("HarnessModel_ElevationProfile")
    end  % function

    function PassingTest_2(~)
      sim("HarnessModel_ElevationProfile");
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

      % PS Lookup Table (1D) block.
      block_path = model_name + "/Speed Reference";

      % Table grid vector
      param_value_text = string(get_param(block_path, "x"));
      param_unit = string(get_param(block_path, "x_unit"));

      % The value("s") style.
      unit_in_value = string(extractBetween(param_value_text, "value(""", """)"));
      if unit_in_value == ""
        % The value(var1, "s") style.
        unit_in_value = string(extractBetween(param_value_text, "value(" + wildcardPattern + """", """)"));
      end  % if
      verifyTrue(testcase, unit_in_value ~= "")
      verifyEqual(testcase, unit_in_value, param_unit)
    end  % function

    function block_parameter_unit_1_2(testcase)
      %%
      model_name = "HarnessModel_ElevationProfile";
      load_system(model_name)

      % PS Lookup Table (1D) block.
      block_path = model_name + "/Speed Reference";

      % Table values
      param_value_text = string(get_param(block_path, "f"));
      param_unit = string(get_param(block_path, "f_unit"));

      % The value("s") style.
      unit_in_value = string(extractBetween(param_value_text, "value(""", """)"));
      if unit_in_value == ""
        % The value(var1, "s") style.
        unit_in_value = string(extractBetween(param_value_text, "value(" + wildcardPattern + """", """)"));
      end  % if
      verifyTrue(testcase, unit_in_value ~= "")
      verifyEqual(testcase, unit_in_value, param_unit)
    end  % function

    function block_parameter_unit_2_1(testcase)
      %%
      model_name = "HarnessModel_ElevationProfile";
      load_system(model_name)

      % Road Grade Profile block.
      block_path = model_name + "/Road";

      % Horizontal distance for vertical profile
      param_value_text = string(get_param(block_path, "x_vector"));
      param_unit = string(get_param(block_path, "x_vector_unit"));

      % The value("s") style.
      unit_in_value = string(extractBetween(param_value_text, "value(""", """)"));
      if unit_in_value == ""
        % The value(var1, "s") style.
        unit_in_value = string(extractBetween(param_value_text, "value(" + wildcardPattern + """", """)"));
      end  % if
      verifyTrue(testcase, unit_in_value ~= "")
      verifyEqual(testcase, unit_in_value, param_unit)
    end  % function

    function block_parameter_unit_2_2(testcase)
      %%
      model_name = "HarnessModel_ElevationProfile";
      load_system(model_name)

      % Road Grade Profile block.
      block_path = model_name + "/Road";

      % Elevation at left most horizontal position
      param_value_text = string(get_param(block_path, "left_elevation"));
      param_unit = string(get_param(block_path, "left_elevation_unit"));

      % The value("s") style.
      unit_in_value = string(extractBetween(param_value_text, "value(""", """)"));
      if unit_in_value == ""
        % The value(var1, "s") style.
        unit_in_value = string(extractBetween(param_value_text, "value(" + wildcardPattern + """", """)"));
      end  % if
      verifyTrue(testcase, unit_in_value ~= "")
      verifyEqual(testcase, unit_in_value, param_unit)
    end  % function

    function block_parameter_unit_2_3(testcase)
      %%
      model_name = "HarnessModel_ElevationProfile";
      load_system(model_name)

      % Road Grade Profile block.
      block_path = model_name + "/Road";

      % Initial horizontal position
      param_value_text = string(get_param(block_path, "initial_position"));
      param_unit = string(get_param(block_path, "initial_position_unit"));

      % The value("s") style.
      unit_in_value = string(extractBetween(param_value_text, "value(""", """)"));
      if unit_in_value == ""
        % The value(var1, "s") style.
        unit_in_value = string(extractBetween(param_value_text, "value(" + wildcardPattern + """", """)"));
      end  % if
      verifyTrue(testcase, unit_in_value ~= "")
      verifyEqual(testcase, unit_in_value, param_unit)
    end  % function

  end  % methods
end  % classdef
