%[text] # searchText demo
result = FileTool3.searchText(...
  TargetFolder = pwd, ...
  IncludeSubfolders = false, ...
  FileTypes = ["*.m", "*.md"], ...
  TextPattern = "Copyright" );
disp(result.Properties.CustomProperties.TargetFolder) %[output:473448cd]
disp(height(result)) %[output:38652079]
disp(result) %[output:7e2920a1]
%%
%[text] Use the Filter option to apply an additional file filter.
% Find the *.m file excluding live scripts in the current folder.
result = FileTool3.searchText( ...
  TargetFolder = pwd, ...
  IncludeSubfolders = false, ...
  FileType = "*.m", ...
  TextPattern = "Copyright", ...
  Filter = @(x) not(FileTool3.isPlainTextLiveScript(x)));
disp(result.Properties.CustomProperties.TargetFolder) %[output:3d67ca5e]
disp(height(result)) %[output:28fd0b9b]
disp(result) %[output:4fc45672]
%%
result = FileTool3.searchText( ...
  TargetFolder = pwd, ...
  IncludeSubfolders = true, ...
  FileType = "testfunction*.m", ...
  TextPattern = "function" + whitespacePattern + "testfunction" );
assert(not(isempty(result)), "No match.")
disp(result.Properties.CustomProperties.TargetFolder) %[output:8c685ad7]
disp(height(result)) %[output:329f64a3]
disp(result) %[output:54530f14]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:473448cd]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:38652079]
%   data: {"dataType":"text","outputData":{"text":"    10\n\n","truncated":false}}
%---
%[output:7e2920a1]
%   data: {"dataType":"text","outputData":{"text":"                <strong>FilePath<\/strong>                <strong>LineNumber<\/strong>                         <strong>LineText<\/strong>                      \n    <strong>________________________________<\/strong>    <strong>__________<\/strong>    <strong>___________________________________________________<\/strong>\n\n    \"BEVProjectNavigationApp.m\"              5        \"% Copyright 2024-2025 The MathWorks, Inc.\"        \n    \"BEVProject_Description.m\"              35        \"%[text] *Copyright 2020-2025 The MathWorks, Inc.*\"\n    \"buildfile.m\"                           12        \"% Copyright 2023-2025 The MathWorks, Inc.\"        \n    \"uitest_BEVProject.m\"                   12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"      \n    \"uiuptodatetest_BEVProject.m\"           12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"      \n    \"unittest_BEVProject.m\"                 13        \"  % Copyright 2021-2025 The MathWorks, Inc.\"      \n    \"unittest_BEVProject_settings.m\"        15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"      \n    \"uptodatetest_BEVProject.m\"             15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"      \n    \"ChangeLog.md\"                         335        \"_Copyright 2021-2023 The MathWorks, Inc._\"        \n    \"README.md\"                            329        \"_Copyright 2020-2025 The MathWorks, Inc._\"        \n\n","truncated":false}}
%---
%[output:3d67ca5e]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:28fd0b9b]
%   data: {"dataType":"text","outputData":{"text":"     7\n\n","truncated":false}}
%---
%[output:4fc45672]
%   data: {"dataType":"text","outputData":{"text":"                <strong>FilePath<\/strong>                <strong>LineNumber<\/strong>                      <strong>LineText<\/strong>                   \n    <strong>________________________________<\/strong>    <strong>__________<\/strong>    <strong>_____________________________________________<\/strong>\n\n    \"BEVProjectNavigationApp.m\"              5        \"% Copyright 2024-2025 The MathWorks, Inc.\"  \n    \"buildfile.m\"                           12        \"% Copyright 2023-2025 The MathWorks, Inc.\"  \n    \"uitest_BEVProject.m\"                   12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"\n    \"uiuptodatetest_BEVProject.m\"           12        \"  % Copyright 2024-2025 The MathWorks, Inc.\"\n    \"unittest_BEVProject.m\"                 13        \"  % Copyright 2021-2025 The MathWorks, Inc.\"\n    \"unittest_BEVProject_settings.m\"        15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"\n    \"uptodatetest_BEVProject.m\"             15        \"  % Copyright 2021-2025 The MathWorks, Inc.\"\n\n","truncated":false}}
%---
%[output:8c685ad7]
%   data: {"dataType":"text","outputData":{"text":"C:\\local\\gh-isaacito12-bev\\bev25b\n","truncated":false}}
%---
%[output:329f64a3]
%   data: {"dataType":"text","outputData":{"text":"     1\n\n","truncated":false}}
%---
%[output:54530f14]
%   data: {"dataType":"text","outputData":{"text":"                                     <strong>FilePath<\/strong>                                     <strong>LineNumber<\/strong>             <strong>LineText<\/strong>         \n    <strong>__________________________________________________________________________<\/strong>    <strong>__________<\/strong>    <strong>__________________________<\/strong>\n\n    \"Utility\\FileTool\\Test\\searchText\\testfolder\\subfolder1\\testfunction_11.m\"        1         \"function testfunction_11\"\n\n","truncated":false}}
%---
