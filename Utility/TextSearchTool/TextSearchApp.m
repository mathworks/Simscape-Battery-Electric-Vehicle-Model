function App = TextSearchApp(TargetFolder)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  TargetFolder (1,1) string {mustBeFolder} = pwd
end  % arguments

arguments (Output)
  App TextSearchTool1.TextSearchAppMain {mustBeScalarOrEmpty}
end  % arguments

app_main = TextSearchTool1.TextSearchAppMain(TargetFolder=TargetFolder);

app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
