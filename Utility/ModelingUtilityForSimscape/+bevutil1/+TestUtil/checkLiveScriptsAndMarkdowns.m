function ResultTable = checkLiveScriptsAndMarkdowns(LiveScriptFolder, NameValuePair)
% Check that Markdown files exist for Live Scripts in the specified folders.
%
% This function returns a table containing the result of check for each Live Script file.

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  LiveScriptFolder (1,1) string {mustBeFolder} = pwd

  % A folder to store Markdown files.
  NameValuePair.MarkdownFolder (1,1) string {mustBeFolder} = fullfile(pwd, "markdown")
end  % arguments

arguments (Output)
  ResultTable table
end  % arguments

markdown_folder = NameValuePair.MarkdownFolder;

% -----------------------------------------------------------------------------
% MLX Live Scripts

mlx_file_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(LiveScriptFolder, "*.mlx"));
[~, base_file_name, ~] = fileparts(mlx_file_collection.paths');

LiveScript = base_file_name + ".mlx";

markdown_files_from_mlx_files = fullfile(markdown_folder, base_file_name + ".md");
HasMarkdown = isfile(markdown_files_from_mlx_files);

tbl_mlx = table(LiveScript, HasMarkdown);

% -----------------------------------------------------------------------------
% Live M Scripts

live_m_file_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(LiveScriptFolder, "*.m"));

% Select Live-M Scripts.
% https://www.mathworks.com/help/matlab/ref/matlab.buildtool.io.filecollection.select.html
live_m_file_collection = select(live_m_file_collection, @(p) bevutil1.FileUtil.isPlainTextLiveScript(p));

[~, base_file_name, ~] = fileparts(live_m_file_collection.paths');

LiveScript = base_file_name + ".m";

markdown_files_from_live_m_files = fullfile(markdown_folder, base_file_name + ".md");
HasMarkdown = isfile(markdown_files_from_live_m_files);

tbl_m = table(LiveScript, HasMarkdown);

% actual_live_m = nnz(file_exists);

% -----------------------------------------------------------------------------

ResultTable = sortrows(vertcat(tbl_mlx, tbl_m), "LiveScript");

% actual = actual_mlx + actual_live_m;
% expected = numel(mlx_file_collection.paths) + numel(live_m_file_collection.paths);
end  % function
