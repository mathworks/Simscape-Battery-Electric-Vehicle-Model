function NumConversions = batchGenerateMarkdowns(NameValuePair)
%% Batch-generate Markdown files from project-registered Live Scripts in specified folder
% This function finds project-registered ".m" and ".mlx" Live Script files
% in the specified folder and exports them to Markdown files.
% Files that are not registered in MATLAB project are skipped.
%
% By default, all the generated Markdown files are saved in the "markdown" folder.
% Use MarkdownFolderPath option to change the folder to save Markdown files.
%
% If an up-to-date Markdown file already exists for the corresponding file,
% no new Markdown file is generated. To always generate a Markdown file,
% set ForceExport option to true.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Input)
  NameValuePair.LiveScriptFolderNames (:,1) string {mustBeFolder} = pwd
  NameValuePair.MarkdownFolderPath (1,1) string = "markdown"
  NameValuePair.DisplayInfo (1,1) logical = true
  NameValuePair.ForceExport (1,1) logical = false
end  % arguments

arguments (Output)
  % The number of converted Live Scripts
  NumConversions (1,1) {mustBeNonnegative}
end  % arguments

display_info = NameValuePair.DisplayInfo;

project_files = currentProject().Files';
project_file_paths = [project_files.Path]';

NumConversions = 0;

num_folders = numel(NameValuePair.LiveScriptFolderNames);

for k = 1 : num_folders

  target_folder_path = NameValuePair.LiveScriptFolderNames(k);
  if display_info
    disp("# Target folder: " + target_folder_path)
  end  % if

  % Find all Live Script files in the specified folder.
  files = dir(target_folder_path);
  filenames = string({files(:).name})';
  logical_index = FileTool1.isLiveScript(filenames);
  livescript_filenames = filenames(logical_index);
  if numel(livescript_filenames) == 0
    if display_info
      disp("No Live Script was found in the target folder.")
    end  % if

    continue

  else
    if display_info
      str = join(livescript_filenames, ", ");
      disp("Live Scripts were found: " + str)
    end  % if
  end  % if

  % Check if the found Live Scripts are registered in the project.
  logical_index = endsWith(project_file_paths, livescript_filenames);
  targetfile_fullpaths = project_file_paths(logical_index);
  if all(logical_index == false)
    if display_info
      disp("No project-registered Live Script was found in the target folder.")
    end  % if

    continue

  else
    if display_info
      str = join(targetfile_fullpaths, newline);
      disp("Project-registered: " + newline + str + newline)
    end  % if
  end  % if

  exported = FileTool1.generateMarkdownsFromLiveScripts( ...
    targetfile_fullpaths, ...
    MarkdownFolderPath = NameValuePair.MarkdownFolderPath, ...
    DisplayInfo = display_info, ...
    ForceExport = NameValuePair.ForceExport );

  num_exported = nnz(exported);
  NumConversions = NumConversions + num_exported;

  if display_info
    if num_exported == 1
      disp("1 Live Script was exported.")
    elseif num_exported > 1
      disp(num_exported + " Live Scripts were exported to Markdown files.")
    end  % if
  end  % if
end  % for
end  % function
