%[text] # replaceText demo
%[text] This function works on one specific files to replace text. To replace text for a group of files that were found by text search, use the `searchAndReplaceText` function.
targetfile_fullpath = which("samplefile_replaceText.txt");
type(targetfile_fullpath) %[output:3f9a2e34]
result = SearchTool1.replaceText(targetfile_fullpath, DryRun=true, TextPattern="testing", NewText="testing"); %[output:3c13ddab]
disp("Number of lines containing the TextPattern: " + result.NumLines) %[output:74f856ce]
%%
targetfile_fullpath = which("samplefile_replaceText.txt");
disp(targetfile_fullpath) %[output:940681fc]
type(targetfile_fullpath) %[output:52d26ff0]
SearchTool1.replaceText( ...
  targetfile_fullpath, ...
  DryRun = false, ...
  TextPattern = "is modified", ...
  NewText = "is edited" );

type(targetfile_fullpath) %[output:7a788605]
SearchTool1.replaceText( ...
  targetfile_fullpath, ...
  DryRun = false, ...
  TextPattern = "is edited", ...
  NewText = "is modified" );

type(targetfile_fullpath) %[output:6d585c73]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:3f9a2e34]
%   data: {"dataType":"text","outputData":{"text":"\nThis file is part of the Search Tool.\nThe contents of this file is modified programatically for testing.\n","truncated":false}}
%---
%[output:3c13ddab]
%   data: {"dataType":"text","outputData":{"text":"dry run\n","truncated":false}}
%---
%[output:74f856ce]
%   data: {"dataType":"text","outputData":{"text":"Number of lines containing the TextPattern: 1\n","truncated":false}}
%---
%[output:940681fc]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\\Utility\\SearchTool\\Test\\replaceText\\samplefile_replaceText.txt\n","truncated":false}}
%---
%[output:52d26ff0]
%   data: {"dataType":"text","outputData":{"text":"\nThis file is part of the Search Tool.\nThe contents of this file is modified programatically for testing.\n","truncated":false}}
%---
%[output:7a788605]
%   data: {"dataType":"text","outputData":{"text":"\nThis file is part of the Search Tool.\nThe contents of this file is edited programatically for testing.\n","truncated":false}}
%---
%[output:6d585c73]
%   data: {"dataType":"text","outputData":{"text":"\nThis file is part of the Search Tool.\nThe contents of this file is modified programatically for testing.\n","truncated":false}}
%---
