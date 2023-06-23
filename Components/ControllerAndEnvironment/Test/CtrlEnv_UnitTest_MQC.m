classdef CtrlEnv_UnitTest_MQC < matlab.unittest.TestCase
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

% Copyright 2023 The MathWorks, Inc.

methods (Test)

%% Harness folder

function MQC_Harness_1(~)
  close all
  bdclose all
  mdl = "CtrlEnv_harness_model";
  load_system(mdl)
  sim(mdl);
  close all
  bdclose all
end

function MQC_Harness_2(~)
  close all
  bdclose all
  CtrlEnv_harness_setup
  close all
  bdclose all
end

%% SimulationCases folder

function MQC_SimulationCase_1(~)
  close all
  bdclose all
  CtrlEnv_simulationCase_Constant
  close all
  bdclose all
end

function MQC_SimulationCase_2(~)
  close all
  bdclose all
  CtrlEnv_simulationCase_FTP75
  close all
  bdclose all
end

function MQC_SimulationCase_3(~)
  close all
  bdclose all
  CtrlEnv_simulationCase_HighSpeed
  close all
  bdclose all
end

function MQC_SimulationCase_4(~)
  close all
  bdclose all
  CtrlEnv_simulationCase_SimpleDrivePattern
  close all
  bdclose all
end

function MQC_SimulationCase_5(~)
  close all
  bdclose all
  CtrlEnv_simulationCase_WLTP
  close all
  bdclose all
end

%% Utility > Configuration folder

function MQC_Configuration_1(~)
  close all
  bdclose all
  load_system("CtrlEnv_harness_model")
  CtrlEnv_loadSimulationCase
  close all
  bdclose all
end

function MQC_Configuration_2(~)
  close all
  bdclose all
  load_system("CtrlEnv_harness_model")
  CtrlEnv_loadSimulationCase_Constant
  close all
  bdclose all
end

function MQC_Configuration_3(~)
  close all
  bdclose all
  load_system("CtrlEnv_harness_model")
  CtrlEnv_loadSimulationCase_FTP75
  close all
  bdclose all
end

function MQC_Configuration_4(~)
  close all
  bdclose all
  load_system("CtrlEnv_harness_model")
  CtrlEnv_loadSimulationCase_HighSpeed
  close all
  bdclose all
end

function MQC_Configuration_5(~)
  close all
  bdclose all
  load_system("CtrlEnv_harness_model")
  CtrlEnv_loadSimulationCase_SimpleDrivePattern
  close all
  bdclose all
end

function MQC_Configuration_6(~)
  close all
  bdclose all
  load_system("CtrlEnv_harness_model")
  CtrlEnv_loadSimulationCase_WLTP
  close all
  bdclose all
end

%% Utility folder

function MQC_Utility_1(~)
  close all
  bdclose all
  mdl = "CtrlEnv_harness_model";
  load_system(mdl)
  simOut = sim(mdl);
  simData = extractTimetable(simOut.logsout);
  CtrlEnv_plotResults( SimData = simData );
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
    ptn = "Components" + folderChar + "ControllerAndEnvironment" + folderChar;
    % logical index
    lix = contains(projectFiles, ptn);
    testCase.FilesAndFolders = projectFiles(lix);
  end  % function
end  % methods

methods (Test)
  function MQC_CallbackButtons_1(testCase)
    close all
    bdclose all
    mdl = "CtrlEnv_harness_model";
    load_system(mdl)
    checkCallbackButton(mdl, testCase.FilesAndFolders)
    close all
    bdclose all
  end  % function
end  % methods

end  % classdef
