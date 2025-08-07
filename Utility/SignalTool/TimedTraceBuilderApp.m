function App = TimedTraceBuilderApp(BlockPath)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string = ""
end  % arguments

arguments (Output)
  App SignalTool2.TimedTraceBuilderAppMain {mustBeScalarOrEmpty}
end  % arguments

app_main = SignalTool2.TimedTraceBuilderAppMain(BlockPath=BlockPath);

app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
