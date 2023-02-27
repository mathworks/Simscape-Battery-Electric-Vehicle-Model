classdef Vehicle1D_UnitTest_MQC < matlab.unittest.TestCase
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

properties (Constant)
  modelName = "Vehicle1D_harness_model";
end

methods (Test)

%% Top folder

function MQC_topfolder_1(~)
  close all
  bdclose all
  Vehicle1D_refsub_Basic_params
  close all
  bdclose all
end

%% Configuration folder

function MQC_Configuation_1(~)
  close all
  bdclose all
  mdl = "Vehicle1D_harness_model";
  load_system(mdl)
  Vehicle1D_loadSimulationCase
  close all
  bdclose all
end

function MQC_Configuation_2(~)
  close all
  bdclose all
  mdl = "Vehicle1D_harness_model";
  load_system(mdl)
  Vehicle1D_loadSimulationCase_Accelerate
  close all
  bdclose all
end

function MQC_Configuation_3(~)
  close all
  bdclose all
  mdl = "Vehicle1D_harness_model";
  load_system(mdl)
  Vehicle1D_loadSimulationCase_Braking
  close all
  bdclose all
end

function MQC_Configuation_4(~)
  close all
  bdclose all
  mdl = "Vehicle1D_harness_model";
  load_system(mdl)
  Vehicle1D_loadSimulationCase_Coastdown
  close all
  bdclose all
end

function MQC_Configuation_5(~)
  close all
  bdclose all
  mdl = "Vehicle1D_harness_model";
  load_system(mdl)
  Vehicle1D_loadSimulationCase_Constant
  close all
  bdclose all
end

%% Harness folder

function MQC_Harness_1(~)
  close all
  bdclose all
  Vehicle1D_harness_setup
  close all
  bdclose all
end

%% TestCases folder

function MQC_TestCase_1(~)
  close all
  bdclose all
  Vehicle1D_simulationCase_Accelerate
  close all
  bdclose all
end

function MQC_TestCase_2(~)
  close all
  bdclose all
  Vehicle1D_simulationCase_Braking
  close all
  bdclose all
end

function MQC_TestCase_3(~)
  close all
  bdclose all
  Vehicle1D_simulationCase_Coastdown
  close all
  bdclose all
end

function MQC_TestCase_4(~)
  close all
  bdclose all
  Vehicle1D_simulationCase_Constant
  close all
  bdclose all
end

%% Utility

%{
% This passes locally but fails in CI.
function MQC_Utility_1(~)
  close all
  bdclose all
  mdl = "Vehicle1D_harness_model";
  load_system(mdl)
  open_system(mdl + "/Longitudinal Vehicle")
  % Test target.
  % This test tests default arguments.
  Vehicle1D_getLongitudinalVehicleInfo
  close all
  bdclose all
end
%}

function MQC_Utility_2(~)
  close all
  bdclose all
  mdl = "Vehicle1D_harness_model";
  load_system(mdl)
  % Test target.
  % This test tests default arguments.
  Vehicle1D_plotInputs
  close all
  bdclose all
end

%{
% This passes locally but fails in CI.
function MQC_Utility_3(~)
  close all
  bdclose all
  mdl = "Vehicle1D_harness_model";
  load_system(mdl)
  open_system(mdl + "/Longitudinal Vehicle")
  % Test target.
  % This test tests default arguments.
  Vehicle1D_plotProperties_Basic
  close all
  bdclose all
end
%}

function MQC_Utility_4(~)
  close all
  bdclose all
  mdl = "Vehicle1D_harness_model";
  load_system(mdl)
  simOut = sim(mdl);
  simData = extractTimetable(simOut.logsout);
  % Test target.
  Vehicle1D_plotResults( SimData = simData )
  close all
  bdclose all
end

function MQC_Utility_5(~)
  close all
  bdclose all
  mdl = "Vehicle1D_harness_model";
  load_system(mdl)
  % Test target.
  % This test tests default arguments.
  Vehicle1D_resetHarnessModel
  close all
  bdclose all
end

end  % methods (Test)
end  % classdef
