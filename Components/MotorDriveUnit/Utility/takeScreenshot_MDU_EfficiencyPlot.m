function DestinationFullpath = takeScreenshot_MDU_EfficiencyPlot(NameValuePair)
% Take screenshot of motor efficiency plot using a Motor & Drive block in the specified model.
% Image file is in PNG format and stored in the specified path.
%
% This function does the followings step by step.
% 1. Load parameters in the base workspace.
% 2. Build a data set object for the motor efficiency app.
% 3. Make a plot of the efficiency.
% 4. Save the plot to the specified png file.

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  % The name of a script without ".m" at the end. The script must run simulation.
  NameValuePair.Script (1,1) string = "MotorDriveUnit_Basic_params"

  NameValuePair.BlockPath (1,1) string = "MotorDriveUnit_Basic_refsub/Motor & Drive (Driveline)"

  % The name of a base workspace variable containing simulation result.
  NameValuePair.ImageFilename (1,1) string = "screenshot-MDU-Basic-MotorEfficiency.png"

  % The folder to save the png file.
  NameValuePair.MediaFolder (1,1) string = fullfile(currentProject().RootFolder, "Components", "MotorDriveUnit", "media")
end  % arguments

arguments (Output)
  DestinationFullpath (1,1) string
end  % arguments

source_script = NameValuePair.Script;
image_filename = NameValuePair.ImageFilename;

DestinationFullpath = fullfile(NameValuePair.MediaFolder, image_filename);

% -----------------------------------------------------------------------------

% mkdir warns if the specified folder already exists.
if not(isfolder(NameValuePair.MediaFolder))
  disp("Creating destination folder: " + NameValuePair.MediaFolder)
  mkdir(NameValuePair.MediaFolder)
end  % if

disp("Loading parameters: <a href=""matlab:edit('" + source_script + "')"">" + source_script + "</a>")
evalin("base", source_script)

% Set up the data set using the target block in the model.
% The block reads parameters from the base workspace.
ds = bevutil1.app.AbstractMotorEfficiency.AbstractMotorEfficiencyDataSet(BlockPath=NameValuePair.BlockPath);

% Create a plot.
fig = bevutil1.app.AbstractMotorEfficiency.plotAbstractMotorEfficiency(DataSource="dataset", DataSet=ds);
fig.Position(3:4) = [500, 400];  % width height

exportgraphics(fig, DestinationFullpath)

end  % function
