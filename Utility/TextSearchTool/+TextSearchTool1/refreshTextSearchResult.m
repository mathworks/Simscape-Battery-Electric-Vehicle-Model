function NewResult = refreshTextSearchResult(SearchResult, NameValuePair)
% Redo the text search using the specified search result table.
%
% This function rebuilds arguments from the SearchResult table for the searchText function and calls it.
% The SearchResult table must contain the custom properties that the searchText function built.
%
% Limitations:
%
% - Filter is not supported.
% - TextPattern does not support the pattern object. It must be a simple text string.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  SearchResult table {TextSearchTool1.mustBeTextSearchTable} = TextSearchTool1.newTextSearchTable
  NameValuePair.DisplayInfo (1,1) logical = true
end  % arguments

arguments (Output)
  NewResult table {TextSearchTool1.mustBeTextSearchTable}
end  % arguments

if isempty(SearchResult)
  % Even if the specified table is empty, it can still have custom properties.
  % Copy them to the table to return.
  NewResult = SearchResult;

  return

end  % if

target_properties = SearchResult.Properties.CustomProperties;

if NameValuePair.DisplayInfo
  command_text = TextSearchTool1.buildSearchCommandText(BuildFrom="ResultTable", ResultTable=SearchResult);
  disp(command_text)
end  % if

NewResult = TextSearchTool1.searchText( ...
  TargetFolder = target_properties.TargetFolder, ...
  IncludeSubfolders = target_properties.IncludeSubfolders, ...
  FileTypes = target_properties.FileTypes, ...
  ExcludeLiveScript = target_properties.ExcludeLiveScript, ...
  ExcludeMATLABCodeFile = target_properties.ExcludeMATLABCodeFile, ...
  TextPattern = target_properties.TextPattern, ...
  IgnoreCase = target_properties.IgnoreCase, ...
  MatchWholeWord = target_properties.MatchWholeWord, ...
  IncludeStyledFilePath = target_properties.IncludeStyledFilePath );

end  % function
