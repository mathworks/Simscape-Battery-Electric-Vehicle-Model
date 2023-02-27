classdef BatteryHV_UnitTest_MQC < matlab.unittest.TestCase
%% Class implementation of unit test
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

%% Test combinations of battery models and simulation cases

properties (TestParameter)
  useRefSubFunction = {
    @BatteryHV_useRefsub_Basic
    @BatteryHV_useRefsub_SystemSimple
    @BatteryHV_useRefsub_System
    }
  loadSimulationCaseFunction = {
    @BatteryHV_loadSimulationCase_Constant
    @BatteryHV_loadSimulationCase_Charge
    @BatteryHV_loadSimulationCase_Discharge
    @BatteryHV_loadSimulationCase_Random
    }
end

methods (Test)
  function MQC_Harness_combination_1(~, useRefSubFunction, loadSimulationCaseFunction)
    close all
    bdclose all
    mdl = "BatteryHV_harness_model";
    load_system(mdl)
    useRefSubFunction()
    loadSimulationCaseFunction()
    sim(mdl);
    close all
    bdclose all
  end  % function
end  % methods

%% Simple tests ... just run runnables

methods (Test)

%% Harness folder

function MQC_Harness_2(~)
  close all
  bdclose all
  mdl = "BatteryHV_harness_model";
  load_system(mdl)
  BatteryHV_useRefsub_Basic;
  BatteryHV_loadSimulationCase_Charge( ...
    CRate = -1, ...  Negative value for charge
    StateOfCharge_pct = 0 );
  sim(mdl);
  close all
  bdclose all
end

function MQC_Harness_3(~)
  close all
  bdclose all
  mdl = "BatteryHV_harness_model";
  load_system(mdl)
  BatteryHV_useRefsub_Basic;
  BatteryHV_loadSimulationCase_Discharge( ...
    CRate = 1, ...  Positive value for discharge
    StateOfCharge_pct = 100 );
  sim(mdl);
  close all
  bdclose all
end

function MQC_Harness_4(~)
  close all
  bdclose all
  mdl = "BatteryHV_harness_model";
  load_system(mdl)
  BatteryHV_useRefsub_Basic;
  BatteryHV_loadSimulationCase_Random( ...
    RandomSeed = 124, ...
    NumTransitions = 10, ...
    InitialSOC_pct = 60 );
  sim(mdl);
  close all
  bdclose all
end

%% Model-TableBased folder

function MQC_Model_TableBased_1(~)
  close all
  bdclose all
  BatteryHV_TableBased_buildParameters
  close all
  bdclose all
end

function MQC_Model_TableBased_2(~)
  close all
  bdclose all
  BatteryHV_TableBased_visualizeParameters
  close all
  bdclose all
end

%% Simulation Cases folder

function MQC_SimulationCase_1(~)
  close all
  bdclose all
  BatteryHV_simulationCase_Charge
  close all
  bdclose all
end

function MQC_SimulationCase_2(~)
  close all
  bdclose all
  BatteryHV_simulationCase_Constant
  close all
  bdclose all
end

function MQC_SimulationCase_3(~)
  close all
  bdclose all
  BatteryHV_simulationCase_Discharge
  close all
  bdclose all
end

function MQC_SimulationCase_4(~)
  close all
  bdclose all
  BatteryHV_simulationCase_Random
  close all
  bdclose all
end

%% Utility > Configuration folder

function MQC_Configuration_1(~)
  close all
  bdclose all
  load_system("BatteryHV_harness_model")
  BatteryHV_loadSimulationCase
  close all
  bdclose all
end

function MQC_Configuration_2(~)
  close all
  bdclose all
  load_system("BatteryHV_harness_model")
  BatteryHV_loadSimulationCase_Charge
  close all
  bdclose all
end

function MQC_Configuration_3(~)
  close all
  bdclose all
  load_system("BatteryHV_harness_model")
  BatteryHV_loadSimulationCase_Constant
  close all
  bdclose all
end

function MQC_Configuration_4(~)
  close all
  bdclose all
  load_system("BatteryHV_harness_model")
  BatteryHV_loadSimulationCase_Discharge
  close all
  bdclose all
