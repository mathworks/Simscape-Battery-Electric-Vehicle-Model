function NumConversions = batchGenerateMarkdowns(NameValuePair)
% Batch-generate Markdown files from Live Scripts in the specified folders.
%
% This function finds ".m" and ".mlx" Live Script files
% in the specified folders and exports them to Markdown files.
%
% DryRun is true by default. Specify DryRun=false to actually do the conversion.
% With DryRun=true, this command displays the list of Live Scripts that are found
% in the specified LiveScriptFolderNames folders.
% With DryRun=false, this command returns the number of files converted.
%
% By default, all the generated Markdown files are saved in the "markdown" folder.
% Use the MarkdownFolderPath option to change the folder to save Markdown files.
%
% If an up-to-date Markdown file already exists for the corresponding file,
% no new Markdown file is generated. To always generate a Markdown file,
% specify ForceExport=true.

% Copyright 2024-2026 The MathWorks, Inc.

arguments (Input)
  NameValuePair.DryRun (1,1) logical = true
  NameValuePair.LiveScriptFolderNames (:,1) string {mustBeFolder} = pwd
  NameValuePair.IncludeSubfolders (1,1) logical = true
  NameValuePair.MarkdownFolderPath (1,1) string = "markdown"
  NameValuePair.DisplayInfo (1,1) logical = true
  NameValuePair.ForceExport (1,1) logical = false
end  % arguments

arguments (Output)
  % The number of converted Live Scripts
  NumConversions (1,1) {mustBeNonnegative}
end  % arguments

if NameValuePair.DryRun
  NameValuePair.DisplayInfo = true;

  disp("Dry run")

end  % if

display_info = NameValuePair.DisplayInfo;

NumConversions = 0;

num_folders = numel(NameValuePair.LiveScriptFolderNames);

for k = 1 : num_folders

  target_folder_path = NameValuePair.LiveScriptFolderNames(k);
  if display_info
    disp("Target folder: " + target_folder_path)
  end  % if

  % Find all Live Script files in the specified folder.

  if NameValuePair.IncludeSubfolders
    mlx_filenames = matlab.buildtool.io.FileCollection.fromPaths(fullfile(target_folder_path, "**", "*.mlx")).paths';
    m_file_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(target_folder_path, "**", "*.m"));
  else
    mlx_filenames = matlab.buildtool.io.FileCollection.fromPaths(fullfile(target_folder_path, "*.mlx")).paths';
    m_file_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(target_folder_path, "*.m"));
  end  % if

  % Use the select to filter files.
  % https://www.mathworks.com/help/matlab/ref/matlab.buildtool.io.filecollection.select.html
  m_filenames = select(m_file_collection, @(p) FileUtil1.isPlainTextLiveScript(p)).paths';

  livescript_fullpaths = sort([mlx_filenames(:); m_filenames(:)]);

  if numel(livescript_fullpaths) == 0
    if display_info
      disp("No Live Script was found in the target folder.")
    end  % if

    continue

  else
    if display_info
      disp("Live Scripts:")
      disp(livescript_fullpaths)
    end  % if
  end  % if

  if NameValuePair.DryRun

    continue

  end  % if

  exported = FileUtil1.generateMarkdownsFromLiveScripts( ...
    livescript_fullpaths, ...
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

if nargout == 0
  clear NumConversions
end  % if
end  % function
