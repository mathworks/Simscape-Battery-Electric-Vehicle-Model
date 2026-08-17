function atProjectStartUp
% This function has been configured to automatically run when the MATLAB Project is opened.
%
% To change the setting for automatic execution, navigate to the Project toolstrip
% and select Settings.
% In the Project Settings window, find "Task Automation" > "Startup files".

% Copyright 2020-2026 The MathWorks, Inc.

% Back-porting a project to an older MATLAB release can be hard.
% Remind the user that MATLAB they are currently using is newer than
% MATLAB used to develop this project.
if not(contains(matlabRelease().Release, "R2026a"))
  disp("This project was developed in R2026a.")
  relstr = matlabRelease().Release;
  disp("This MATLAB Release is " + relstr + ".")
end  % if
end  % function
