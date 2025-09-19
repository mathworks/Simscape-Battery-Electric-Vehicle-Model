%[text] # checkEditInCode demo
result = ModelTool2.checkEditInCode("edit(""demo_checkEditInCallbackButton"")", DisplayInfo=true); %[output:769dd1df]
disp(result) %[output:61a579a5]
%%
result = ModelTool2.checkEditInCode("edit(""test1"")" + newline + "edit(""test2"")", DisplayInfo=true); %[output:33331f47]
disp(result) %[output:31788bdb]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:769dd1df]
%   data: {"dataType":"text","outputData":{"text":"Checking code [1]: edit(\"demo_checkEditInCallbackButton\")\n","truncated":false}}
%---
%[output:61a579a5]
%   data: {"dataType":"text","outputData":{"text":"          <strong>ArgumentPassedToEdit<\/strong>          <strong>Found<\/strong>\n    <strong>________________________________<\/strong>    <strong>_____<\/strong>\n\n    \"demo_checkEditInCallbackButton\"    true \n\n","truncated":false}}
%---
%[output:33331f47]
%   data: {"dataType":"text","outputData":{"text":"Checking code [1]: edit(\"test1\")\nChecking code [2]: edit(\"test2\")\n","truncated":false}}
%---
%[output:31788bdb]
%   data: {"dataType":"text","outputData":{"text":"    <strong>ArgumentPassedToEdit<\/strong>    <strong>Found<\/strong>\n    <strong>____________________<\/strong>    <strong>_____<\/strong>\n\n          \"test1\"           false\n          \"test2\"           false\n\n","truncated":false}}
%---
