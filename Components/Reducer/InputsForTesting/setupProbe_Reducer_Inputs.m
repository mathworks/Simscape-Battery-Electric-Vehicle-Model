%[text] # Set up Probe block's output port label
model_name = "Inputs_Reducer_AxleSide_Constant_refsub";
% model_name = "Inputs_Reducer_MotorSide_Constant_refsub";
%%
load_system(model_name)
probe_block_path = model_name + "/Input torque probe";
target_block_path = model_name + "/Input torque";
% probe_default_setting = simscape.probe.defaultVariableTable(target_block_path);
% disp(probe_default_setting)
%[text] Bind the Probe block to the target block.
simscape.probe.setBoundBlock(probe_block_path, target_block_path)
simscape.probe.setVariables(probe_block_path, "O");
%[text] Configure the Probe's port label.
probe_setting = simscape.probe.getVariableTable(probe_block_path);
probe_setting("O").PortLabel = "Torque";
probe_setting("O").Probing = true;
probe_setting("O").Unit = "N*m";
simscape.probe.setVariableTable(probe_block_path, probe_setting)
probe_setting = simscape.probe.getVariableTable(probe_block_path);
disp(probe_setting) %[output:33a83e30]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:33a83e30]
%   data: {"dataType":"text","outputData":{"text":"  VariableTable with 1 variable(s):\n\n            <strong>Unit<\/strong>      <strong>PortLabel<\/strong>    <strong>Probing<\/strong>\n           <strong>_______<\/strong>    <strong>_________<\/strong>    <strong>_______<\/strong>\n\n    <strong>O ⟼<\/strong>    {[N*m]}    \"Torque\"      true  \n\n","truncated":false}}
%---
