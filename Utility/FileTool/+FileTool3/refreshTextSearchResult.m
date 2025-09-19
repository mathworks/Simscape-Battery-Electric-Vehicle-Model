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
  SearchResult table
  NameValuePair.DisplayInfo (1,1) logical = true
end  % arguments

arguments (Output)
  NewResult table
end  % arguments

errorID = "refreshTextSearchResult:";

if isempty(SearchResult)
  id = errorID + "InvalidSearchResult";
  msg = CodeTool1.i18n("Table must be non-empty.");

  throw(MException(id, msg))

end  % if

if not(isprop(SearchResult.Properties, "CustomProperties"))
  id = errorID + "MissingCustomProperties";
  msg = CodeTool1.i18n("Table must have custom properties for search result.");

  throw(MException(id, msg))

end  % if

% Custom properties for the passed serch result are accessed without error checking.
% Make sure to test this function.

target_properties = SearchResult.Properties.CustomProperties;

target_folder = target_properties.TargetFolder;

include_subfolders = target_properties.IncludeSubfolders;

file_types_string = target_properties.FileTypesString;
file_types = split(strip(file_types_string), "," + optionalPattern(whitespacePattern));

% !todo: Convert string to pattern, but it requires parsing.
text_pattern_string = target_properties.TextPatternString;
text_pattern_string = extractBetween(text_pattern_string, lineBoundary("start")+"""", """"+lineBoundary("end"));

ignore_case = target_properties.IgnoreCase;

match_whole_word = target_properties.MatchWholeWord;

if NameValuePair.DisplayInfo
  command_text = ...
    "FileTool3.searchText(" + ...
    "TargetFolder=""" + target_folder + """, " + ...
    "IncludeSubfolders=" + include_subfolders + ", " + ...
    "FileTypes=[""" + join(file_types, """,""") + """], " + ...
    "TextPattern=""" + text_pattern_string + """, " + ...
    "IgnoreCase=" + ignore_case + ", " + ...
    "MatchWholeWord=" + match_whole_word + ")";

  disp(command_text)
end  % if

NewResult = FileTool3.searchText( ...
  TargetFolder = target_folder, ...
  IncludeSubfolders = include_subfolders, ...
  FileTypes = file_types, ...
  TextPattern = text_pattern_string, ...
  IgnoreCase = ignore_case, ...
  MatchWholeWord = match_whole_word );

end  % function
