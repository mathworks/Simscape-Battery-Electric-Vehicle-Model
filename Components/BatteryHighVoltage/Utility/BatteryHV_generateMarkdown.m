function BatteryHV_generateMarkdown
%% Generates Markdown files from Live Scripts

% Copyright 2024 The MathWorks, Inc.

generateMarkdown_fromLiveScript( ...
  LiveScriptFolderNames = [
  fullfile(currentProject().RootFolder, "Components", "BatteryHighVoltage")
  fullfile(currentProject().RootFolder, "Components", "BatteryHighVoltage", "Model-TableBased")
  fullfile(currentProject().RootFolder, "Components", "BatteryHighVoltage", "SimulationCases")
  ], ...
  MarkdownFolderPath = ...
  fullfile(currentProject().RootFolder, "Components", "BatteryHighVoltage", "markdown"), ...
  ForceExport = false )

end  % function
