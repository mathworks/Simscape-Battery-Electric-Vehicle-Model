classdef test_screenshotSimulink < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2023-2025 The MathWorks, Inc.

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

    function PassingTest_1(~)
      ModelTool1.screenshotSimulink( ...
        StandaloneTest = true, ...
        PaddingHorizontal_px = 10, ...
        PaddingVertical_px = 10)

      delete("screenshot-untitled.png")
    end  % function

    function PassingTest_2(~)
      model_name = "screenshotSimulink_TestModel";

      load_system(model_name)

      % To show the Unit information overlay, the model must be updated.
      set_param(model_name, SimulationCommand = "update")

      ModelTool1.screenshotSimulink( ...
        OutputFileName = "screenshot-test-model-top.png", ...
        SimulinkModelName = model_name, ...
        SaveFolder = pwd );

      delete("screenshot-test-model-top.png")
    end  % function

    function PassingTest_3(~)
      model_name = "screenshotSimulink_TestModel";

      load_system(model_name)

      % To show the Unit information overlay, the model must be updated.
      set_param(model_name, SimulationCommand = "update")

      ModelTool1.screenshotSimulink( ...
        OutputFileName = "screenshot-test-model-subsystem-without-padding.png", ...
        SimulinkModelName = model_name, ...
        SubsystemPath = "/Subsystem1", ...
        PaddingHorizontal_px = 0, ...
        PaddingVertical_px = 0, ...
        PaddingColorRGB = [1, 1, 0], ...
        SaveFolder = pwd );

      delete("screenshot-test-model-subsystem-without-padding.png")
    end  % function

    function PassingTest_4(~)
      model_name = "screenshotSimulink_TestModel";

      load_system(model_name)

      % To show the Unit information overlay, the model must be updated.
      set_param(model_name, SimulationCommand = "update")

      ModelTool1.screenshotSimulink( ...
        OutputFileName = "screenshot-test-model-subsystem-with-padding-vertical-20px.png", ...
        SimulinkModelName = model_name, ...
        SubsystemPath = "/Subsystem1", ...
        PaddingHorizontal_px = 0, ...
        PaddingVertical_px = 20, ...
        PaddingColorRGB = [1, 1, 0], ...
        SaveFolder = pwd );

      delete("screenshot-test-model-subsystem-with-padding-vertical-20px.png")
    end  % function

    function PassingTest_5(~)
      model_name = "screenshotSimulink_TestModel";

      load_system(model_name)

      % To show the Unit information overlay, the model must be updated.
      set_param(model_name, SimulationCommand = "update")

      ModelTool1.screenshotSimulink( ...
        OutputFileName = "screenshot-test-model-subsystem-with-padding-horizontal-20px.png", ...
        SimulinkModelName = model_name, ...
        SubsystemPath = "/Subsystem1", ...
        PaddingHorizontal_px = 20, ...
        PaddingVertical_px = 0, ...
        PaddingColorRGB = [1, 1, 0], ...
        SaveFolder = pwd );

      delete("screenshot-test-model-subsystem-with-padding-horizontal-20px.png")
    end  % function

  end  % methods

end  % classdef
