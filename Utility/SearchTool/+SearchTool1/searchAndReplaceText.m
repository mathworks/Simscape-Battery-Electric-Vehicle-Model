function ReplaceResultTable = searchAndReplaceText(NameValuePair)
% Replace text in the specified search result table.
%
% The returned table has two columns, "FilePath", and "NumReplacedLines".
% It also has the "TargetFolder" custom property.

% NewText
%
% - New text to replace the search text.
%   This option is ignored if DryRun is true.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)

  NameValuePair.DryRun (1,1) logical = true

  NameValuePair.DisplayInfo (1,1) logical = false

  NameValuePair.TargetFolder (:,1) string = pwd
  NameValuePair.IncludeSubfolders (1,1) logical = false

  NameValuePair.FileTypes (1,:) string = ["*.m", "*.mdl"]
  NameValuePair.Filter (1,:) {CodeTool1.mustBeFunctionHandleOrEmpty} = []

  NameValuePair.TextPattern (1,1) pattern = "Copyright"
  NameValuePair.IgnoreCase (1,1) logical = false
  NameValuePair.MatchWholeWord (1,1) logical = false

  NameValuePair.NewText (1,1) string = ""

end  % arguments

arguments (Output)
  ReplaceResultTable (:,2) table
end  % arguments

target_folder = NameValuePair.TargetFolder;

  function result_table = newReplaceResultTable(FilePath, NumReplacedLines)
    result_table = table(FilePath, NumReplacedLines);
    result_table = addprop(result_table, "TargetFolder", "table");
    result_table.Properties.CustomProperties.TargetFolder = target_folder;
  end  % nested function

search_result = TextSearchTool1.searchText( ...
  DisplayInfo = NameValuePair.DisplayInfo, ...
  TargetFolder = target_folder, ...
  IncludeSubfolders = NameValuePair.IncludeSubfolders, ...
  FileTypes = NameValuePair.FileTypes, ...
  Filter = NameValuePair.Filter, ...
  TextPattern = NameValuePair.TextPattern, ...
  IgnoreCase = NameValuePair.IgnoreCase, ...
  MatchWholeWord = NameValuePair.MatchWholeWord );

if isempty(search_result)
  ReplaceResultTable = newReplaceResultTable([], []);

  return

end  % if

unique_files = unique(search_result.FilePath);
NumReplacedLines = nan(numel(unique_files), 1);
FilePath = strings(numel(unique_files), 1);

cnt = 0;
for ii = 1 : numel(search_result.FilePath)
  if (ii > 1) && (search_result.FilePath(ii) == search_result.FilePath(ii-1))

    continue

  end  % if
  cnt = cnt + 1;

  FilePath(cnt) = search_result.FilePath(ii);

  NumReplacedLines(cnt) = TextSearchTool1.replaceText( ...
    DryRun = NameValuePair.DryRun, ...
    FilePath = fullfile(target_folder, FilePath(cnt)), ...
    TextPattern = NameValuePair.TextPattern, ...
    IgnoreCase = NameValuePair.IgnoreCase, ...
    MatchWholeWord = NameValuePair.MatchWholeWord, ...
    NewText = NameValuePair.NewText );

end  % for

ReplaceResultTable = newReplaceResultTable(FilePath, NumReplacedLines);

end  % function
