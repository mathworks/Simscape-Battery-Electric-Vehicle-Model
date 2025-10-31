function ResultTable = searchAndReplaceText(SearchTextPattern, NameValuePair)
% Find and replace text from text files.
%
% This function works with text files only.

% NewText
%
% - New text to replace the search text.
%   This option is ignored if DryRun is true.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)

  SearchTextPattern (1,:) pattern
  NameValuePair.IgnoreCase (1,1) logical = true
  NameValuePair.MatchWholeWord (1,1) logical = false

  NameValuePair.NewText (1,1) string = ""

  NameValuePair.DryRun (1,1) logical = true

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

  NameValuePair.Filter (1,:) {CodeTool1.mustBeFunctionHandleOrEmpty} = []

  NameValuePair.DisplayInfo (1,1) logical = false

end  % arguments

arguments (Output)
  ResultTable (:,2) table
end  % arguments

search = SearchTool1.searchText( ...
  SearchTextPattern, ...
  ...
  TargetFolder = NameValuePair.TargetFolder, ...
  IncludeSubfolders = NameValuePair.IncludeSubfolders, ...
  ...
  FileTypes = NameValuePair.FileTypes, ...
  ...
  SelectAll = NameValuePair.SelectAll, ...
  SelectMATLAB = NameValuePair.SelectMATLAB, ...
  SelectMarkdown = NameValuePair.SelectMarkdown, ...
  SelectSimulink = NameValuePair.SelectSimulink, ...
  SelectSimscape = NameValuePair.SelectSimscape, ...
  SelectSVG = NameValuePair.SelectSVG, ...
  CustomFileTypes = NameValuePair.CustomFileTypes, ...
  ...
  ExcludeLiveScript = NameValuePair.ExcludeLiveScript, ...
  ExcludeMATLABCodeFile = NameValuePair.ExcludeMATLABCodeFile, ...
  ...
  IgnoreCase = NameValuePair.IgnoreCase, ...
  MatchWholeWord = NameValuePair.MatchWholeWord, ...
  ...
  Filter = NameValuePair.Filter, ...
  ...
  DisplayInfo = NameValuePair.DisplayInfo );

if isempty(search.Result)

  return

end  % if

unique_files = unique(search.Result.FilePath);
NumReplacedLines = nan(numel(unique_files), 1);
FilePath = strings(numel(unique_files), 1);

cnt = 0;
for ii = 1 : numel(search.Result.FilePath)
  if (ii > 1) && (search.Result.FilePath(ii) == search.Result.FilePath(ii-1))

    continue

  end  % if
  cnt = cnt + 1;

  FilePath(cnt) = search.Result.FilePath(ii);
  targetfile_fullpath = fullfile(NameValuePair.TargetFolder, FilePath(cnt));

  NumReplacedLines(cnt) = SearchTool1.replaceText( ...
    targetfile_fullpath, ...
    ...
    DryRun = NameValuePair.DryRun, ...
    ...
    TextPattern = SearchTextPattern, ...
    IgnoreCase = NameValuePair.IgnoreCase, ...
    MatchWholeWord = NameValuePair.MatchWholeWord, ...
    ...
    NewText = NameValuePair.NewText );

end  % for
ResultTable = table(FilePath, NumReplacedLines);
end  % function
