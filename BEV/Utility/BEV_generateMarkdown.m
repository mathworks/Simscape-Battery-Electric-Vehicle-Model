function NumConversions = BEV_generateMarkdown
%% Generate Markdown files from Live Scripts

% Copyright 2024-2025 The MathWorks, Inc.

arguments (Output)
  NumConversions (1,1) {mustBeNonnegative}
end  % arguments

NumConversions = FileTool.batchGenerateMarkdowns( ...
  LiveScriptFolderNames = fullfile(currentProject().RootFolder, "BEV"), ...
  MarkdownFolderPath = fullfile(currentProject().RootFolder, "BEV", "markdown"), ...
  DisplayInfo = true);

end  % function
