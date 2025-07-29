function App = BEVProjectNavigationApp()
%% BEV project navigation app
% This is a project entry-point app to find some key models, scripts, etc. in the project.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  App (1,:) BEVProjectNavigationAppMain
end  % arguments

disp("Starting: BEV Project Navigation App")

project_navigator = BEVProjectNavigationAppMain;

project_navigator.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  % Returning the App variable is optional because the app class object persists
  % even if it is not returned.
  App = project_navigator;
end  % if
end  % function
