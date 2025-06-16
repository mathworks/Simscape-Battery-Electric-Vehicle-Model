classdef CtrlEnv_Vehicle_UnitTest_MQC < matlab.unittest.TestCase
  %% Class-based unit test implementation
  % https://www.mathworks.com/help/releases/R2025a/matlab/matlab_prog/class-based-unit-tests.html
  %
  % To navigate test results and see code coverage, use Test Browser (testBrowser).
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2023-2025 The MathWorks, Inc.

  methods(TestMethodSetup)
    % Functions in this "TestMethodSetup" section always run before
    % each test defined in the "Test" section runs.

    function TestSetup(testcase)
      function close_all
        close all
        bdclose all
      end  % nested function
      close_all
      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @close_all)
    end  % function

  end  % methods

  methods (Test)

    %% Component top folder

    function MQC_TopFolder_1(~)
      CtrlEnv_Vehicle_refsub_params
    end

    %% Harness folder

    function MQC_Harness_1(~)
      mdl = "CtrlEnv_Vehicle_harness_model";
      load_system(mdl)
      sim(mdl);
    end

    function MQC_Harness_2(~)
      CtrlEnv_Vehicle_harness_setup
    end

    %% Simulation cases folder

    function MQC_SimulationCase_1(~)
      CtrlEnv_Vehicle_Case
    end

    %% Utility > Configuration folder

    function MQC_Configuation_1(~)
      mdl = "CtrlEnv_Vehicle_harness_model";
      load_system(mdl)
      CtrlEnv_Vehicle_loadSimulationCase
    end

    function MQC_Configuation_2(~)
      CtrlEnv_Vehicle_setInitialConditions
    end

    %% Utility folder

    function MQC_Utility_1(~)
      CtrlEnv_Vehicle_getMotorSpeedFromVehicleSpeed
    end

    function MQC_Utility_2(~)
      mdl = "CtrlEnv_Vehicle_harness_model";
      load_system(mdl)
      simOut = sim(mdl);
      simData = extractTimetable(simOut.logsout);
      CtrlEnv_Vehicle_plotResults( SimData = simData );
    end

  end  % methods (Test)
end  % classdef
