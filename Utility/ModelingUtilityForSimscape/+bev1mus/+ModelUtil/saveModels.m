function [NumModels, InfoTable] = saveModels(NameValuePair)
% Save model files in the current MATLAB release.
%
% This function finds model files (*.mdl and *.slx) under the specified folder,
% checks if they are saved in the current MATLAB release, and save those that are not.
% It is assumed that the model files are saved in an older release or the release
% this function is running.
% Use this function to save old model files in the current MATLAB release.
% This function works with system models, referenced subsystems, and libraries.
%
% This function returns the number of files that were saved.
%
% Set DryRun to true to avoid the save operation.
% This function still returns the number of model files to be saved.

% Copyright 2023-2025 The MathWorks, Inc.

arguments (Input)

  NameValuePair.DryRun (1,1) logical = true

  NameValuePair.Target (1,1) string {mustBeMember(NameValuePair.Target, ["FolderTree", "Project"])} = "FolderTree"

  NameValuePair.SpecifyTopFolder (1,1) logical = false
  NameValuePair.TopFolder (1,1) string {mustBeFolder} = string(pwd)

  NameValuePair.DisplayInfo (1,1) logical = true
end  % arguments

arguments (Output)

  NumModels {mustBeScalarOrEmpty, mustBeInteger, mustBeNonnegative}

  InfoTable (:, 2) table

end  % argument

errorID = "saveModels:";

this_matlab_release = matlabRelease().Release;
if NameValuePair.DisplayInfo
  disp("This is MATLAB " + this_matlab_release + ".")
end  % if

if NameValuePair.Target == "FolderTree"
  if NameValuePair.SpecifyTopFolder
    topfolder = NameValuePair.TopFolder;
  else
    topfolder = string(pwd);
  end  % if

  mdlfiles_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(topfolder, "**/*.mdl"));
  slxfiles_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(topfolder, "**/*.slx"));

  modelfiles_fullpath = [mdlfiles_collection.paths'; slxfiles_collection.paths'];

else
  % Target == "Project"
  if NameValuePair.SpecifyTopFolder
    topfolder = NameValuePair.TopFolder;
    if not(startsWith(topfolder, currentProject().RootFolder))
      id = errorID + "InvalidTopFolder";
      msg = bev1mus.CodeUtil.i18n("Top folder must be within the project root folder.");

      throw(MException(id, msg))

    end  % if
  else
    topfolder = currentProject().RootFolder;
  end  % if

  allfiles_fullpath = currentProject().Files;
  allfiles_fullpath = [allfiles_fullpath(:).Path]';

  logical_index = startsWith(allfiles_fullpath, topfolder);
  allfiles_fullpath = allfiles_fullpath(logical_index);

  logical_index = endsWith(allfiles_fullpath, (".mdl"|".slx"));
  modelfiles_fullpath = allfiles_fullpath(logical_index);

end  % if

modelfiles_relpath = extractAfter(modelfiles_fullpath, topfolder + ("/"|"\"));

num_modelfiles = numel(modelfiles_relpath);
if NameValuePair.DisplayInfo
  disp("Number of model files found: " + num_modelfiles)
end  % if

if NameValuePair.DryRun && NameValuePair.DisplayInfo
  disp("This is dry run.")
end  % if

to_be_saved = false(num_modelfiles, 1);
for ii = 1 : num_modelfiles
  target = modelfiles_fullpath(ii);
  model_info = Simulink.MDLInfo(target);
  model_release = string(model_info.ReleaseName);
  if model_release ~= this_matlab_release
    to_be_saved(ii) = true;
  end  % if
end  % for

InfoTable = table(to_be_saved, modelfiles_relpath);

NumModels = nnz(to_be_saved);

if NumModels == 0
  if NameValuePair.DisplayInfo
    disp("All model files were already saved in this MATLAB release.")
  end  % if

  return

end  % if

targetfiles_relpath = modelfiles_relpath(to_be_saved);
targetfiles_fullpath = modelfiles_fullpath(to_be_saved);
num_targets = numel(targetfiles_fullpath);

if NameValuePair.DisplayInfo
  for ii = 1 : num_targets
    target = targetfiles_relpath(ii);
    disp("[" + ii + "/" + num_targets + "] " + target)
  end  % for
end  % if

if NameValuePair.DryRun

  return

end  % if

% Dry run ends here.
% -----------------------------------------------------------------------------

for ii = 1 : num_targets
  target = targetfiles_fullpath(ii);
  [~, model_name, ~] = fileparts(target);
  load_system(model_name)
  if bdIsLibrary(model_name)
    set_param(model_name, Lock="off")
  end  % if
  set_param(model_name, Dirty="on")
  save_system(model_name)
  bdclose(model_name)
  if NameValuePair.DisplayInfo
    disp("Saved: " + model_name)
  end  % if
end  % for
end  % function
