function openInProject(target_name, NameValuePair)
% Open a file, an app, or a Simulink model in a MATLAB project.
%
% This is a wrapper function for the open command to open a MATLAB code file,
% an app, or a Simulink model file.
% Before opening the file, this script opens the MATLAB Project if it is not open.
% If another project is open, this function issues an error and does not open
% the specified file.
%
% To open an HTML document, use the web function instead of this function because
% web uses MATLAB Web Browser which supports the "matlab:" directive in hyperlinks.

% Copyright 2021-2025 The MathWorks, inc.

arguments (Input)
  target_name (1,1) string = "BEVProject_Description.m"
  NameValuePair.ProjectFile (1,1) string = "BatteryElectricVehicle.prj"
  NameValuePair.ProjectName (1,1) string = "Simscape Battery Electric Vehicle Model"
end  % arguments

errorID = "openInProject";

this_project_file = NameValuePair.ProjectFile;
this_project_name = NameValuePair.ProjectName;

if isempty(matlab.project.rootProject)
  disp("Opening project before opening target. Project: " + this_project_file)
  openProject(this_project_file);

else
  current_project_object = currentProject;
  if current_project_object.Name ~= this_project_name

    id = errorID + "AnotherProjectIsOpen";
    msg = "This file must first load the project: " + this_project_name + newline ...
           + "But another project is currently open: " + current_project_object.Name + newline ...
           + "To use this file, close the currenly open project.";

    throw(MException(id, msg))

  end  % if
end  % if

% Provide visual feedback.
disp("Opening: <a href=""matlab:open('" + target_name + "')"">" + target_name + "</a>")

open(target_name)

end  % function
