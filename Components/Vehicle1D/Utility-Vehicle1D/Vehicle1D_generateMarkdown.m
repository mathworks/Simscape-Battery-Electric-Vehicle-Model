function NumConversions = Vehicle1D_generateMarkdown(NameValuePairs)
% This function generates Markdown files from Live Scripts.
%
% This function returns the number of files exported.
% The function returns 0 if no file was exported.
%
% By default, the function shows messages about exporting process.
% To turn off messages, set false to DisplayInfo option.

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Input)
  NameValuePairs.DisplayInfo (1,1) logical = true
end  % arguments

arguments (Output)
  NumConversions (1,1) {mustBeInteger, mustBeNonnegative}
end  % arguments

NumConversions = FileTool.batchGenerateMarkdowns( ...
  LiveScriptFolderNames = fullfile(currentProject().RootFolder, "Components", "Vehicle1D", "Model-Basic", "SimulationCases"), ...
  MarkdownFolderPath = fullfile(currentProject().RootFolder, "Components", "Vehicle1D", "markdown"), ...
  ForceExport = false, ...
  DisplayInfo = NameValuePairs.DisplayInfo );

end  % function
