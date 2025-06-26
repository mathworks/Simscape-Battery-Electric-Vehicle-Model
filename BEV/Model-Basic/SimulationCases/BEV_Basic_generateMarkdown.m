function NumConversions = BEV_Basic_generateMarkdown
%% Generate Markdown files from Live Scripts

% Copyright 2025 The MathWorks, Inc.

arguments (Output)
  NumConversions (1,1) {mustBeNonnegative}
end  % arguments

NumConversions = FileTool.batchGenerateMarkdowns( ...
  LiveScriptFolderNames = fullfile(currentProject().RootFolder, "BEV", "Model-Basic", "SimulationCases"), ...
  MarkdownFolderPath = fullfile(currentProject().RootFolder, "BEV", "Model-Basic", "SimulationCases", "markdown"), ...
  DisplayInfo = true);

end  % function
