%[text] # getSimscapeValueFromBlockParameter sample script
model_name = "testmodel_getSimscapeValueFromBlockParameter";
%[text] ## Inertia block
block_path = model_name + "/Inertia";

param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "inertia");
disp(param) %[output:7a9d5796]
%[text] ## Inertia block with a variable in the base workspace
block_path = model_name + "/Inertia1";

evalin("base", "Inertia1_inertia = 12;")

param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "inertia");
disp(param) %[output:7b7ebd1b]
%[text] ## Inertia block with a struct in the base workspace
block_path = model_name + "/Inertia2";

evalin("base", "Inertia2.Inertia = 12;")

param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "inertia");
disp(param) %[output:029435b5]
%[text] ## PS Lookup Table (1D) block
block_path = model_name + "/PS Lookup Table (1D)";

param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "x");
disp(param) %[output:66d0145a]
param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "f");
disp(param) %[output:464b337e]
%[text] PS Lookup Table (2D) block
block_path = model_name + "/PS Lookup Table (2D)";

param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "x1");
disp(param) %[output:54604951]
param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "x2");
disp(param) %[output:992e6f39]
param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "f");
disp(param) %[output:02212529]
%[text] ## PS Lookup Table (3D) block
block_path = model_name + "/PS Lookup Table (3D)";

param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "x1");
disp(param) %[output:89fc2c62]
param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "x2");
disp(param) %[output:0ed9cfd6]
param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "x3");
disp(param) %[output:985ddee8]
param = ModelTool1.getSimscapeValueFromBlockParameter(block_path, "f");
disp(param) %[output:65b4d885]
%[text] *Copyright 2025 The* *`MathWorks, Inc.`*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:7a9d5796]
%   data: {"dataType":"text","outputData":{"text":"    0.0100 (kg*m^2)\n\n","truncated":false}}
%---
%[output:7b7ebd1b]
%   data: {"dataType":"text","outputData":{"text":"    12 (kg*m^2)\n\n","truncated":false}}
%---
%[output:029435b5]
%   data: {"dataType":"text","outputData":{"text":"    12 (kg*m^2)\n\n","truncated":false}}
%---
%[output:66d0145a]
%   data: {"dataType":"text","outputData":{"text":"     1     2     3     4     5\n\n    (1)\n\n","truncated":false}}
%---
%[output:464b337e]
%   data: {"dataType":"text","outputData":{"text":"     0     1     2     3     4\n\n    (1)\n\n","truncated":false}}
%---
%[output:54604951]
%   data: {"dataType":"text","outputData":{"text":"     1     2     3     4     5\n\n    (1)\n\n","truncated":false}}
%---
%[output:992e6f39]
%   data: {"dataType":"text","outputData":{"text":"     1     2     3     4     5\n\n    (1)\n\n","truncated":false}}
%---
%[output:02212529]
%   data: {"dataType":"text","outputData":{"text":"     0     1     2     3     4\n     1     2     3     4     5\n     2     3     4     5     6\n     3     4     5     6     7\n     4     5     6     7     8\n\n    (1)\n\n","truncated":false}}
%---
%[output:89fc2c62]
%   data: {"dataType":"text","outputData":{"text":"     1     2     3\n\n    (1)\n\n","truncated":false}}
%---
%[output:0ed9cfd6]
%   data: {"dataType":"text","outputData":{"text":"     1     2     3     4\n\n    (1)\n\n","truncated":false}}
%---
%[output:985ddee8]
%   data: {"dataType":"text","outputData":{"text":"     1     2     3\n\n    (1)\n\n","truncated":false}}
%---
%[output:65b4d885]
%   data: {"dataType":"text","outputData":{"text":"\n(:,:,1) =\n\n     1     1     1     1\n     1     1     1     1\n     1     1     1     1\n\n\n(:,:,2) =\n\n     1     1     1     1\n     1     1     1     1\n     1     1     1     1\n\n\n(:,:,3) =\n\n     1     1     1     1\n     1     1     1     1\n     1     1     1     1\n\n    (1)\n\n","truncated":false}}
%---
