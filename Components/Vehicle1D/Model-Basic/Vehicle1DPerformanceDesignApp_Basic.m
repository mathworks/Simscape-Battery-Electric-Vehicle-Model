function App = Vehicle1DPerformanceDesignApp_Basic()
%% Vehicle1D performance design app for Basic vehicle1d model

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  App (1,:) Vehicle1DPerformanceDesignAppMain
end  % arguments

parameter_file = "Vehicle1D_refsub_Basic_params";
block_path = "Vehicle1D_refsub_Basic/Longitudinal Vehicle";

% Load block parameters to the base workspace.
disp("Loading parameters: <a href=""matlab:edit('"+ parameter_file +"')"">" + parameter_file + "</a>")
evalin("base", parameter_file)

% Open the app with the target block initially loaded.
vehicle_app = Vehicle1DPerformanceDesignAppMain(BlockPath=block_path);

vehicle_app.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  App = vehicle_app;
end  % if
end  % function
