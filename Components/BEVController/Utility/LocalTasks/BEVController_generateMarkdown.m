function NumConversions = BEVController_generateMarkdown
%% Generate Markdown files from Live Scripts

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  NumConversions (1,1) {mustBeNonnegative}
end  % arguments

NumConversions = FileTool.batchGenerateMarkdowns( ...
  LiveScriptFolderNames = [
  fullfile(currentProject().RootFolder, "Components", "BEVController")
  fullfile(currentProject().RootFolder, "Components", "BEVController", "SimulationCases")
  ], ...
  MarkdownFolderPath = fullfile(currentProject().RootFolder, "Components", "BEVController", "markdown"), ...
  DisplayInfo = true);

end  % function
