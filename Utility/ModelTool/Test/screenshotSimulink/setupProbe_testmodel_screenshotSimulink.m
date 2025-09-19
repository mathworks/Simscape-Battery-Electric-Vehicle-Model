%[text] # Set up Probe blocks
model_name = "testmodel_screenshotSimulink";
load_system(model_name)

target_block_path = model_name + "/Rotational Damper";
probe_block_path = model_name + "/Damper Probe";

simscape.probe.setBoundBlock(probe_block_path, target_block_path)
%[text] 
probe_default_setting = simscape.probe.defaultVariableTable(target_block_path);

probe_setting = simscape.probe.getVariableTable(probe_block_path);
probe_setting("w").PortLabel = "Damper speed";
probe_setting("w").Probing = true;
probe_setting("w").Unit = "rpm";
simscape.probe.setVariableTable(probe_block_path, probe_setting)
probe_setting = simscape.probe.getVariableTable(probe_block_path);
disp(probe_setting) %[output:136f765e]
%[text] Show the Unit information overlay.
set_param(model_name, ShowPortUnits = true)
set_param(model_name, SimulationCommand = "update")
%{
save_system(model_name)
%}
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:136f765e]
%   data: {"dataType":"text","outputData":{"text":"  VariableTable with 1 variable(s):\n\n            <strong>Unit<\/strong>        <strong>PortLabel<\/strong>       <strong>Probing<\/strong>\n           <strong>_______<\/strong>    <strong>______________<\/strong>    <strong>_______<\/strong>\n\n    <strong>w ⟼<\/strong>    {[rpm]}    \"Damper speed\"     true  \n\n","truncated":false}}
%---
