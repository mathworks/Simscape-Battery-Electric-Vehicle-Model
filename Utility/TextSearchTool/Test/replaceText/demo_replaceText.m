%[text] # replaceText demo
%[text] This function works on one specific file to replace text. To replace text for a group of files, use the `searchAndReplaceText` function.
numlines = TextSearchTool1.replaceText(DryRun=true, FilePath=which("demo_replaceText.m"), TextPattern="demo");
disp("Number of lines containing the TextPattern: " + numlines) %[output:52766628]
%%
targetfile_fullpath = which("samplefile_replaceText.txt");
disp(targetfile_fullpath) %[output:1deb6af2]
type(targetfile_fullpath) %[output:8df1c333]
TextSearchTool1.replaceText( ...
  DryRun = false, ...
  FilePath = targetfile_fullpath, ...
  TextPattern = "is modified", ...
  NewText = "is edited" );

type(targetfile_fullpath) %[output:335620d7]
TextSearchTool1.replaceText( ...
  DryRun = false, ...
  FilePath = targetfile_fullpath, ...
  TextPattern = "is edited", ...
  NewText = "is modified" );

type(targetfile_fullpath) %[output:26a6708f]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:52766628]
%   data: {"dataType":"text","outputData":{"text":"Number of lines containing the TextPattern: 2\n","truncated":false}}
%---
%[output:1deb6af2]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\bev\\bev25b\\Utility\\TextSearchTool\\Test\\replaceText\\samplefile_replaceText.txt\n","truncated":false}}
%---
%[output:8df1c333]
%   data: {"dataType":"text","outputData":{"text":"\nThis file is part of the Text Search Tool.\nThe contents of this file is modified programatically for testing.\n","truncated":false}}
%---
%[output:335620d7]
%   data: {"dataType":"text","outputData":{"text":"\nThis file is part of the Text Search Tool.\nThe contents of this file is edited programatically for testing.\n","truncated":false}}
%---
%[output:26a6708f]
%   data: {"dataType":"text","outputData":{"text":"\nThis file is part of the Text Search Tool.\nThe contents of this file is modified programatically for testing.\n","truncated":false}}
%---
