function App = SignalDesignApp(BlockPath)

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string = ""
end

app_main = SignalTool1.SignalDesignAppMain(BlockPath=BlockPath);

app_main.Window.HeaderUI.AppSourceName = mfilename;

if nargout >= 1
  App = app_main;
end  % if
end  % function
