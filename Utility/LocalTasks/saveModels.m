function saveModels
%% Saves model files in the current MATLAB release.
% This function finds model files (*.mdl and *.slx) in the current project,
% then one by one, opens the model, set dirty mark, and saves it. 
% Use this function to save old model files in the current MATLAB release.
% This function has been confirmd to work with
% system models, referenced subsystems, and libraries.
% If the model is already saved in the current MATLAB release, it is skipped.

% Copyright 2023 The MathWorks, Inc.

thisMatlabRelease = matlabRelease().Release;
disp("This is MATLAB " + thisMatlabRelease + ".")

prj = currentProject;

prjRoot = prj.RootFolder;

allFilesFullPath = prj.Files;
allFilesFullPath = [allFilesFullPath(:).Path]';

allFilesRelPath = extractAfter(allFilesFullPath, prjRoot + ("/"|"\"));

lix = endsWith(allFilesFullPath, (".mdl"|".slx"));

modelFilesRelPath = allFilesRelPath(lix);
modelFilesFullPath = allFilesFullPath(lix);

numModelFiles = numel(modelFilesRelPath);
disp("Number of model files found: " + numModelFiles)

for idx = 1 : numModelFiles
  disp("[" + idx + "/" + numModelFiles + "] " + modelFilesRelPath(idx))
  targetModelFile = modelFilesFullPath(idx);
  modelInfo = Simulink.MDLInfo(targetModelFile);
  modelSavedInRelease = string(modelInfo.ReleaseName);
  [~, baseFilename, ~] = fileparts(targetModelFile);
  if modelSavedInRelease ~= thisMatlabRelease
    load_system(targetModelFile)
    if bdIsLibrary(baseFilename)
      set_param(baseFilename, Lock="off")
    end
    set_param(baseFilename, Dirty="on")
    save_system(baseFilename)
    disp("saved.")
  else
    disp("skipped. Model file is up to date with this MATLAB release.")
  end
  bdclose(baseFilename)
end

end  % function
