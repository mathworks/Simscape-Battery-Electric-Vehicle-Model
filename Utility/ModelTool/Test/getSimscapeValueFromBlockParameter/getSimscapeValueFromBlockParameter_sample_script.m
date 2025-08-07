%[text] # getSimscapeValueFromBlockParameter sample script
model_name = "getSimscapeValueFromBlockParameter_TestModel";
%[text] ## Inertia block
block_path = model_name + "/Inertia";

param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "inertia");
disp(param) %[output:5189c755]
%[text] ## Inertia block with a variable in the base workspace
block_path = model_name + "/Inertia1";

evalin("base", "Inertia1_inertia = 12;")

param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "inertia");
disp(param) %[output:49c0f8a7]
%[text] ## Inertia block with a struct in the base workspace
block_path = model_name + "/Inertia2";

evalin("base", "Inertia2.Inertia = 12;")

param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "inertia");
disp(param) %[output:7cd1c5d6]
%[text] ## PS Lookup Table (1D) block
block_path = model_name + "/PS Lookup Table (1D)";

param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "x");
disp(param) %[output:98b3f3b4]
param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "f");
disp(param) %[output:040bd5e4]
%[text] PS Lookup Table (2D) block
block_path = model_name + "/PS Lookup Table (2D)";

param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "x1");
disp(param) %[output:132b607a]
param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "x2");
disp(param) %[output:8977c0a9]
param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "f");
disp(param) %[output:94a2788b]
%[text] ## PS Lookup Table (3D) block
block_path = model_name + "/PS Lookup Table (3D)";

param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "x1");
disp(param) %[output:6bb9b781]
param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "x2");
disp(param) %[output:2783b159]
param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "x3");
disp(param) %[output:866bd3ba]
param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "f");
disp(param) %[output:7a7928d5]
%[text] *Copyright 2025 The* *`MathWorks, Inc.`*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:5189c755]
%   data: {"dataType":"text","outputData":{"text":"    0.0100 (kg*m^2)\n\n","truncated":false}}
%---
%[output:49c0f8a7]
%   data: {"dataType":"text","outputData":{"text":"    12 (kg*m^2)\n\n","truncated":false}}
%---
%[output:7cd1c5d6]
%   data: {"dataType":"text","outputData":{"text":"    12 (kg*m^2)\n\n","truncated":false}}
%---
%[output:98b3f3b4]
%   data: {"dataType":"text","outputData":{"text":"     1     2     3     4     5\n\n    (1)\n\n","truncated":false}}
%---
%[output:040bd5e4]
%   data: {"dataType":"text","outputData":{"text":"     0     1     2     3     4\n\n    (1)\n\n","truncated":false}}
%---
%[output:132b607a]
%   data: {"dataType":"text","outputData":{"text":"     1     2     3     4     5\n\n    (1)\n\n","truncated":false}}
%---
%[output:8977c0a9]
%   data: {"dataType":"text","outputData":{"text":"     1     2     3     4     5\n\n    (1)\n\n","truncated":false}}
%---
%[output:94a2788b]
%   data: {"dataType":"text","outputData":{"text":"     0     1     2     3     4\n     1     2     3     4     5\n     2     3     4     5     6\n     3     4     5     6     7\n     4     5     6     7     8\n\n    (1)\n\n","truncated":false}}
%---
%[output:6bb9b781]
%   data: {"dataType":"text","outputData":{"text":"     1     2     3\n\n    (1)\n\n","truncated":false}}
%---
%[output:2783b159]
%   data: {"dataType":"text","outputData":{"text":"     1     2     3     4\n\n    (1)\n\n","truncated":false}}
%---
%[output:866bd3ba]
%   data: {"dataType":"text","outputData":{"text":"     1     2     3\n\n    (1)\n\n","truncated":false}}
%---
%[output:7a7928d5]
%   data: {"dataType":"text","outputData":{"text":"\n(:,:,1) =\n\n     1     1     1     1\n     1     1     1     1\n     1     1     1     1\n\n\n(:,:,2) =\n\n     1     1     1     1\n     1     1     1     1\n     1     1     1     1\n\n\n(:,:,3) =\n\n     1     1     1     1\n     1     1     1     1\n     1     1     1     1\n\n    (1)\n\n","truncated":false}}
%---
