function atProjectStartUp
% This function has been configured to automatically run when the MATLAB Project is opened.
%
% To change the setting for automatic execution, navigate to the Project toolstrip
% and select Settings.
% In the Project Settings window, find "Task Automation" > "Startup files".

% Copyright 2020-2025 The MathWorks, Inc.

% Backporting the project to an older MATLAB release can be hard.
% Remind the user that MATLAB they are using to open this project is newer than
% MATLAB which was used to develop this project.
if not(contains(matlabRelease().Release, "R2025b"))
  disp("This project was developed in R2025b.")
  relstr = matlabRelease().Release;
  disp("This MATLAB Release is " + relstr + ".")
end  % if
end  % function
