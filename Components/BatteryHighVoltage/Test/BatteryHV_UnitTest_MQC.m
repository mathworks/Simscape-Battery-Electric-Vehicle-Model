classdef BatteryHV_UnitTest_MQC < BEVTestCase
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
    mdl = "BatteryHV_harness_model";
    load_system(mdl)
    useRefSubFunction()
    loadSimulationCaseFunction()
    sim(mdl);
  end  % function
end  % methods

%% Simple tests ... just run runnables

methods (Test)

%% Harness folder

function MQC_Harness_2(~)
  mdl = "BatteryHV_harness_model";
  load_system(mdl)
  BatteryHV_useRefsub_Basic;
  BatteryHV_loadSimulationCase_Charge( ...
    CRate = -1, ...  Negative value for charge
    StateOfCharge_pct = 0 );
  sim(mdl);
end

function MQC_Harness_3(~)
  mdl = "BatteryHV_harness_model";
  load_system(mdl)
  BatteryHV_useRefsub_Basic;
  BatteryHV_loadSimulationCase_Discharge( ...
    CRate = 1, ...  Positive value for discharge
    StateOfCharge_pct = 100 );
  sim(mdl);
end

function MQC_Harness_4(~)
  mdl = "BatteryHV_harness_model";
  load_system(mdl)
  BatteryHV_useRefsub_Basic;
  BatteryHV_loadSimulationCase_Random( ...
    RandomSeed = 124, ...
    NumTransitions = 10, ...
    InitialSOC_pct = 60 );
  sim(mdl);
end

%% Model-TableBased folder

function MQC_Model_TableBased_1(~)
  BatteryHV_TableBased_buildParameters
end

function MQC_Model_TableBased_2(~)
  BatteryHV_TableBased_visualizeParameters
end

%% Simulation Cases folder

function MQC_SimulationCase_1(~)
  BatteryHV_simulationCase_Charge
end

function MQC_SimulationCase_2(~)
  BatteryHV_simulationCase_Constant
end

function MQC_SimulationCase_3(~)
  BatteryHV_simulationCase_Discharge
end

function MQC_SimulationCase_4(~)
  BatteryHV_simulationCase_Random
end

%% Utility > Configuration folder

function MQC_Configuration_1(~)
  load_system("BatteryHV_harness_model")
  BatteryHV_loadSimulationCase
end

function MQC_Configuration_2(~)
  load_system("BatteryHV_harness_model")
  BatteryHV_loadSimulationCase_Charge
end

function MQC_Configuration_3(~)
  load_system("BatteryHV_harness_model")
  BatteryHV_loadSimulationCase_Constant
end

function MQC_Configuration_4(~)
  load_system("BatteryHV_harness_model")
  BatteryHV_loadSimulationCase_Discharge
end

function MQC_Configuration_5(~)
  load_system("BatteryHV_harness_model")
  BatteryHV_loadSimulationCase_Random
end

function MQC_Configuration_6(~)
  BatteryHV_setInitialConditions
end

function MQC_Configuration_7(~)
  load_system("BatteryHV_harness_model")
  BatteryHV_useRefsub
end

function MQC_Configuration_8(~)
  load_system("BatteryHV_harness_model")
  BatteryHV_useRefsub_Basic
end

function MQC_Configuration_9(~)
  load_system("BatteryHV_harness_model")
  BatteryHV_useRefsub_System
end

function MQC_Configuration_10(~)
  load_system("BatteryHV_harness_model")
  BatteryHV_useRefsub_SystemSimple
end

function MQC_Configuration_11(~)
  load_system("BatteryHV_harness_model")
  BatteryHV_useRefsub_SystemTable
end

%% Utility folder

% The `BatteryHV_buildOpenCircuitVoltageData` function is tested by
% running the `BatteryHV_TableBased_buildParameters` script.

% The `BatteryHV_buildTerminalResistanceData` function is tested by
% running the `BatteryHV_TableBased_buildParameters` script.

function MQC_Utility_1(~)
  BatteryHV_getAmpereHourRating
end

function MQC_Utility_2(~)
  BatteryHV_getBatteryPackParameters
end

% This test fails in R2023a. See more comments below.
function MQC_Utility_3(testCase)

  testCase.assumeNotEqual(matlabRelease.Release, "R2023a", ...
      "Test fails in R2023a. See comments in test.")
  load_system("BatteryHV_harness_model")

  % In the function below,
  % Simulink.SubsystemReference.getAllReferencedSubsystemBlockDiagrams
  % must return a char array, but it is empty in this test.
  BatteryHV_getReferencedSubsystemFilename

end


function MQC_Utility_4(~)
  load_system("BatteryHV_harness_model")
  BatteryHV_plotInput_LoadCurrent
end

function MQC_Utility_5(~)
  mdl = "BatteryHV_harness_model";
  load_system(mdl)
  simOut = sim(mdl);
  simData = extractTimetable(simOut.logsout);
  % Test target:
  BatteryHV_plotResults(simData);
end

%% Top folder

function MQC_TopFolder_1(~)
  BatteryHV_main_script
end

function MQC_TopFolder_2(~)
  BatteryHV_refsub_Basic_params
end

function MQC_TopFolder_3(~)
  BatteryHV_refsub_System_params
end

function MQC_TopFolder_4(~)
  BatteryHV_refsub_SystemSimple_params
end

function MQC_TopFolder_5(~)
  BatteryHV_refsub_SystemTable_params
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
    mdl = "BatteryHV_harness_model";
    load_system(mdl)
    checkCallbackButton(mdl, testCase.FilesAndFolders)
  end  % function
end  % methods

end  % classdef
