function App = bev1mus_TextSearchResultApp(Searcher, NameValuePair)
% App for viewing the result of text search.
%
% TextSearchApp uses this app to show the search result. You can also open this app
% programmatically. The app takes a TextSearcher object and optionally a search result.
%
% To programmatically open the app, use the bev1mus.SearchUtil.searchText to do a text search.
%
%   session = bev1mus.SearchUtil.searchText("Copyright", FileTypes="*.m", TargetFolder=pwd);
%
% Then, pass the return value from the search to the app as follows.
%
%   bev1mus_TextSearchResultApp(session.Searcher, SearchResult = session.Result)
%
% If the SearchResult option is not used, the app first runs a search using
% the provided searcher and shows the result.
%
% Running this app without any arguments sets up a default searcher, runs a search,
% and shows the result.

% Copyright 2025-2026 The MathWorks, Inc.

arguments (Input)
  Searcher bev1mus.SearchUtil.TextSearcher = bev1mus.SearchUtil.TextSearcher(Initialization="default")
  NameValuePair.SearchResult table
end  % arguments

arguments (Output)
  App bev1mus.SearchUtil.TextSearchResultAppMain {mustBeScalarOrEmpty}
end  % arguments

if isfield(NameValuePair, "SearchResult")
  result = NameValuePair.SearchResult;
else
  result = runSearch(Searcher);
end  % if

app_main = bev1mus.SearchUtil.TextSearchResultAppMain(Searcher, SearchResult = result);

app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
