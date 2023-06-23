function openFile(target_name)
% Opens a script file or a model file in the project.
% Before opening the file, this script opens the Project if not open.

% Copyright 2021-2022 The MathWorks, inc.

arguments
  target_name (1,1) string = "BEVProject_main_script.mlx"
end

thisProjectFile = "BatteryElectricVehicle.prj";
thisProjectName = "Simscape Battery Electric Vehicle Model";

loaded = ~isempty(matlab.project.rootProject);
if loaded
  currPrj = currentProject;
  if currPrj.Name ~= thisProjectName
    error(sprintf("This file must first load the project: " + thisProjectName + "\n" ...
           + "But another project is currently open: " + currPrj.Name + "\n" ...
           + "To use this file, please close the currenly open project."))
  end
else
  disp("Opening project: " + thisProjectFile)
  openProject(thisProjectFile);
end

% Provide visual feedback.
disp("Opening: " + target_name)

open(target_name)

end  % function
