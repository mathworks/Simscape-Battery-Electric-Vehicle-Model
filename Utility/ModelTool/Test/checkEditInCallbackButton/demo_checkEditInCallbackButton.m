%[text] # checkEditInCallbackButton demo
model_name = "testmodel_checkEditInCallbackButton";
result = ModelTool2.checkEditInCallbackButton(model_name, DisplayInfo=true); %[output:378e0404]
disp(result) %[output:243c9eb5]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:378e0404]
%   data: {"dataType":"text","outputData":{"text":"Checking Callback Button [1]: testmodel_checkEditInCallbackButton\/Callback Button\nChecking Callback Button [2]: testmodel_checkEditInCallbackButton\/Callback Button1\nChecking code [1]: edit(\"demo_checkEditInCallbackButton\")\nChecking Callback Button [3]: testmodel_checkEditInCallbackButton\/Callback Button2\nChecking code [1]: edit(\"demo_checkEditInCallbackButton\")\nChecking code [2]: edit(\"demo_checkEditInCallbackButton\")\nChecking code [3]: edit(\"this_does_not_exist\")\n","truncated":false}}
%---
%[output:243c9eb5]
%   data: {"dataType":"text","outputData":{"text":"                          <strong>BlockPath<\/strong>                                    <strong>ArgumentToEdit<\/strong>             <strong>Found<\/strong>\n    <strong>______________________________________________________<\/strong>    <strong>________________________________<\/strong>    <strong>_____<\/strong>\n\n    \"testmodel_checkEditInCallbackButton\/Callback Button1\"    \"demo_checkEditInCallbackButton\"    true \n    \"testmodel_checkEditInCallbackButton\/Callback Button2\"    \"demo_checkEditInCallbackButton\"    true \n    \"testmodel_checkEditInCallbackButton\/Callback Button2\"    \"demo_checkEditInCallbackButton\"    true \n    \"testmodel_checkEditInCallbackButton\/Callback Button2\"    \"this_does_not_exist\"               false\n\n","truncated":false}}
%---
