function ResultTable = searchText(NameValuePair)
% Find text from text files.
%
% This function returns a table containing FilePath, LineNumber, and LineText.
% This function works with text files only.
%
% Options
%
% - DisplayInfo = true | false (default)
%
% To view information from within this function, set the DisplayInfo option to true.
%
% - TargetFolder = a folder to do text search, e.g., pwd, or "folder1".
%
% Specify the target folder to search files. Current folder is used by default.
% If TargetFolder=="", then the target folder for search is set to the current folder.
% The specified TargetFolder is stored in the returning table as a custom property.
% Access it as follows.
%   result = findTextAndReplace(...)
%   result.Properties.CustomProperties.TargetFolder
%
% - IncludeSubfolders = true | false (default)
%
% By default, file search is performed in the specified folder only.
% Set this option to true to search subfolders too.
%
% - FileTypes = string scalar or string array, e.g., ".m" or ["*.m", "*.mdl"]
%
% Use the FileTypes option to specify the patterns of file names to search.
% Files must be plain text format. For example, use
%   FileTypes = "*.m"
% to find text files ending with ".m" extension.
% FileTypes can take multiple patterns. For example, use
%   FileTypes = ["*_refsub.mdl", "testmodel_*.mdl"]
% to find text files matching these patterns.
%
% - Filter = @(x) filter_function(x)
%
% The FileTypes option works on the patterns of file names to build the list of target files.
% To further reduce the target files based on the contents of the files, use the Filter option.
% The Filter option takes a function handle. When this function calls the filter function,
% it receives a file name, and it must return true or false.
% This mechanism is a filter for the select function which works on the FileCollection object.
% See the documentation for details.
% https://www.mathworks.com/help/matlab/ref/matlab.buildtool.io.filecollection.select.html
%
% - SearchText = a string or a pattern, e.g., "search text", "("+wildcardPattern+")"
%
% Use the SearchText option to specify the text to search in the target files.
% This option is simply passed to the contains function and the replace function.
% You can specify text seatch pattern with this option only while ignoring
% the IgnoreCase option and the MatchWholeWord option that are provided for convenience.
%
% - IgnoreCase = true | false (default)
%
% Use the IgnoreCase option to control the case-sensitivity of the text search.
%
% - MatchWholeWord = true | false (default)
%
% Set the MatchWholeWord option to true to limit the text search to match
% the SearchText to whole words.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)

  NameValuePair.TargetFolder (:,1) string = pwd
  NameValuePair.IncludeSubfolders (1,1) logical = false

  % FileTypes overrides the Select*, Exclude*, and CustomFileTypes options.
  % Leave FileTypes "" to use the other selectors.
  % FileTypes is an array of string, e.g., ["*.m", "*.mdl"]
  NameValuePair.FileTypes (1,:) string {mustBeVector} = ""

  % If SelectAll=true, all other Select* options are ignored (and treated as true.)
  NameValuePair.SelectAll = false;
  NameValuePair.SelectMATLAB = false;
  NameValuePair.SelectMarkdown = false;
  NameValuePair.SelectSimulink = false;
  NameValuePair.SelectSimscape = false;
  NameValuePair.SelectSVG = false;
  % If FileTypes is specified, CustomFileTypes is ignored.
  % CustomFileTypes is an array of string, e.g., ["*.m", "*.mdl"]
  NameValuePair.CustomFileTypes (1,:) string {mustBeVector} = "";

  NameValuePair.ExcludeLiveScript (1,1) logical = false
  NameValuePair.ExcludeMATLABCodeFile (1,1) logical = false

  NameValuePair.IgnoreCase (1,1) logical = true
  NameValuePair.MatchWholeWord (1,1) logical = false
  NameValuePair.SearchText (1,1) pattern = ""

  NameValuePair.Filter (1,:) {CodeTool1.mustBeFunctionHandleOrEmpty} = []

  NameValuePair.IncludeStyledFilePath (1,1) logical = false

  NameValuePair.DisplayInfo (1,1) logical = false

end  % arguments

arguments (Output)
  ResultTable table {TextSearchTool1.mustBeTextSearchTable}
end  % arguments

errorId = "searchText:";

ResultTable = TextSearchTool1.newTextSearchTable;

% -----------------------------------------------------------------------------
% Determine file types to search

if NameValuePair.FileTypes ~= ""
  file_types = NameValuePair.FileTypes;
else
  if NameValuePair.SelectAll
    NameValuePair.SelectMATLAB = true;
    NameValuePair.SelectMarkdown = true;
    NameValuePair.SelectSimulink = true;
    NameValuePair.SelectSimscape = true;
    NameValuePair.SelectSVG = true;
  end  % if
  file_types = [];
  if NameValuePair.SelectMATLAB
    file_types = [file_types, "*.m"];
  end  % if
  if NameValuePair.SelectMarkdown
    file_types = [file_types, "*.md"];
  end  % if
  if NameValuePair.SelectSimulink
    file_types = [file_types, "*.mdl"];
  end  % if
  if NameValuePair.SelectSimscape
    file_types = [file_types, "*.ssc"];
  end  % if
  if NameValuePair.SelectSVG
    file_types = [file_types, "*.svg"];
  end  % if
  if NameValuePair.CustomFileTypes ~= ""
    file_types = [file_types, NameValuePair.CustomFileTypes];
  end  % if
end  % if

if isempty(file_types) || (isscalar(file_types) && file_types == "")
  id = errorId + "InvalidFileTypes";
  msg = CodeTool1.i18n("File types must be specified.");

  throw(MException(id, msg))

