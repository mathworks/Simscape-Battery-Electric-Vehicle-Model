%[text] # checkRefSubInSetParam demo
%[text] This function is intended to check if `set_param` for a subsystem reference is referring to an existing referenced subsystem file.
codetext = "set_param(dummy_block_path, ReferencedSubsystem=""dummy_refsub.mdl"")";
result = ModelTool1.checkRefSubInSetParam(codetext);
disp(result) %[output:5d212d59]
%%
% Text consisting of multiple code lines.
codetext = [
  "% This line is ignored."
  "set_param(gcs, StopTime=""10"") % This line is ignored."
  "set_param(dummy_block_path, ReferencedSubsystem='testmodel_checkRefSubInSetParam.mdl')"
  " set_param(dummy_block_path, ""ReferencedSubsystem"", ""testmodel_checkRefSubInSetParam_refsub1.mdl"")"
  "set_param(dummy_block_path, 'ReferencedSubsystem' , 'testmodel_checkRefSubInSetParam_refsub2.mdl' )"
  "set_param(dummy_block_path, ReferencedSubsystem='dummy_refsub1.mdl')"
  " set_param(dummy_block_path, ""ReferencedSubsystem"", ""dummy_refsub2.mdl"")"
  "set_param(dummy_block_path, 'ReferencedSubsystem' , 'dummy_refsub3.mdl' )"
  ];
result = ModelTool1.checkRefSubInSetParam(codetext);
disp(result) %[output:524e9882]
%%
% Single line text containing all code.
codetext = join([
  "% This line is ignored."
  "set_param(gcs, StopTime=""10"") % This line is ignored."
  "set_param(dummy_block_path, ReferencedSubsystem='testmodel_checkRefSubInSetParam.mdl')"
  " set_param(dummy_block_path, ""ReferencedSubsystem"", ""testmodel_checkRefSubInSetParam_refsub1.mdl"")"
  "set_param(dummy_block_path, 'ReferencedSubsystem' , 'testmodel_checkRefSubInSetParam_refsub2.mdl' )"
  "set_param(dummy_block_path, ReferencedSubsystem='dummy_refsub1.mdl')"
  " set_param(dummy_block_path, ""ReferencedSubsystem"", ""dummy_refsub2.mdl"")"
  "set_param(dummy_block_path, 'ReferencedSubsystem' , 'dummy_refsub3.mdl' )"
  ], newline);
% Display additional information.
result = ModelTool1.checkRefSubInSetParam(codetext, DisplayInfo=true); %[output:1b253a90]
disp(result) %[output:9ea161c8]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:5d212d59]
%   data: {"dataType":"text","outputData":{"text":"         <strong>FileName<\/strong>         <strong>Found<\/strong>    <strong>IsRefSub<\/strong>\n    <strong>__________________<\/strong>    <strong>_____<\/strong>    <strong>________<\/strong>\n\n    \"dummy_refsub.mdl\"    false     false  \n\n","truncated":false}}
%---
%[output:524e9882]
%   data: {"dataType":"text","outputData":{"text":"                      <strong>FileName<\/strong>                       <strong>Found<\/strong>    <strong>IsRefSub<\/strong>\n    <strong>_____________________________________________<\/strong>    <strong>_____<\/strong>    <strong>________<\/strong>\n\n    \"testmodel_checkRefSubInSetParam.mdl\"            true      false  \n    \"testmodel_checkRefSubInSetParam_refsub1.mdl\"    true      true   \n    \"testmodel_checkRefSubInSetParam_refsub2.mdl\"    true      true   \n    \"dummy_refsub1.mdl\"                              false     false  \n    \"dummy_refsub2.mdl\"                              false     false  \n    \"dummy_refsub3.mdl\"                              false     false  \n\n","truncated":false}}
%---
%[output:1b253a90]
%   data: {"dataType":"text","outputData":{"text":"Checking code [1]: set_param(dummy_block_path, ReferencedSubsystem='testmodel_checkRefSubInSetParam.mdl')\nChecking code [2]: set_param(dummy_block_path, \"ReferencedSubsystem\", \"testmodel_checkRefSubInSetParam_refsub1.mdl\")\nChecking code [3]: set_param(dummy_block_path, 'ReferencedSubsystem' , 'testmodel_checkRefSubInSetParam_refsub2.mdl' )\nChecking code [4]: set_param(dummy_block_path, ReferencedSubsystem='dummy_refsub1.mdl')\nChecking code [5]: set_param(dummy_block_path, \"ReferencedSubsystem\", \"dummy_refsub2.mdl\")\nChecking code [6]: set_param(dummy_block_path, 'ReferencedSubsystem' , 'dummy_refsub3.mdl' )\n","truncated":false}}
%---
%[output:9ea161c8]
%   data: {"dataType":"text","outputData":{"text":"                      <strong>FileName<\/strong>                       <strong>Found<\/strong>    <strong>IsRefSub<\/strong>\n    <strong>_____________________________________________<\/strong>    <strong>_____<\/strong>    <strong>________<\/strong>\n\n    \"testmodel_checkRefSubInSetParam.mdl\"            true      false  \n    \"testmodel_checkRefSubInSetParam_refsub1.mdl\"    true      true   \n    \"testmodel_checkRefSubInSetParam_refsub2.mdl\"    true      true   \n    \"dummy_refsub1.mdl\"                              false     false  \n    \"dummy_refsub2.mdl\"                              false     false  \n    \"dummy_refsub3.mdl\"                              false     false  \n\n","truncated":false}}
%---
