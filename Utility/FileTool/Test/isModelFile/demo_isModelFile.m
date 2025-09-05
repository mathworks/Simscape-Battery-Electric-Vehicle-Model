%[text] # isModelFile demo
%[text] Use the test folder for `isModelFile` as the top folder for this demo. A few models for testing are saved in the subfolders.
topfolder = fullfile(currentProject().RootFolder, "Utility", "FileTool", "Test", "isModelFile");
%%
%[text] Use `isModelFile` for `*.mdl` files in the folder tree.
mdlfile_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(topfolder, "**/*.mdl"));
assert(not(isempty(mdlfile_collection)))

mdlfiles = mdlfile_collection.paths';
[~, basename, extension] = fileparts(mdlfiles);
disp(basename + extension) %[output:63518aab]

tf = FileTool3.isModelFile(mdlfiles);

assert(all(tf))
%%
%[text] Use `isModelFile` for `*.slx` files in the folder tree.
slxfile_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(topfolder, "**/*.slx"));
assert(not(isempty(slxfile_collection)))

slxfiles = slxfile_collection.paths';
[~, basename, extension] = fileparts(slxfiles);
disp(basename + extension) %[output:409cda8e]

tf = FileTool3.isModelFile(slxfiles);

assert(all(tf))
%%
%[text] Use `isModelFile` for all files and folders in the specified folder. None of them are model files. Subfolders are excluded.
otherfile_collection = matlab.buildtool.io.FileCollection.fromPaths(fullfile(topfolder, "*"));
otherfiles = otherfile_collection.paths';

[~, basename, extension] = fileparts(otherfiles);
disp(basename + extension) %[output:3f5efc99]

tf = FileTool3.isModelFile(otherfiles);

assert(not(all(tf)))
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:63518aab]
%   data: {"dataType":"text","outputData":{"text":"    \"testmodel_isModelFile_11.mdl\"\n    \"testmodel_isModelFile_21.mdl\"\n    \"testmodel_isModelFile_1.mdl\"\n\n","truncated":false}}
%---
%[output:409cda8e]
%   data: {"dataType":"text","outputData":{"text":"    \"testmodel_isModelFile_12.slx\"\n    \"testmodel_isModelFile_22.slx\"\n    \"testmodel_isModelFile_2.slx\"\n\n","truncated":false}}
%---
%[output:3f5efc99]
%   data: {"dataType":"text","outputData":{"text":"    \"demo_isModelFile.asv\"\n    \"demo_isModelFile.m\"\n    \"testfolder\"\n    \"unittest_isModelFile.m\"\n\n","truncated":false}}
%---
