%[text] # setSystemMaskIcon sample script
%[text] Run this script section by section manually. Running this script all at once deletes the created model file at the last section, and you can't see the model.
%%
%[text] Running the function without any arguments creates a new referenced subsystem file with a system mask icon being set.
%[text] If you run this section only, a new referenced subsystem model file is created with the default icon label.
% Start this script cleanly.
bdclose all

refsub_name = ModelTool1.setSystemMaskIcon;

disp("Created: <a href=""matlab:" + refsub_name + """>" + refsub_name + "</a>") %[output:35e9223a]
%[text] Open the model and see the block icon in the System Mask Editor.
%%
%[text] Running this section updates the icon label.
ModelTool1.setSystemMaskIcon(refsub_name, "New Text")
%[text] Open the model and see the updated block icon in the System Mask Editor.
%%
%[text] Clean up.
target_filename = refsub_name + ".mdl";
target_filefullpath = FileTool2.getFileFullPath(target_filename, ReturnIfNotFound=true);
if target_filefullpath == ""
  target_filename = refsub_name + ".slx";
  target_filefullpath = FileTool2.getFileFullPath(target_filename);
end  % if
disp("Deleting: " + target_filename) %[output:422926e8]
delete(target_filefullpath)
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:35e9223a]
%   data: {"dataType":"text","outputData":{"text":"Created: <a href=\"matlab:default_refsub2\">default_refsub2<\/a>\n","truncated":false}}
%---
%[output:422926e8]
%   data: {"dataType":"text","outputData":{"text":"Deleting: default_refsub2.mdl\n","truncated":false}}
%---
