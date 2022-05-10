classdef BatteryHVDetailed_UnitTest < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2022 The MathWorks, Inc.

properties (Constant)
  modelName = "BatteryHVDetailed_harness_model";
end

methods (Test)

function run_harness_model_with_SingleModuleApproximation(testCase)
%% Open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;
  load_system(mdl)

  % Set referenced subsystems.
  set_param( mdl + "/High Voltage Battery", ...
    ReferencedSubsystem = "BatteryHVDetailed_refsub_SingleApprox")

  % Set short simulation time just to check that simulation can start.
  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime","10");

  % Run simulation.
  sim(simIn);

  close all
  bdclose all

end  % function

function run_harness_model_with_MultiModule(testCase)
%% Open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;
  load_system(mdl)

  % Set referenced subsystems.
  set_param( mdl + "/High Voltage Battery", ...
    ReferencedSubsystem = "BatteryHVDetailed_refsub_MultiModule")

  % Set short simulation time just to check that simulation can start.
  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime","10");

  % Run simulation.
  sim(simIn);

  close all
  bdclose all

end  % function

%% Test Simscape custom library build

function build_Simscape_custom_library(~)
%%
  prjRoot = currentProject().RootFolder;
  libpath = fullfile(prjRoot, ...
    "DetailedModelApplications", "BatteryHighVoltageDetailed", "lib");
  prevFolder = cd(libpath);
  ssc_build batteryModule
  cd(prevFolder)
end

end  % methods (Test)
end  % classdef
