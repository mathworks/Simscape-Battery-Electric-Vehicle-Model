%[text] # buildSearchCommandText demo
command_text = TextSearchTool1.buildSearchCommandText;
disp(command_text) %[output:0d0c1c95]
%%
x = TextSearchTool1.searchText(TargetFolder=pwd, IncludeSubfolders=false);
command_text = TextSearchTool1.buildSearchCommandText(x);
disp(command_text) %[output:8df01b52]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:0d0c1c95]
%   data: {"dataType":"text","outputData":{"text":"TextSearchTool1.searchText(TargetFolder=\"\", IncludeSubfolders=false, FileTypes=[\"*.m, *.mdl\"], TextPattern=\"Copyright\", IgnoreCase=true, MatchWholeWord=false)\n","truncated":false}}
%---
%[output:8df01b52]
%   data: {"dataType":"text","outputData":{"text":"TextSearchTool1.searchText(TargetFolder=\"C:\\local\\bev\\bev25b\", IncludeSubfolders=false, FileTypes=[\"*.m, *.mdl\"], TextPattern=\"\"Copyright\"\", IgnoreCase=false, MatchWholeWord=false)\n","truncated":false}}
%---
