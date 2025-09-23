%[text] # refreshTextSearchResult demo
%[text] This function depends on the return value from the `searchText` function.
% Preparation: First create a text search table.
original_result = TextSearchTool1.searchText(...
  TargetFolder = pwd, ...
  IncludeSubfolders = false, ...
  FileTypes = ["*.m", "*.md"], ...
  TextPattern = "Copyright 2024" );
%[text] In a real scenario, some of the files in the search result may be modified after the above search was performed, and the modifications may impact the search result. In this demo, no edits are made. Calling `refreshTextSearchResult` must produce the same result.
% !demo-target
new_result = TextSearchTool1.refreshTextSearchResult(original_result); %[output:1663d395]
%[text] Compare.
assert(all( size(new_result) == size(original_result) ))
assert(all( new_result.FilePath == original_result.FilePath ))
assert(all( new_result.LineNumber == original_result.LineNumber ))
assert(all( new_result.LineText == original_result.LineText ))
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:1663d395]
%   data: {"dataType":"text","outputData":{"text":"TextSearchTool1.searchText(TargetFolder=\"C:\\local\\gh-isaacito12-bev\\bev25b\", IncludeSubfolders=false, FileTypes=[\"*.m, *.md\"], TextPattern=\"\"Copyright 2024\"\", IgnoreCase=false, MatchWholeWord=false)\n","truncated":false}}
%---
