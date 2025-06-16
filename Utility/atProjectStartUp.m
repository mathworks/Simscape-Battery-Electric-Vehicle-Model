function atProjectStartUp
%% Run at project start up
% This function has been configured to automatically run when the MATLAB Project is opened.
%
% To change the automatic execution setting, in the Project toolstrip, click the Settings button.
% In the Project Settings window, find Startup files section and edit.
%
% Copyright 2020-2025 The MathWorks, Inc.

% Backporting the project to older MATLAB can be hard.
% Remind the user that MATLAB they are using to open this project is newer than
% MATLAB which was used for the development of this project.
if not(contains(matlabRelease().Release, "R2025a"))
  disp("This project was developed in R2025a.")
  relstr = matlabRelease().Release;
  disp("This MATLAB Release is " + relstr(2:end-1) + ".")
end

end  % function
