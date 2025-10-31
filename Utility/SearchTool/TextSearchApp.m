function App = TextSearchApp(NameValuePair)
% App for searching text in files.
%
% Open the app without any options and the app will use the default values.
%
%   TextSearchApp
%
% Specify search options to customize the app's initial states.
% See the NameValuePair options in the code for available options.
% Example:
%
%   TextSearchApp(TargetFolder=pwd, SearchText="hello", IgnoreCase=true)
%
% Use the StatesSource option to control the way the app opens.
% By default, StatesSource is "options", and the app takes individual search options
% as shown above.
%
% You can use an external TextSearchStates object to specify search options
% by setting StatesSource to "external" and specify the search state object to the SearchStates.
% Example:
%
%   % states is a TextSearchStates object.
%   TextSearchApp(StatesSource="external", SearchStates=states)
%

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  NameValuePair.StatesSource (1,1) string {mustBeMember(NameValuePair.StatesSource, ["options", "external"])} = "options"

  % ---------------------------------------------------------------------------
  % StatesSource="options"

  NameValuePair.TargetFolder (1,1) string {mustBeFolder} = pwd
  NameValuePair.IncludeSubfolders (1,1) logical = false

  NameValuePair.SearchAll (1,1) logical = true
  NameValuePair.SearchMATLAB (1,1) logical = true
  NameValuePair.SearchMarkdown (1,1) logical = true
  NameValuePair.SearchSimulink (1,1) logical = true
  NameValuePair.SearchSimscape (1,1) logical = true
  NameValuePair.SearchSVG (1,1) logical = true
  NameValuePair.CustomFileTypes (1,:) string = ""

  NameValuePair.ExcludeLiveScript (1,1) logical = false
  NameValuePair.ExcludeMATLABCodeFile (1,1) logical = false

  NameValuePair.IgnoreCase (1,1) logical = true
  NameValuePair.MatchWholeWord (1,1) logical = false
  NameValuePair.SearchText (1,1) string = "Copyright"

  % ---------------------------------------------------------------------------
  % StatesSource="external"
  NameValuePair.SearchStates (1,:) SearchTool1.TextSearchStates

end  % arguments

arguments (Output)
  App SearchTool1.TextSearchAppMain {mustBeScalarOrEmpty}
end  % arguments

switch NameValuePair.StatesSource

  case "options"
    app_main = SearchTool1.TextSearchAppMain( ...
      StatesSource = "options", ...
      TargetFolder = NameValuePair.TargetFolder, ...
      IncludeSubfolders = NameValuePair.IncludeSubfolders, ...
      SearchAll = NameValuePair.SearchAll, ...
      CustomFileTypes = NameValuePair.CustomFileTypes, ...
      ExcludeLiveScript = NameValuePair.ExcludeLiveScript, ...
      ExcludeMATLABCodeFile = NameValuePair.ExcludeMATLABCodeFile, ...
      IgnoreCase = NameValuePair.IgnoreCase, ...
      MatchWholeWord = NameValuePair.MatchWholeWord, ...
      SearchText = NameValuePair.SearchText );

  case "external"
    app_main = SearchTool1.TextSearchAppMain( ...
      StatesSource = "external", ...
      SearchStates = NameValuePair.SearchStates );

end  % switch

app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