end

function MQC_Configuration_5(~)
  close all
  bdclose all
  load_system("BatteryHV_harness_model")
  BatteryHV_loadSimulationCase_Random
  close all
  bdclose all
end

function MQC_Configuration_6(~)
  close all
  bdclose all
  BatteryHV_setInitialConditions
  close all
  bdclose all
end

function MQC_Configuration_7(~)
  close all
  bdclose all
  load_system("BatteryHV_harness_model")
  BatteryHV_useRefsub
  close all
  bdclose all
end

function MQC_Configuration_8(~)
  close all
  bdclose all
  load_system("BatteryHV_harness_model")
  BatteryHV_useRefsub_Basic
  close all
  bdclose all
end

function MQC_Configuration_9(~)
  close all
  bdclose all
  load_system("BatteryHV_harness_model")
  BatteryHV_useRefsub_System
  close all
  bdclose all
end

function MQC_Configuration_10(~)
  close all
  bdclose all
  load_system("BatteryHV_harness_model")
  BatteryHV_useRefsub_SystemSimple
  close all
  bdclose all
end

function MQC_Configuration_11(~)
  close all
  bdclose all
  load_system("BatteryHV_harness_model")
  BatteryHV_useRefsub_SystemTable
  close all
  bdclose all
end

%% Utility folder

% The `BatteryHV_buildOpenCircuitVoltageData` function is tested by
% running the `BatteryHV_TableBased_buildParameters` script.

% The `BatteryHV_buildTerminalResistanceData` function is tested by
% running the `BatteryHV_TableBased_buildParameters` script.

function MQC_Utility_1(~)
  close all
  bdclose all
  BatteryHV_getAmpereHourRating
  close all
  bdclose all
end

function MQC_Utility_2(~)
  close all
  bdclose all
  BatteryHV_getBatteryPackParameters
  close all
  bdclose all
end

function MQC_Utility_3(~)
  close all
  bdclose all
  load_system("BatteryHV_harness_model")
  BatteryHV_getReferencedSubsystemFilename
  close all
  bdclose all
end

function MQC_Utility_4(~)
  close all
  bdclose all
  load_system("BatteryHV_harness_model")
  BatteryHV_plotInput_LoadCurrent
  close all
  bdclose all
end

function MQC_Utility_5(~)
  close all
  bdclose all
  mdl = "BatteryHV_harness_model";
  load_system(mdl)
  simOut = sim(mdl);
  simData = extractTimetable(simOut.logsout);
  % Test target:
  BatteryHV_plotResults(simData);
  close all
  bdclose all
end

%% Top folder

function MQC_TopFolder_1(~)
  close all
  bdclose all
  BatteryHV_main_script
  close all
  bdclose all
end

function MQC_TopFolder_2(~)
  close all
  bdclose all
  BatteryHV_refsub_Basic_params
  close all
  bdclose all
end

function MQC_TopFolder_3(~)
  close all
  bdclose all
  BatteryHV_refsub_System_params
  close all
  bdclose all
end

function MQC_TopFolder_4(~)
  close all
  bdclose all
  BatteryHV_refsub_SystemSimple_params
  close all
  bdclose all
end

function MQC_TopFolder_5(~)
  close all
  bdclose all
  BatteryHV_refsub_SystemTable_params
  close all
  bdclose all
end

end  % methods (Test)

%% Test callback buttons

properties
  FilesAndFolders {mustBeText} = ""
end

methods (TestClassSetup)
  function buildFilesFoldersList(testCase)
    projectFiles = [currentProject().Files.Path]';
    folderChar = characterListPattern("/\");
    ptn = "Components" + folderChar + "BatteryHighVoltage" + folderChar;
    % logical index
    lix = contains(projectFiles, ptn);
    testCase.FilesAndFolders = projectFiles(lix);
  end  % function
end  % methods

methods (Test)
  function MQC_CallbackButtons_1(testCase)
    close all
    bdclose all
    mdl = "BatteryHV_harness_model";
    load_system(mdl)
    checkCallbackButton(mdl, testCase.FilesAndFolders)
    close all
    bdclose all
  end  % function
end  % methods

end  % classdef
