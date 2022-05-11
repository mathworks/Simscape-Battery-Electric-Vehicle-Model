classdef BEV_UnitTest < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2022 The MathWorks, Inc.

properties (Constant)
  modelName = "BEV_system_model";
end

methods (Test)

function run_system_model_with_basic_hvbattery(testCase)
%% Open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;

  t_end = 300;  % Simulation stop time in seconds

  load_system(mdl)

  BEV_resetReferencedSubsystems

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, StopTime=num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end

function run_system_model_with_simple_thermal_hvbattery(testCase)
%% Open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;

  t_end = 300;  % Simulation stop time in seconds

  load_system(mdl)

  BEV_setRefSub_HVBattDriveline

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, StopTime=num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end

function run_system_model_with_thermal_hvbattery(testCase)
%% Open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;

  t_end = 300;  % Simulation stop time in seconds

  load_system(mdl)

  BEV_setRefSub_HVBattElectrical

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, StopTime=num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end

function run_main_script(testCase)
%% Run main script.
  close all
  bdclose all

  evalin("base", "BEV_main_script")

  close all
  bdclose all
end

end  % methods (Test)
end  % classdef
