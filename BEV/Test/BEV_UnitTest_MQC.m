classdef BEV_UnitTest_MQC < matlab.unittest.TestCase
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

% Copyright 2022-2023 The MathWorks, Inc.

methods (Test)

%% Top folder

function MQC_TopFolder_1(~)
  close all
  bdclose all
  BEV_main_script
  close all
  bdclose all
end

function MQC_TopFolder_2(~)
  close all
  bdclose all
  mdl = "BEV_system_model";
  load_system(mdl)
  BEV_setup
  close all
  bdclose all
end

function MQC_TopFolder_3(~)
  close all
  bdclose all
  mdl = "BEV_system_model";
  load_system(mdl)
  sim(mdl);
  close all
  bdclose all
end

%% SimlationCases folder

function MQC_SimulationCases_1_1(~)
  close all
  bdclose all
  BEV_simulationCase_Constant_Basic
  close all
  bdclose all
end

function MQC_SimulationCases_1_2(~)
  close all
  bdclose all
  BEV_simulationCase_FTP75_Basic
  close all
  bdclose all
end

function MQC_SimulationCases_1_3(~)
  close all
  bdclose all
  BEV_simulationCase_HighSpeed_Basic
  close all
  bdclose all
end

function MQC_SimulationCases_1_4(~)
  close all
  bdclose all
  BEV_simulationCase_SimpleDrivePattern_Basic
  close all
  bdclose all
end

function MQC_SimulationCases_1_5(~)
  close all
  bdclose all
  BEV_simulationCase_WLTP_Basic
  close all
  bdclose all
end

function MQC_SimulationCases_2_1(~)
  close all
  bdclose all
  BEV_simulationCase_Constant_Thermal
  close all
  bdclose all
end

function MQC_SimulationCases_2_2(~)
  close all
  bdclose all
  BEV_simulationCase_SimpleDrivePattern_Thermal
  close all
  bdclose all
end

%% Utility > Configuration folder

function MQC_Configuration_1(~)
  close all
  bdclose all
  load_system("BEV_system_model")
  BEV_useComponents_Basic
  close all
  bdclose all
end

function MQC_Configuration_2(~)
  close all
  bdclose all
  load_system("BEV_system_model")
  BEV_useComponents_Thermal
  close all
  bdclose all
end

%% Utility folder

function MQC_Utility_1(~)
  close all
  bdclose all
  BEV_getMotorSpeedFromVehicleSpeed
  close all
  bdclose all
end

function MQC_Utility_2(~)
  close all
  bdclose all
  mdl = "BEV_system_model";
  load_system(mdl)
  simOut = sim(mdl);
  simData = extractTimetable(simOut.logsout);
  % Test target
  BEV_plotResultsCompact(SimData = simData);
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
%%
  projectFiles = [currentProject().Files.Path]';
  % logical index
  lix = not(contains(projectFiles, [".git", "resources", "simcache"]));
  testCase.FilesAndFolders = projectFiles(lix);
end  % function

end  % methods

methods (Test)

function MQC_CallbackButtons_1(testCase)
  close all
  bdclose all
  mdl = "BEV_system_model";
  load_system(mdl)
  checkCallbackButton(mdl, testCase.FilesAndFolders)
  close all
  bdclose all
end

end  % methods

end  % classdef
