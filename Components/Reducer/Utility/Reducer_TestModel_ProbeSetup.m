%[text] # Set up Probe blocks for the test model
model_name = "Reducer_TestModel";
load_system(model_name)
%%
%[text] ## Probe block on the axle side
target_block_path = model_name + "/Input/Axle side input torque";
probe_block_path = model_name + "/Input/Axle Input Probe";
probe_default_setting = simscape.probe.defaultVariableTable(target_block_path);
disp(probe_default_setting) %[output:3922612b]
%[text] Bind the Probe block to the target block.
simscape.probe.setBoundBlock(probe_block_path, target_block_path)
simscape.probe.setVariables(probe_block_path, "O");
%[text] Set up the Probe.
probe_setting = simscape.probe.getVariableTable(probe_block_path);
probe_setting("O").PortLabel = "Axle input";
probe_setting("O").Probing = true;
probe_setting("O").Unit = "N*m";
simscape.probe.setVariableTable(probe_block_path, probe_setting)
probe_setting = simscape.probe.getVariableTable(probe_block_path);
disp(probe_setting) %[output:090cd35e]
%%
%[text] ## Probe block on the motor side
target_block_path = model_name + "/Input/Motor side input torque";
probe_block_path = model_name + "/Input/Motor Input Probe";
probe_default_setting = simscape.probe.defaultVariableTable(target_block_path);
disp(probe_default_setting) %[output:018533ec]
%[text] Bind the Probe block to the target block.
simscape.probe.setBoundBlock(probe_block_path, target_block_path)
simscape.probe.setVariables(probe_block_path, "O");
%[text] Set up the Probe.
probe_setting = simscape.probe.getVariableTable(probe_block_path);
probe_setting("O").PortLabel = "Motor input";
probe_setting("O").Probing = true;
probe_setting("O").Unit = "N*m";
simscape.probe.setVariableTable(probe_block_path, probe_setting)
probe_setting = simscape.probe.getVariableTable(probe_block_path);
disp(probe_setting) %[output:07850483]
%[text] *Copyright 2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:3922612b]
%   data: {"dataType":"text","outputData":{"text":"  VariableTable with 2 variable(s):\n\n            <strong>Unit<\/strong>     <strong>PortLabel<\/strong>    <strong>Probing<\/strong>\n           <strong>______<\/strong>    <strong>_________<\/strong>    <strong>_______<\/strong>\n\n    <strong>I ⟼<\/strong>    {[\"\"]}       \"I\"        false \n    <strong>O ⟼<\/strong>    {[\"\"]}       \"O\"        false \n\n","truncated":false}}
%---
%[output:090cd35e]
%   data: {"dataType":"text","outputData":{"text":"  VariableTable with 1 variable(s):\n\n            <strong>Unit<\/strong>       <strong>PortLabel<\/strong>      <strong>Probing<\/strong>\n           <strong>_______<\/strong>    <strong>____________<\/strong>    <strong>_______<\/strong>\n\n    <strong>O ⟼<\/strong>    {[N*m]}    \"Axle input\"     true  \n\n","truncated":false}}
%---
%[output:018533ec]
%   data: {"dataType":"text","outputData":{"text":"  VariableTable with 2 variable(s):\n\n            <strong>Unit<\/strong>     <strong>PortLabel<\/strong>    <strong>Probing<\/strong>\n           <strong>______<\/strong>    <strong>_________<\/strong>    <strong>_______<\/strong>\n\n    <strong>I ⟼<\/strong>    {[\"\"]}       \"I\"        false \n    <strong>O ⟼<\/strong>    {[\"\"]}       \"O\"        false \n\n","truncated":false}}
%---
%[output:07850483]
%   data: {"dataType":"text","outputData":{"text":"  VariableTable with 1 variable(s):\n\n            <strong>Unit<\/strong>        <strong>PortLabel<\/strong>      <strong>Probing<\/strong>\n           <strong>_______<\/strong>    <strong>_____________<\/strong>    <strong>_______<\/strong>\n\n    <strong>O ⟼<\/strong>    {[N*m]}    \"Motor input\"     true  \n\n","truncated":false}}
%---
