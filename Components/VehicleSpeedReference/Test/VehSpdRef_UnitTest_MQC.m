classdef VehSpdRef_UnitTest_MQC < BEVTestCase
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

% Copyright 2021-2023 The MathWorks, Inc.

methods (Test)

%% SimulationCases folder

function MQC_SimulationCase_1(~)
  VehSpdRef_simulationCase_Constant
end

function MQC_SimulationCase_2(~)
  VehSpdRef_simulationCase_FTP75
end

function MQC_SimulationCase_3(~)
  VehSpdRef_simulationCase_HighSpeed
end

function MQC_SimulationCase_4(~)
  VehSpdRef_simulationCase_SimpleDrivePattern
end

function MQC_SimulationCase_5(~)
  VehSpdRef_simulationCase_WLTP
end

%% Utility folder

function MQC_Utility_1(~)
  mdl = "VehSpdRef_harness_model";
  load_system(mdl)
  VehSpdRef_loadSimulationCase
  simOut = sim(mdl);
  simData = extractTimetable(simOut.logsout);
  % Test target:
  VehSpdRef_plotResults(simData=simData)
end

end  % methods (Test)
end  % classdef
