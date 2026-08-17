function SearchSession = searchText(SearchTextPattern, NameValuePair)
% Search text files for the specified text pattern in a folder.
%
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
% - SearchTextPattern = a string or a pattern, e.g., "search text", "("+wildcardPattern+")"
%
% Use the SearchTextPattern option to specify the text to search in the target files.
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
% the SearchTextPattern to whole words.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)

  SearchTextPattern (1,:) pattern
  NameValuePair.IgnoreCase (1,1) logical = true
  NameValuePair.MatchWholeWord (1,1) logical = false

  NameValuePair.TargetFolder (:,1) string = pwd
  NameValuePair.IncludeSubfolders (1,1) logical = false

  % FileTypes overrides the Search*, Exclude*, and CustomFileTypes options.
  % Leave FileTypes "" to use the other selectors.
  % FileTypes is an array of string, e.g., ["*.m", "*.mdl"]
  NameValuePair.FileTypes (1,:) string {mustBeVector} = ""

  % If SearchAll=true, all other Search* options are ignored.
  NameValuePair.SearchAll = false;
  NameValuePair.SearchMATLAB = false;
  NameValuePair.SearchMarkdown = false;
  NameValuePair.SearchSimulink = false;
  NameValuePair.SearchSimscape = false;
  NameValuePair.SearchSVG = false;

  % If FileTypes is specified, CustomFileTypes is ignored.
  % CustomFileTypes is an array of string, e.g., ["*.m", "*.mdl"]
  NameValuePair.CustomFileTypes (1,:) string {mustBeVector} = "";

  NameValuePair.ExcludeLiveScript (1,1) logical = false
  NameValuePair.ExcludeMATLABCodeFile (1,1) logical = false

  NameValuePair.Filter (1,:) {bevutil1.CodeUtil.mustBeFunctionHandleOrEmpty} = []

  NameValuePair.DisplayInfo (1,1) logical = false

end  % arguments

arguments (Output)
  SearchSession struct
end  % arguments

text_searcher = bevutil1.SearchUtil.TextSearcher;
text_searcher.DisplayInfo = NameValuePair.DisplayInfo;

text_searcher.States.SearchTextPattern = SearchTextPattern;
text_searcher.States.IgnoreCase = NameValuePair.IgnoreCase;
text_searcher.States.MatchWholeWord = NameValuePair.MatchWholeWord;

text_searcher.States.TargetFolder = NameValuePair.TargetFolder;
text_searcher.States.IncludeSubfolders = NameValuePair.IncludeSubfolders;

text_searcher.States.FileTypes = NameValuePair.FileTypes;

text_searcher.States.SearchAll = NameValuePair.SearchAll;
text_searcher.States.SearchMATLAB = NameValuePair.SearchMATLAB;
text_searcher.States.SearchMarkdown = NameValuePair.SearchMarkdown;
text_searcher.States.SearchSimulink = NameValuePair.SearchSimulink;
text_searcher.States.SearchSimscape = NameValuePair.SearchSimscape;
text_searcher.States.SearchSVG = NameValuePair.SearchSVG;

text_searcher.States.CustomFileTypes = NameValuePair.CustomFileTypes;

text_searcher.States.ExcludeLiveScript = NameValuePair.ExcludeLiveScript;
text_searcher.States.ExcludeMATLABCodeFile = NameValuePair.ExcludeMATLABCodeFile;

text_searcher.States.Filter = NameValuePair.Filter;

buildFileTypes(text_searcher)
result = runSearch(text_searcher);

SearchSession.Searcher = text_searcher;
SearchSession.Result = result;
end  % function
