function App = TestFunction_TimedTraceBuilderApp(BlockPath)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string = ""
end  % arguments

arguments (Output)
  App SignalTool2.TimedTraceBuilderAppMain {mustBeScalarOrEmpty}
end  % arguments

if BlockPath == ""
  block_path = "HarnessModel_TimedTraceBuilderApp/PS Lookup Table (1D)";
else
  block_path = BlockPath;
end  % if

app_main = SignalTool2.TimedTraceBuilderAppMain(BlockPath=block_path);

app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
