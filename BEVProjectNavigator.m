function App = BEVProjectNavigator()
%% BEV project navigator app
% This is an entry-point app to find some key models, scripts, etc. in the project.
%
% The getFileFullPath function checks that the linked file exists.
% This check is done before the app shows up.
% If the file is not found, the app issues an error and terminates.
% If the app window appears, it guarantees that all the links are valid.
%
% This is a funciton-based app whose life cycle is limited compared to class-based app.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  App (1,:) BEVProjectNavigatorMain
end  % arguments

disp("Starting: BEV Project Navigator")

project_navigator = BEVProjectNavigatorMain;

project_navigator.Window.HeaderUI.AppSourceName = mfilename;

if nargout > 0
  % Returning the App variable is optional because the app class object persists
  % even if it is not returned.
  App = project_navigator;
end  % if
end  % function
