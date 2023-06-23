function BatteryHV_openREADME(nvpairs)

% Copyright 2023 The MathWorks, Inc.

arguments
  nvpairs.TestRun (1,1) logical = false
end

topFolder = currentProject().RootFolder;

targetFilePath = fullfile(topFolder, ...
  "Components", "BatteryHighVoltage", "README.md");

urlString = "file:///" + targetFilePath;

if nvpairs.TestRun
  disp("Checking file exists: " + targetFilePath)
  assert(isfile(targetFilePath), ...
    "File not found: " + targetFilePath)
else
  % With -browser option, use the system web browser.
  web(urlString, "-browser")
end

end  % function
