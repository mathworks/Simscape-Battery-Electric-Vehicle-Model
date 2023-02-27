function htmlFilePath = generateHTML()
%% Generates HTML files from some files in the project.
% Currently this file is considered experimental.
%
% This function exports a Live Script to an HTML file and saves it
% in the `docs` folder.
% This returns a string containing the path to the HTML file.
% If the source file is not found, it returns an empty string.
% If two or more files match, the first file is used.

% Copyright 2022-2023 The MathWorks, Inc.

prj = currentProject;
rootfolder = prj.RootFolder;

htmlfolder = rootfolder + "/docs";
if not(exist(htmlfolder, "dir"))
  mkdir(htmlfolder)
end

files = [prj.Files.Path]';

idx = contains(files, "AboutBEVProject");
sourceFile = files(idx);

if isempty(sourceFile)
  htmlFilePath = "";
  return
elseif numel(sourceFile) > 1
  sourceFile = sourceFile(1);
end

[~, htmlBaseFileName, ~] = fileparts(sourceFile);
htmlFilePath =  fullfile(rootfolder, "docs", htmlBaseFileName+".html");

export(sourceFile, htmlFilePath, Run=true, HideCode=false);

end  % function
