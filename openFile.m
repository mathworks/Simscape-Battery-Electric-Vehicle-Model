function openFile(filename)
% Opens a script file or a model file in the project.
% Before opening the file, this script opens the Project if not open.

% Copyright 2021 The MathWorks, inc.

arguments
  filename (1,1) string = "BEV_main_script.mlx"
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

if endsWith(filename, {'.m', '.mlx'})
  disp("Opening script: " + filename)
  edit(filename)
elseif endsWith(filename, {'.slx', '.mdl'})
  disp("Opening model: " + filename)
  open_system(filename)
else
  error('Unknown file type: %s', filename)
end

end
