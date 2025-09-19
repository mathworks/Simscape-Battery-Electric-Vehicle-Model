%[text] # refreshTextSearchResult demo
%[text] This function depends on the return value from the `searchText` function.
result = FileTool3.searchText(...
  TargetFolder = pwd, ...
  IncludeSubfolders = false, ...
  FileTypes = ["*.m", "*.md"], ...
  TextPattern = "Copyright 2024" );
% disp(result.Properties.CustomProperties.TargetFolder)
% disp(height(result))
% disp(result)
newresult = FileTool3.refreshTextSearchResult(result); %[output:10b38fa1]
% disp(result.Properties.CustomProperties.TargetFolder)
% disp(height(result))
% disp(result)
assert(result == newresult) %[output:7e634bb2]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:10b38fa1]
%   data: {"dataType":"text","outputData":{"text":"FileTool3.findText(TargetFolder=\"C:\\local\\bev\\bev25a\", IncludeSubfolders=false, FileTypes=[\"*.m\",\"*.md\"], TextPattern=\"Copyright 2024\", IgnoreCase=false, MatchWholeWord=false)\n","truncated":false}}
%---
%[output:7e634bb2]
%   data: {"dataType":"error","outputData":{"errorType":"runtime","text":"Error using <a href=\"matlab:matlab.lang.internal.introspective.errorDocCallback('assert')\" style=\"font-weight:bold\">assert<\/a>\nThe condition input argument must be convertible to a scalar logical."}}
%---
