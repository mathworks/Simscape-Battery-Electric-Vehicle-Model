function App = Vehicle1DPerformanceDesignApp(BlockPath)
%% Vehicle1D performance design app
% With BlockPath option, you can specify the block path to Longitudinal Vehicle block in a model,
% and the app loads the parameters from the block when the app opens.
%
% Exmaple:
%   Vehicle1DPerformanceDesignAppMain(BlockPath="model_name/Longitudinal Vehicle 1")

% Copyright 2025 The MathWorks, Inc.

arguments (Input)
  BlockPath (1,1) string = ""
end

arguments (Output)
  App Vehicle1DPerformanceDesignAppMain {mustBeScalarOrEmpty}
end  %

vehicle_app = Vehicle1DPerformanceDesignAppMain(BlockPath=BlockPath);

vehicle_app.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  % Returning the App variable is optional because the app class object persists
  % even if it is not returned.
  App = vehicle_app;
end  % if
end  % function
