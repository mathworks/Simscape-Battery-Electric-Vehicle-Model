%[text] # findLookupTable1DBlocks sample script
model_name = "testmodel_findLookupTable1DBlocks_refsub";
load_system(model_name)
blocks = ModelTool2.findLookupTable1DBlocks(model_name);
disp(blocks) %[output:90318ad7]
%[text] 
blocks = ModelTool2.findLookupTable1DBlocks(model_name, SearchDepth=1);
disp(blocks) %[output:0326a7ad]
%[text] 
blocks = ModelTool2.findLookupTable1DBlocks(model_name+"/Subsystem", SearchDepth=1);
disp(blocks) %[output:95156dd3]
%[text] *Copyright 2025 The MathWortks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:90318ad7]
%   data: {"dataType":"text","outputData":{"text":"    \"testmodel_findLookupTable1DBlocks_refsub\/PS Lookup Table (1D)\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/PS Lookup Table (1D)1\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/Subsystem\/PS Lookup Table (1D)\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/Subsystem\/Subsystem\/PS Lookup Table (1D)\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/Subsystem\/Subsystem1\/PS Lookup Table (1D)\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/PWC\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/SL smooth1\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/SL smooth2\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/Subsystem\/1-D Lookup↵Table\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/Subsystem\/Subsystem\/1-D Lookup↵Table\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/Subsystem\/Subsystem1\/1-D Lookup↵Table\"\n\n","truncated":false}}
%---
%[output:0326a7ad]
%   data: {"dataType":"text","outputData":{"text":"    \"testmodel_findLookupTable1DBlocks_refsub\/PS Lookup Table (1D)\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/PS Lookup Table (1D)1\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/PWC\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/SL smooth1\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/SL smooth2\"\n\n","truncated":false}}
%---
%[output:95156dd3]
%   data: {"dataType":"text","outputData":{"text":"    \"testmodel_findLookupTable1DBlocks_refsub\/Subsystem\/PS Lookup Table (1D)\"\n    \"testmodel_findLookupTable1DBlocks_refsub\/Subsystem\/1-D Lookup↵Table\"\n\n","truncated":false}}
%---