end  % if

% Make file_types a column vector by applying (:).
file_types = file_types(:);

if NameValuePair.IncludeSubfolders
  collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(NameValuePair.TargetFolder, "**", file_types));
else
  collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(NameValuePair.TargetFolder, file_types));
end  % if

if NameValuePair.DisplayInfo
  disp("Search files:")
  disp(collection)
end  % if

% -----------------------------------------------------------------------------
% File filters to apply
%
% Use the select function to apply filters to the collection. See the documentation for details.
% https://www.mathworks.com/help/matlab/ref/matlab.buildtool.io.filecollection.select.html

if NameValuePair.ExcludeLiveScript
  collection = select(collection, @(x) not(FileTool3.isPlainTextLiveScript(x)));
end  %if

if NameValuePair.ExcludeMATLABCodeFile
  collection = select(collection, @(x) endsWith(x, ".m") & FileTool3.isPlainTextLiveScript(x));
end  %if

if not(isempty(NameValuePair.Filter))
  collection = select(collection, @(x) NameValuePair.Filter(x));
end  % if

% -----------------------------------------------------------------------------
% Number of files found
found_files = paths(collection)';
num_files = numel(found_files);
if num_files == 0
  if NameValuePair.DisplayInfo
    disp("No files matched with specified file types.")
  end  % if

  return

end  % if

% -----------------------------------------------------------------------------
% First pass: Determine the number of rows necessary for a table.

if NameValuePair.MatchWholeWord
  b = (lineBoundary|textBoundary|whitespaceBoundary|alphanumericBoundary);
  search_text = b + NameValuePair.SearchText + b;
else
  search_text = NameValuePair.SearchText;
end  % if

file_path = strings(num_files, 1);

num_rows = 0;
for ii = 1 : num_files
  target_file = found_files(ii);
  lines = readlines(target_file);
  logical_index = contains(lines, search_text, IgnoreCase=NameValuePair.IgnoreCase);
  num_lines = nnz(logical_index);
  if num_lines == 0

    continue

  end  % if
  file_path(ii) = target_file;
  num_rows = num_rows + num_lines;
end  % for

if num_rows == 0
  if NameValuePair.DisplayInfo
    disp("Specified search text was not found.")
  end  % if

  return

end  % if

logical_index = file_path ~= "";
file_path = file_path(logical_index);

% -----------------------------------------------------------------------------
% Second pass: Build a table containing matched lines.

% Columns of the result table.
FilePath = strings(num_rows, 1);
LineNumber = nan(num_rows, 1);
LineText = strings(num_rows, 1);

num_files = numel(file_path);
cnt = 0;
for ii = 1 : num_files
  target_file = file_path(ii);
  lines = readlines(target_file);
  logical_index = contains(lines, search_text, IgnoreCase=NameValuePair.IgnoreCase);
  line_number = find(logical_index);
  line_text = lines(logical_index);
  for jj = 1 : numel(line_text)
    cnt = cnt + 1;
    if NameValuePair.TargetFolder == ""
      FilePath(cnt) = target_file;
    else
      FilePath(cnt) = extractAfter(target_file, NameValuePair.TargetFolder + ("/"|"\"));
    end  % if
    LineNumber(cnt) = line_number(jj);
    LineText(cnt) = line_text(jj);
  end  % for
end  % for

ResultTable = TextSearchTool1.newTextSearchTable(FilePath, LineNumber, LineText, ...
  IncludeStyledFilePath = NameValuePair.IncludeStyledFilePath);

ResultTable.Properties.CustomProperties.TargetFolder = NameValuePair.TargetFolder;
ResultTable.Properties.CustomProperties.IncludeSubfolders = NameValuePair.IncludeSubfolders;

ResultTable.Properties.CustomProperties.FileTypes = NameValuePair.FileTypes;

ResultTable.Properties.CustomProperties.SelectAll = NameValuePair.SelectAll;
ResultTable.Properties.CustomProperties.SelectMATLAB = NameValuePair.SelectMATLAB;
ResultTable.Properties.CustomProperties.ExcludeLiveScript = NameValuePair.ExcludeLiveScript;
ResultTable.Properties.CustomProperties.ExcludeMATLABCodeFile = NameValuePair.ExcludeMATLABCodeFile;
ResultTable.Properties.CustomProperties.SelectMarkdown = NameValuePair.SelectMarkdown;
ResultTable.Properties.CustomProperties.SelectSimulink = NameValuePair.SelectSimulink;
ResultTable.Properties.CustomProperties.SelectSimscape = NameValuePair.SelectSimscape;
ResultTable.Properties.CustomProperties.SelectSVG = NameValuePair.SelectSVG;
ResultTable.Properties.CustomProperties.CustomFileTypes = NameValuePair.CustomFileTypes;

ResultTable.Properties.CustomProperties.IgnoreCase = NameValuePair.IgnoreCase;
ResultTable.Properties.CustomProperties.MatchWholeWord = NameValuePair.MatchWholeWord;
ResultTable.Properties.CustomProperties.SearchText = NameValuePair.SearchText;

ResultTable.Properties.CustomProperties.Filter = NameValuePair.Filter;

ResultTable.Properties.CustomProperties.IncludeStyledFilePath = NameValuePair.IncludeStyledFilePath;

ResultTable.Properties.CustomProperties.DisplayInfo = NameValuePair.DisplayInfo;

end  % function
