classdef BEVController_UnitTest_MQC < matlab.unittest.TestCase
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

%% Harness folder

function MQC_Harness_1(~)
  close all
  bdclose all
  mdl = "BEVController_harness_model";
  load_system(mdl)
  sim(mdl);
  close all
  bdclose all
end

function MQC_Harness_2(~)
  close all
  bdclose all
  BEVController_harness_setup
  close all
  bdclose all
end

%% SimulationCases folder

function MQC_SimulationCase_1(~)
  close all
  bdclose all
  BEVController_simulationCase
  close all
  bdclose all
end

%% Component top folder

function MQC_TopFolder_1(~)
  close all
  bdclose all
  BEVController_refsub_Basic_params
  close all
  bdclose all
end

end  % methods (Test)
end  % classdef
