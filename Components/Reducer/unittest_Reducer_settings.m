classdef unittest_Reducer_settings < matlab.unittest.TestCase
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

    %% Subsystem Reference block settings

    function subsystem_reference_block_settings_1(testcase)
      model_name = "HarnessModel_Reducer";
      block_path = "HarnessModel_Reducer/Axle inputs";

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

    function subsystem_reference_block_settings_2(testcase)
      model_name = "HarnessModel_Reducer";
      block_path = "HarnessModel_Reducer/Motor inputs";

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

    %% Button block callback

    function Click_callback_1(testcase)
      model_name = "HarnessModel_Reducer";
      load_system(model_name)

      ClickFcn = get_param(model_name + "/Select axle inputs 1", "ClickFcn");

      % The callback changes the referenced subsystem.
      eval(ClickFcn)  % !test-target

      mask = Simulink.Mask.get(model_name + "/Axle inputs");
      icon_code = mask.Display;

      % Check that the expected referenced subsystem was selected by the callback.
      verifyTrue(testcase, contains(icon_code, """Constant"""))

      % Make sure simulation runs with the selected referenced subsystem.
      sim(model_name);
    end  % function

    function Click_callback_2(testcase)
      model_name = "HarnessModel_Reducer";
      load_system(model_name)

      ClickFcn = get_param(model_name + "/Select axle inputs 2", "ClickFcn");

      % The callback changes the referenced subsystem.
      eval(ClickFcn)  % !test-target

      mask = Simulink.Mask.get(model_name + "/Axle inputs");
      icon_code = mask.Display;

      % Check that the expected referenced subsystem was selected by the callback.
      verifyTrue(testcase, contains(icon_code, """Flip"""))

      % Make sure simulation runs with the selected referenced subsystem.
      sim(model_name);
    end  % function

    function Click_callback_3(testcase)
      model_name = "HarnessModel_Reducer";
      load_system(model_name)

      ClickFcn = get_param(model_name + "/Select motor inputs 1", "ClickFcn");

      % The callback changes the referenced subsystem.
      eval(ClickFcn)  % !test-target

      mask = Simulink.Mask.get(model_name + "/Motor inputs");
      icon_code = mask.Display;

      % Check that the expected referenced subsystem was selected by the callback.
      verifyTrue(testcase, contains(icon_code, """Constant"""))

      % Make sure simulation runs with the selected referenced subsystem.
      sim(model_name);
    end  % function

    function Click_callback_4(testcase)
      model_name = "HarnessModel_Reducer";
      load_system(model_name)

      ClickFcn = get_param(model_name + "/Select motor inputs 2", "ClickFcn");

      % The callback changes the referenced subsystem.
      eval(ClickFcn)  % !test-target

      mask = Simulink.Mask.get(model_name + "/Motor inputs");
      icon_code = mask.Display;

      % Check that the expected referenced subsystem was selected by the callback.
      verifyTrue(testcase, contains(icon_code, """Flip"""))

      % Make sure simulation runs with the selected referenced subsystem.
      sim(model_name);
    end  % function

    function Click_callback_5(~)
      model_name = "HarnessModel_Reducer";
      load_system(model_name)

      ClickFcn = get_param(model_name + "/Visualize inputs", "ClickFcn");

      % The callback creates a plot window.
      eval(ClickFcn)  % !test-target

    end  % function

  end  % methods

end  % classdef
