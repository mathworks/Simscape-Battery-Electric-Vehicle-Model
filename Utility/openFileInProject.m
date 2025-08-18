function openFileInProject(target_name)
%% Open a file or a Simulink model in a MATLAB project
% This function opens a MATLAB code file or a Simulink model file.
% Before opening the file, this script opens the MATLAB Project if not open.
% If another project is open, this function does not open the specified file.
%
% To open an HTML document, use the web function instead of this function because
% web uses MATLAB Web Browser which supports the "matlab:" directive in hyperlinks.

% Copyright 2021-2025 The MathWorks, inc.

arguments (Input)
  target_name (1,1) string = "BEVProject_main_script.mlx"
end  % arguments

this_project_file = "BatteryElectricVehicle.prj";
this_project_name = "Simscape Battery Electric Vehicle Model";

% Provide visual feedback.
disp("Opening: " + target_name)

if isempty(matlab.project.rootProject)
  disp("Opening project: " + this_project_file)
  openProject(this_project_file);

else
  current_project_object = currentProject;
  if current_project_object.Name ~= this_project_name
    error(sprintf("This file must first load the project: " + this_project_name + "\n" ...
           + "But another project is currently open: " + current_project_object.Name + "\n" ...
           + "To use this file, please close the currenly open project."))
  end  % if
end  % if

open(target_name)

end  % function
