%[text] # Find the `initial` variables used in the model
%[text] Some blocks in a model can contain base workspace variables in the block parameters that are used as initial values. This script searches the `initial` variables stored in block parameters in the specified model and shows the block path.
model_name = "BEV_system_model";
% Workspace variables must be loaded for the Simulink.findVars to work.
BEV_setup
%[text] 
load_system(model_name)
found_vars = Simulink.findVars(model_name);
% disp(vars)
var_names = string({found_vars.Name}');
% disp(varnames)
logical_index = var_names == "initial";
% Extract the variable corresponding to "initial"
ini_vars = found_vars(logical_index);
% disp(inivars);
ini_blocks = string(ini_vars.Users);
disp(ini_blocks) %[output:1174da9e]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:1174da9e]
%   data: {"dataType":"text","outputData":{"text":"    \"BEV_system_model\/High Voltage Battery\/Battery↵(System-Level)\"\n    \"BEV_system_model\/High Voltage Battery\/Battery Status\/Ambient temperature\"\n    \"BEV_system_model\/High Voltage Battery\/Battery Status\/HV battery temperature\"\n    \"BEV_system_model\/High Voltage Battery\/Battery Status\/IV Status\/Charge\"\n    \"BEV_system_model\/Longitudinal Vehicle\/Longitudinal Vehicle\"\n    \"BEV_system_model\/Motor Drive Unit\/Rotor inertia\"\n\n","truncated":false}}
%---
