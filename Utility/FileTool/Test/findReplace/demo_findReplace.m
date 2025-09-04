%[text] # findReplace demo
topfolder = fullfile(currentProject().RootFolder, "Utility", "FileTool", "Test", "findReplace", "testfolder");
result = FileTool3.findReplace(topfolder, DryRun=true, FileNamePattern="**/*.mdl", SearchWord="testing");
disp(result.Properties.UserData) %[output:43845893]
disp(result) %[output:10ca9f6e]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:43845893]
%   data: {"dataType":"text","outputData":{"text":"  <a href=\"matlab:helpPopup('dictionary')\" style=\"font-weight:bold\">dictionary<\/a> (<strong>string<\/strong> ⟼ <strong>string<\/strong>) with 2 entries:\n\n    \"SearchWord\" ⟼ \"testing\"\n    \"NewWord\"    ⟼ \"\"\n\n","truncated":false}}
%---
%[output:10ca9f6e]
%   data: {"dataType":"text","outputData":{"text":"                                                            <strong>FilePath<\/strong>                                                            <strong>Found<\/strong>    <strong>Replaced<\/strong>\n    <strong>________________________________________________________________________________________________________________________<\/strong>    <strong>_____<\/strong>    <strong>________<\/strong>\n\n    \"C:\\local\\gh-isaacito12-bev\\bev25a\\Utility\\FileTool\\Test\\findReplace\\testfolder\\subfolder1\\testmodel_findReplace_11.mdl\"    true      false  \n    \"C:\\local\\gh-isaacito12-bev\\bev25a\\Utility\\FileTool\\Test\\findReplace\\testfolder\\subfolder1\\testmodel_findReplace_12.mdl\"    true      false  \n    \"C:\\local\\gh-isaacito12-bev\\bev25a\\Utility\\FileTool\\Test\\findReplace\\testfolder\\subfolder2\\testmodel_findReplace_21.mdl\"    true      false  \n    \"C:\\local\\gh-isaacito12-bev\\bev25a\\Utility\\FileTool\\Test\\findReplace\\testfolder\\subfolder2\\testmodel_findReplace_22.mdl\"    true      false  \n    \"C:\\local\\gh-isaacito12-bev\\bev25a\\Utility\\FileTool\\Test\\findReplace\\testfolder\\testmodel_findReplace_1.mdl\"                true      false  \n    \"C:\\local\\gh-isaacito12-bev\\bev25a\\Utility\\FileTool\\Test\\findReplace\\testfolder\\testmodel_findReplace_2.mdl\"                true      false  \n\n","truncated":false}}
%---
