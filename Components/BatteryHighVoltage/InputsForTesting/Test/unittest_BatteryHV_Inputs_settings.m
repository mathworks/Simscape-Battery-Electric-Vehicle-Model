classdef unittest_BatteryHV_Inputs_settings < matlab.unittest.TestCase
  % Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
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

    function PreLoadFcn_for_parameters(testcase)
      % Check that the model loads parameters in the PreLoadFcn callback.
      parameter_filename = "LoadInputs_BatteryHV_Constant";  % without ".m"
      load_system("HarnessModel_BatteryHV_Inputs")
      callback_text = string(get_param(gcs, "PreLoadFcn"));
      verifyTrue(testcase, contains(callback_text, lineBoundary("start") + parameter_filename + alphanumericBoundary))
    end  % function

    function SubsystemReferenceBlockSettings(testcase)
      % Check the settings of the Subsystem Reference block in the harness model.

      model_name = "HarnessModel_BatteryHV_Inputs";
      block_path = "HarnessModel_BatteryHV_Inputs/Inputs";

      load_system(model_name)

      % The OpenFcn callback of the Subsystem Reference block has to have the following code.
      %   open_system(gcb, "force")
      openFcn_text = string(get_param(block_path, "OpenFcn"));
      target_text = lineBoundary("start") + "open_system(gcb, ""force"")";
      verifyTrue(testcase, contains(openFcn_text, target_text));

      % IO port labels must be visible, i.e.,
      % the Icon Transparency must be "Opaque with Ports". (Default is "Opaque".)
      actual = string(get_param(block_path, "MaskIconOpaque"));
      verifyEqual(testcase, actual, "opaque-with-ports")
    end  % function

    function RefSub_IconLabel_1(testcase)
      % Check that the referenced subsystem has an icon label.

      refsub_name = "Inputs_BatteryHV_refsub";
      icon_label = "BatteryHV";

      load_system(refsub_name)
      mask = Simulink.Mask.get(refsub_name);
      icon_code_text = string(mask.Display);
      verifyTrue(testcase, contains(icon_code_text, """" + icon_label + """"))
    end  % function

  end  % methods
end  % classdef
