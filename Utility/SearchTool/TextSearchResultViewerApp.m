function App = TextSearchResultViewerApp(Searcher, NameValuePair)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  Searcher SearchTool1.TextSearch
  NameValuePair.SearchResult table
end  % arguments

arguments (Output)
  App SearchTool1.TextSearchResultViewerAppMain {mustBeScalarOrEmpty}
end  % arguments

if isfield(NameValuePair, "SearchResult")
  result = NameValuePair.SearchResult;
else
  result = runSearch(Searcher);
end  % if

app_main = SearchTool1.TextSearchResultViewerAppMain(TextSearcher=Searcher, SearchResult=result);

app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
