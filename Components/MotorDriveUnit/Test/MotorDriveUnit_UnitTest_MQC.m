classdef MotorDriveUnit_UnitTest_MQC < matlab.unittest.TestCase
% Class implementation of unit test
%
% These are tests to achieve the Minimum Quality Criteria (MQC).
% MQC is achieved when all runnables (models, scripts, functions) run
% without any errors.
%
% You can run this test by opening in MATLAB Editor and clicking
% Run Tests button or Run Current Test button.
% You can also run this test using test runner (*_runtests.m)
% which can not only run tests but also generates summary and
% measures code coverage report.

% Copyright 2021-2023 The MathWorks, Inc.

methods (Test)

%% Component's top folder

function MQC_TopFolder_1(~)
  close all
  bdclose all
  MotorDriveUnit_refsub_Basic_params
  close all
  bdclose all
end

function MQC_TopFolder_2(~)
  close all
  bdclose all
  MotorDriveUnit_refsub_BasicThermal_params
  close all
  bdclose all
end

function MQC_TopFolder_3(~)
  close all
  bdclose all
  MotorDriveUnit_refsub_Tabulated_params
  close all
  bdclose all
end

%% Configuration folder

function MQC_Configurarion_loadSim_1(~)
  close all
  bdclose all
  mdl = "MotorDriveUnit_harness_model";
  load_system(mdl)
  MotorDriveUnit_loadSimulationCase
  close all
  bdclose all
end

function MQC_Configurarion_loadSim_2(~)
  close all
  bdclose all
  mdl = "MotorDriveUnit_harness_model";
  load_system(mdl)
  MotorDriveUnit_loadSimulationCase_Constant
  close all
  bdclose all
end

function MQC_Configurarion_loadSim_3(~)
  close all
  bdclose all
  mdl = "MotorDriveUnit_harness_model";
  load_system(mdl)
  MotorDriveUnit_loadSimulationCase_Drive
  close all
  bdclose all
end

function MQC_Configurarion_loadSim_4(~)
  close all
  bdclose all
  mdl = "MotorDriveUnit_harness_model";
  load_system(mdl)
  MotorDriveUnit_loadSimulationCase_Random
  close all
  bdclose all
end

function MQC_Configurarion_loadSim_5(~)
  close all
  bdclose all
  mdl = "MotorDriveUnit_harness_model";
  load_system(mdl)
  MotorDriveUnit_loadSimulationCase_RegenBrake
  close all
  bdclose all
end

function MQC_Configurarion_setInit(~)
  close all
  bdclose all
  MotorDriveUnit_setInitialConditions
  close all
  bdclose all
end

function MQC_Configurarion_useRefsub_1(~)
  close all
  bdclose all
  MotorDriveUnit_useRefsub
  close all
  bdclose all
end

function MQC_Configurarion_useRefsub_2(~)
  close all
  bdclose all
  MotorDriveUnit_useRefsub_Basic
  close all
  bdclose all
end

function MQC_Configurarion_useRefsub_3(~)
  close all
  bdclose all
  MotorDriveUnit_useRefsub_BasicThermal
  close all
  bdclose all
end

function MQC_Configurarion_useRefsub_4(~)
  close all
  bdclose all
  MotorDriveUnit_useRefsub_Tabulated
  close all
  bdclose all
end

%% Harness folder

function MQC_Harness_1(~)
  close all
  bdclose all
  mdl = "MotorDriveUnit_harness_model";
  load_system(mdl)
  sim(mdl);
  close all
  bdclose all
end

function MQC_Harness_2(~)
  close all
  bdclose all
  MotorDriveUnit_harness_setup
  close all
  bdclose all
end

%% Notes folder

function MQC_Notes_1(~)
  close all
  bdclose all
  MotorDriveUnit_note_Efficiency_Basic
  close all
  bdclose all
end

function MQC_Notes_2(~)
  close all
  bdclose all
  MotorDriveUnit_note_Efficiency_BasicThermal
  close all
  bdclose all
end

%% TestCases folder

function MQC_TestCases_1(~)
  close all
  bdclose all
  MotorDriveUnit_testcase_Constant
  close all
  bdclose all
end

function MQC_TestCases_2(~)
  close all
  bdclose all
  MotorDriveUnit_testcase_Drive
  close all
  bdclose all
end

function MQC_TestCases_3(~)
  close all
  bdclose all
  MotorDriveUnit_testcase_Random
  close all
  bdclose all
end

function MQC_TestCases_4(~)
  close all
  bdclose all
  MotorDriveUnit_testcase_RegenBrake
  close all
  bdclose all
end

%% Utility folder

function MQC_Utility_1(~)
% Test target is a function which uses gcb as a default argument.
% To test it, a model must be loaded, and
% a proper block must be selected so that gcb can work as expected.
  close all
  bdclose all
  mdl = "MotorDriveUnit_harness_model";
  load_system(mdl)
  % Use proper referenced subsystem.
  set_param(mdl+"/Motor Drive Unit", ...
    ReferencedSubsystem = "MotorDriveUnit_refsub_Basic")
  % Select subsystem.
  set_param(0, CurrentSystem = mdl+"/Motor Drive Unit")
  % Select block.
  set_param(gcs, CurrentBlock = "Motor & Drive (Driveline)")
  % Test this function:
  MotorDriveUnit_getBlockInfo_Basic;
  close all
  bdclose all
end

function MQC_Utility_2(~)
  close all
  bdclose all
  MotorDriveUnit_plotEfficiency
  close all
  bdclose all
end

function MQC_Utility_3(~)
  close all
  bdclose all
  MotorDriveUnit_plotEfficiency_Basic
  close all
  bdclose all
end

% MotorDriveUnit_plotResults
% cannot run by itself, but it is called from live scripts.

end  % methods (Test)
end  % classdef
