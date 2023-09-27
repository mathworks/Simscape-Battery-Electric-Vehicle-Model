classdef CtrlEnv_Vehicle_UnitTest_MQC < BEVTestCase
% Class implementation of unit test
%
% These are tests to achieve the Minimum Quality Criteria (MQC).
% MQC is achieved when all runnables (models, scripts, functions) run
% without any errors.
%
% You can run this test by opening in MATLAB Editor and clicking
% Run Tests button or Run Current Test button.
% You can also run this test using test runner (the *_runtests.m script)
% which can not only run tests but also generates test summary and
% a code coverage report.

% Copyright 2023 The MathWorks, Inc.

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
  CtrlEnv_Vehicle_simulationCase
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
