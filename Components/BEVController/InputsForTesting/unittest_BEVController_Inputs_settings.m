classdef unittest_BEVController_Inputs_settings < matlab.unittest.TestCase
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

    function SubsystemReferenceBlockSettings(testcase)
      % Check the settings of the Subsystem Reference block in the harness model.

      model_name = "HarnessModel_BEVController_Inputs";
      block_path = "HarnessModel_BEVController_Inputs/Inputs";

      load_system(model_name)

      % IO port labels must be visible, i.e.,
      % the Icon Transparency must be "Opaque with Ports". (Default is "Opaque".)
      actual = string(get_param(block_path, "MaskIconOpaque"));
      verifyEqual(testcase, actual, "opaque-with-ports")
    end  % function

    function RefSub_IconLabel_2(testcase)
      % Check that the referenced subsystem has an icon label.

      refsub_name = "Inputs_BEVController_Random_refsub";
      icon_label = "Random";

      load_system(refsub_name)
      mask = Simulink.Mask.get(refsub_name);
      icon_code_text = string(mask.Display);
      verifyTrue(testcase, contains(icon_code_text, """" + icon_label + """"))
    end  % function

    function RefSub_IconLabel_1(testcase)
      % Check that the referenced subsystem has an icon label.

      refsub_name = "Inputs_BEVController_Simple_refsub";
      icon_label = "Simple";

      load_system(refsub_name)
      mask = Simulink.Mask.get(refsub_name);
      icon_code_text = string(mask.Display);
      verifyTrue(testcase, contains(icon_code_text, """" + icon_label + """"))
    end  % function

  end  % methods

end  % classdef
