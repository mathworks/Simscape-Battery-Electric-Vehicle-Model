classdef BatteryHVDetailed_BEV_UnitTest < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2022 The MathWorks, Inc.

properties (Constant)
  modelName = "BevDriveCycle_system_model";
end

methods (Test)

function run_BEV_model_with_Basic_hvbattery(testCase)
%% Open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;
  load_system(mdl)

  % Set referenced subsystems.
  BevDriveCycle_setBasic

  evalin("base", "BevDriveCycle_params_Basic")

  % Set short simulation time just to check that simulation can start.
  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime","150");

  % Run simulation.
  sim(simIn);

  close all
  bdclose all

end  % function

function run_BEV_model_with_GroupedSingleModule_hvbattery(testCase)
%% Open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;
  load_system(mdl)

  % Set referenced subsystems.
  BevDriveCycle_setDetailedSingle

  evalin("base", "BevDriveCycle_params_DetailedSingle")

  % Set short simulation time just to check that simulation can start.
  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime","50");

  % Run simulation.
  sim(simIn);

  close all
  bdclose all

end  % function

function run_BEV_model_with_MultiModule_hvbattery(testCase)
%% Open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;
  load_system(mdl)

  % Set referenced subsystems.
  BevDriveCycle_setDetailedMulti

  evalin("base", "BevDriveCycle_params_DetailedMulti")

  % Set short simulation time just to check that simulation can start.
  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime","30");

  % Run simulation.
  sim(simIn);

  close all
  bdclose all

end  % function

%% Test for Scripts
% Check that scripts run without any warnings or errors.

function run_BEV_workflow_script(~)
%% Run the workflow script.

  close all
  bdclose all

  % By default, the workflow script runs the FTP-75 drive cycle simulation
  % whose simulation end time is over 2000 seconds.
  % With the detailed multi-module battery, that simulation takes
  % more than 10 minutes to complete.
  % The function below overrides to set it to 30 seconds
  % just to check that the script runs ok.
  BevDriveCycle_setSimulationTime(seconds(30))

  % This Live Script uses variables in the base workspace,
  % thus it is evaluated in the base workspace, not in this function.
  evalin('base', 'BEV_Battery_Plant_Workflow')

  close all
  bdclose all
end

end  % methods (Test)
end  % classdef
