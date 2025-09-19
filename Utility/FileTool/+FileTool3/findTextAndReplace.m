function ResultTable = findTextAndReplace(NameValuePair)
% Find text from text files, and optionally replace with new text.
%
% This function returns a table containing FilePath, LineNumber, and LineText.
% This function works with text files only.
%
% Options
%
% - DryRun = true (default) | false
%
% By default, this function does the find action only.
% To do the replacing action, set the DryRun option to false.
%
% - DisplayInfo = true | false (default)
%
% To view information from within this function, set the DisplayInfo option to true.
%
% - TargetFolder = a folder to do text search, e.g., pwd, or "folder1".
%
% Specify the target folder to search files. Current folder is used by default.
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
% - TextPattern = a string or a pattern, e.g., "search text", "("+wildcardPattern+")"
%
% Use the TextPattern option to specify the text to search in the target files.
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
% the TextPattern to whole words.
%
% - NewText
%
% Use this option to specify new text to replace the search text.
% This option is ignored if the DryRun option is true.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)

  NameValuePair.DryRun (1,1) logical = true

  NameValuePair.DisplayInfo (1,1) logical = false

  NameValuePair.TargetFolder (:,1) string {mustBeFolder} = pwd
  NameValuePair.IncludeSubfolders (1,1) logical = false

  NameValuePair.FileTypes (1,:) string = ["*.m", "*.mdl"]
  NameValuePair.Filter (1,:) {CodeTool1.mustBeFunctionHandleOrEmpty}

  NameValuePair.TextPattern (1,1) pattern = "Copyright"
  NameValuePair.IgnoreCase (1,1) logical = false
  NameValuePair.MatchWholeWord (1,1) logical = false

  NameValuePair.NewText (1,1) string = ""

end  % arguments

arguments (Output)
  ResultTable (:,3) table
end  % arguments

errorID = "findTextAndReplace:";

ResultTable = table([], [], [], VariableNames=["FilePath", "LineNumber", "LineText"]);

if NameValuePair.FileTypes == ""
  id = errorID + "InvalidFileType";
  msg = CodeTool1.i18n("FileTypes must not be """".");

  throw(MException(id, msg))

end  % if

% Make sure file_types is a column vector (or a scalar).
file_types = NameValuePair.FileTypes(:);
if NameValuePair.IncludeSubfolders
  collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(NameValuePair.TargetFolder, "**", file_types));
else
  collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(NameValuePair.TargetFolder, file_types));
end  % if

if NameValuePair.DisplayInfo
  disp("Search files:")
  disp(collection')
end  % if

if isfield(NameValuePair, "Filter")
  % Use the select to filter the collection. See the documentation for details.
  % https://www.mathworks.com/help/matlab/ref/matlab.buildtool.io.filecollection.select.html
  collection = select(collection, @(x) NameValuePair.Filter(x));
end  % if

found_files = paths(collection)';

num_files = numel(found_files);

if num_files == 0
  if NameValuePair.DisplayInfo
    disp("No files matched File Types and Filter.")
  end  % if

  return

end  % if

% -----------------------------------------------------------------------------
% First pass: Determine the number of rows necessary for a table.

if NameValuePair.MatchWholeWord
  search_text = textBoundary + NameValuePair.TextPattern + textBoundary;
else
  search_text = NameValuePair.TextPattern;
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
    FilePath(cnt) = extractAfter(target_file, NameValuePair.TargetFolder + ("/"|"\"));
    LineNumber(cnt) = line_number(jj);
    LineText(cnt) = line_text(jj);
  end  % for
end  % for

ResultTable = table(FilePath, LineNumber, LineText);

ResultTable = addprop(ResultTable, "TargetFolder", "table");
ResultTable.Properties.CustomProperties.TargetFolder = NameValuePair.TargetFolder;

if NameValuePair.DryRun

  return

end  % if

% -----------------------------------------------------------------------------
% Third pass: Replace the search text with the new text.

if NameValuePair.IgnoreCase
  pat = caseInsensitivePattern(search_text);
else
  pat = caseSensitivePattern(search_text);
end  % if 

for ii = 1 : num_files
  target_file = file_path(ii);
  lines = readlines(target_file);
  edited_lines = replace(lines, pat, NameValuePair.NewText);
  writelines(edited_lines, target_file)
end  % for

end  % function
