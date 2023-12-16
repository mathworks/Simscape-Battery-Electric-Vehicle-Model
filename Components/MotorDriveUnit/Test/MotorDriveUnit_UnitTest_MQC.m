classdef MotorDriveUnit_UnitTest_MQC < BEVTestCase
%% Class implementation of unit test
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

%% Test combinations of battery models and simulation cases

properties (TestParameter)
  useRefSubFunction = {
    @MotorDriveUnit_useRefsub_Basic
    @MotorDriveUnit_useRefsub_BasicThermal
    @MotorDriveUnit_useRefsub_System
    @MotorDriveUnit_useRefsub_SystemTable
    }
  loadSimulationCaseFunction = {
    @MotorDriveUnit_loadSimulationCase_Constant
    @MotorDriveUnit_loadSimulationCase_Drive
    @MotorDriveUnit_loadSimulationCase_Random
    @MotorDriveUnit_loadSimulationCase_RegenBrake
    }
end

methods (Test)
  function MQC_Harness_combination_1(~, useRefSubFunction, loadSimulationCaseFunction)
    mdl = "MotorDriveUnit_harness_model";
    load_system(mdl)
    useRefSubFunction()
    loadSimulationCaseFunction()
    sim(mdl);
  end  % function
end  % methods

%% Simple tests ... just run runnables

methods (Test)

%% Component's top folder

function MQC_TopFolder_1(~)
  MotorDriveUnit_refsub_Basic_params
end

function MQC_TopFolder_2(~)
  MotorDriveUnit_refsub_BasicThermal_params
end

function MQC_TopFolder_3(~)
  MotorDriveUnit_refsub_System_params
end

function MQC_TopFolder_4(~)
  MotorDriveUnit_refsub_SystemTable_params
end

%% Configuration folder

function MQC_Configurarion_loadSim_1(~)
  mdl = "MotorDriveUnit_harness_model";
  load_system(mdl)
  MotorDriveUnit_loadSimulationCase
end

function MQC_Configurarion_loadSim_2(~)
  mdl = "MotorDriveUnit_harness_model";
  load_system(mdl)
  MotorDriveUnit_loadSimulationCase_Constant
end

function MQC_Configurarion_loadSim_3(~)
  mdl = "MotorDriveUnit_harness_model";
  load_system(mdl)
  MotorDriveUnit_loadSimulationCase_Drive
end

function MQC_Configurarion_loadSim_4(~)
  mdl = "MotorDriveUnit_harness_model";
  load_system(mdl)
  MotorDriveUnit_loadSimulationCase_Random
end

function MQC_Configurarion_loadSim_5(~)
  mdl = "MotorDriveUnit_harness_model";
  load_system(mdl)
  MotorDriveUnit_loadSimulationCase_RegenBrake
  end

function MQC_Configurarion_setInit(~)
  MotorDriveUnit_setInitialConditions
end

function MQC_Configurarion_useRefsub_1(~)
  MotorDriveUnit_useRefsub
 end

function MQC_Configurarion_useRefsub_2(~)
  MotorDriveUnit_useRefsub_Basic
end

function MQC_Configurarion_useRefsub_3(~)
  MotorDriveUnit_useRefsub_BasicThermal
end

function MQC_Configurarion_useRefsub_4(~)
  MotorDriveUnit_useRefsub_System
end

function MQC_Configurarion_useRefsub_5(~)
  MotorDriveUnit_useRefsub_SystemTable
end

%% Harness folder

function MQC_Harness_1(~)
  mdl = "MotorDriveUnit_harness_model";
  load_system(mdl)
  sim(mdl);
end

function MQC_Harness_2(~)
  MotorDriveUnit_harness_setup
end

%% Notes folder

function MQC_Notes_1(~)
  MotorDriveUnit_note_Efficiency_Basic
end

function MQC_Notes_2(~)
  MotorDriveUnit_note_Efficiency_System
end

%% TestCases folder

function MQC_TestCases_1(~)
  MotorDriveUnit_simulationCase_Constant
end

function MQC_TestCases_2(~)
  MotorDriveUnit_simulationCase_Drive
end

function MQC_TestCases_3(~)
  MotorDriveUnit_simulationCase_Random
end

function MQC_TestCases_4(~)
  MotorDriveUnit_simulationCase_RegenBrake
end

%% Utility folder

function MQC_Utility_1(~)
% Test target is a function which uses gcb as a default argument.
% To test it, a model must be loaded, and
% a proper block must be selected so that gcb can work as expected.
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
end

function MQC_Utility_2(~)
  MotorDriveUnit_plotEfficiency
end

function MQC_Utility_3(~)
  MotorDriveUnit_plotEfficiency_Basic
end

% MotorDriveUnit_plotResults
% cannot run by itself, but it is called from live scripts.

end  % methods (Test)

%% Test callback buttons

properties
  FilesAndFolders {mustBeText} = ""
end

methods (TestClassSetup)
  function buildFilesFoldersList(testCase)
    projectFiles = [currentProject().Files.Path]';
    folderChar = characterListPattern("/\");
    ptn = "Components" + folderChar + "MotorDriveUnit" + folderChar;
    % logical index
    lix = contains(projectFiles, ptn);
    testCase.FilesAndFolders = projectFiles(lix);
  end  % function
end  % methods

methods (Test)
  function MQC_CallbackButtons_1(testCase)
    mdl = "MotorDriveUnit_harness_model";
    load_system(mdl)
    checkCallbackButton(mdl, testCase.FilesAndFolders)
  end  % function
end  % methods

end  % classdef
