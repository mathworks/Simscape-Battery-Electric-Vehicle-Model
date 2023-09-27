classdef BEV_UnitTest_MQC < BEVTestCase
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
  BEV_main_script
end

function MQC_TopFolder_2(~)
  mdl = "BEV_system_model";
  load_system(mdl)
  BEV_setup
end

function MQC_TopFolder_3(~)
  mdl = "BEV_system_model";
  load_system(mdl)
  sim(mdl);
end

%% SimlationCases folder

function MQC_SimulationCases_1_1(~)
  BEV_simulationCase_Constant_Basic
end

function MQC_SimulationCases_1_2(~)
  BEV_simulationCase_FTP75_Basic
end

function MQC_SimulationCases_1_3(~)
  BEV_simulationCase_HighSpeed_Basic
end

function MQC_SimulationCases_1_4(~)
  BEV_simulationCase_SimpleDrivePattern_Basic
end

function MQC_SimulationCases_1_5(~)
  BEV_simulationCase_WLTP_Basic
end

function MQC_SimulationCases_2_1(~)
  BEV_simulationCase_Constant_Thermal
end

function MQC_SimulationCases_2_2(~)
  BEV_simulationCase_SimpleDrivePattern_Thermal
end

%% Utility > Configuration folder

function MQC_Configuration_1(~)
  load_system("BEV_system_model")
  BEV_useComponents_Basic
end

function MQC_Configuration_2(~)
  load_system("BEV_system_model")
  BEV_useComponents_Thermal
end

%% Utility folder

function MQC_Utility_1(~)
  BEV_getMotorSpeedFromVehicleSpeed
end

function MQC_Utility_2(~)
  mdl = "BEV_system_model";
  load_system(mdl)
  simOut = sim(mdl);
  simData = extractTimetable(simOut.logsout);
  % Test target
  BEV_plotResultsCompact(SimData = simData);
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
  mdl = "BEV_system_model";
  load_system(mdl)
  checkCallbackButton(mdl, testCase.FilesAndFolders)
end

end  % methods

end  % classdef
