function App = testapp_TimedTraceBuilderApp()
% This is a testing verison of the TimedTraceBuilderApp.
% BlockPath option is used to link the app to the specified block.

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App SignalTool2.TimedTraceBuilderAppMain {mustBeScalarOrEmpty}
end  % arguments

block_path = "testmodel_TimedTraceBuilderApp/PS Lookup Table (1D)";

app_main = SignalTool2.TimedTraceBuilderAppMain(BlockPath=block_path);

app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = app_main;
end  % if
end  % function
