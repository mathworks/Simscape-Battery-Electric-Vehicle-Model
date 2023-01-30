classdef BEVProject_UnitTest_MQC < matlab.unittest.TestCase
%% Class implementation of unit test

% Copyright 2023 The MathWorks, Inc.

properties
  FilesAndFolders {mustBeText} = ""
end  % properties

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

end  % methods (Test)
end  % classdef
