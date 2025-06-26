function NumConversions = batchGenerateMarkdowns(NameValuePair)
%% Batch-generate Markdown files from project-registered Live Scripts in specified folder

% This function finds project-registered ".m" and ".mlx" files
% in the specified folder and exports them to Markdown files.
% Files that are not registered in MATLAB project are skipped.
%
% By default, all the generated Markdown files are saved in the "markdown" folder.
% Use MarkdownFolderPath option to change the folder to save Markdown files.
%
% If an up-to-date Markdown file already exists for the corresponding file,
% no new Markdown file is generated. To generate a Markdown file,
% set ForceExport option to true.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Input)
  NameValuePair.LiveScriptFolderNames (:,1) string {mustBeFolder} = pwd
  NameValuePair.MarkdownFolderPath (1,1) string = "markdown"
  NameValuePair.ForceExport (1,1) logical = false
  NameValuePair.DisplayInfo (1,1) logical = true
end  % arguments

arguments (Output)
  NumConversions (1,1) {mustBeNonnegative}
end  % arguments

display_info = NameValuePair.DisplayInfo;

project_files = currentProject().Files';
project_file_paths = [project_files.Path]';

NumConversions = 0;

num_folders = numel(NameValuePair.LiveScriptFolderNames);

for k = 1 : num_folders

  live_script_folder_path = NameValuePair.LiveScriptFolderNames(k);

  if not(endsWith(live_script_folder_path, filesep))
    live_script_folder_path = live_script_folder_path + filesep;
  end  % if

  % Get the list of project files in the specified folder and its subfolders.
  logical_index = startsWith(project_file_paths, live_script_folder_path);
  all_project_files_in_live_script_folder = project_file_paths(logical_index);

  % Get *.m and *.mlx files that are in the k-th specified folder.
  % Don't get those files that are in the subfolders of the target folder.
  logical_index = FileTool.isLiveScript(all_project_files_in_live_script_folder) ...
    & not(startsWith(all_project_files_in_live_script_folder, live_script_folder_path + wildcardPattern(1,inf) + filesep));

  livescript_fullpaths = all_project_files_in_live_script_folder(logical_index);

  num_files = numel(livescript_fullpaths);
  if num_files == 0
    if display_info
      disp("No project-registered Live Script was found in " + live_script_folder_path)
    end  % if
    continue
  end  % if

  if display_info
    disp(">>> Exporting live scripts in the folder: " + live_script_folder_path)
    if num_files == 1
      disp(">>> 1 Live Script was found.")
    elseif num_files > 1
      disp(">>> " + num_files + " Live Scripts were found.")
    end  % if
  end  % if

  exported = FileTool.generateMarkdownsFromLiveScripts( ...
    livescript_fullpaths, ...
    MarkdownFolderPath = NameValuePair.MarkdownFolderPath, ...
    ForceExport = NameValuePair.ForceExport, ...
    DisplayInfo = display_info );

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
