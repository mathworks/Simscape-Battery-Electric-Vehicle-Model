function DestinationFullpath = takeScreenshot_BEV_SimulationResult(NameValuePair)
% Take screenshot of simulation result by running simulation.
% Screenshot file is in PNG format, stored in the specified path with the script name as the base filename.
%
% This function does the followings step by step.
% 1. Run the specified script. The script must store simulation result in a base workspace variable.
% 2. Get the result from the base workspace.
% 3. Make a plot of the simulation result.
% 4. Save the plot to the specified png file.

% Copyright 2026 The MathWorks, Inc.

arguments (Input)
  % The name of a script without ".m" at the end. The script must run simulation.
  NameValuePair.Script (1,1) string = "BEV_Basic_FTP75"

  % The name of a base workspace variable containing simulation result.
  NameValuePair.ResultVariable (1,1) string = "sim_data"

  % The folder to save the png file.
  NameValuePair.MediaFolder (1,1) string = fullfile(currentProject().RootFolder, "BEV", "media")
end  % arguments

arguments (Output)
  DestinationFullpath (1,1) string
end  % arguments

source_script = NameValuePair.Script;
result_varname = NameValuePair.ResultVariable;

DestinationFullpath = fullfile(NameValuePair.MediaFolder, source_script + ".png");

% -----------------------------------------------------------------------------

% mkdir warns if the specified folder already exists.
if not(isfolder(NameValuePair.MediaFolder))
  disp("Creating destination folder: " + NameValuePair.MediaFolder)
  mkdir(NameValuePair.MediaFolder)
end  % if

disp("Running script: <a href=""matlab:edit('" + source_script + "')"">" + source_script + "</a>")
evalin("base", source_script)

result_data = evalin("base", result_varname);

fig = BEV_plotResults(TimedData = result_data, PlotTemperature = false);

exportgraphics(fig, DestinationFullpath)

end  % function
