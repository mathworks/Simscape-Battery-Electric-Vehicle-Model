function App = TextSearchResultViewerApp(Searcher, NameValuePair)
% App for viewing the result of text search.
%
% TextSearchApp uses this app to show the search result. You can also open this app
% programmatically. The app takes a TextSearcher object and optionally a search result.
%
% You can programmatically open the app.
% First, use the SearchTool1.searchText to do a text search.
%
%   session = SearchTool1.searchText("Copyright", FileTypes="*.m", TargetFolder=pwd);
%
% Second, pass the return value from the search to the app as follows.
%
%   TextSearchResultViewerApp(session.Searcher, SearchResult = session.Result)
%
% If the SearchResult option is not used, the app first runs a search using
% the provided searcher and shows the result.
%
% Running this app without any arguments sets up a default searcher, runs a search,
% and shows the result.

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  Searcher SearchTool1.TextSearcher = SearchTool1.TextSearcher(Initialization="default")
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

app_main = SearchTool1.TextSearchResultViewerAppMain(Searcher, SearchResult = result);

app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
