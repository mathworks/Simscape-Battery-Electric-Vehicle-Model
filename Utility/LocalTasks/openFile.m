function openFile(target_name)
% Opens a script file or a model file in the project.
% Before opening the file, this script opens the Project if not open.
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
