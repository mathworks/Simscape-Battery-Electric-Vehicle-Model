%[text] # Set up Probe block's output port label
%[text] Axle side
probe_settings = local_setup("Inputs_Reducer_AxleSide_Constant_refsub");
disp(probe_settings) %[output:7a4d6e79]
%[text] Motor side
probe_settings = local_setup("Inputs_Reducer_MotorSide_Constant_refsub");
disp(probe_settings) %[output:327bcc7e]
%%
function probe_settings = local_setup(model_name)

load_system(model_name)

probe_block_path = model_name + "/Input torque probe";

target_block_path = model_name + "/Input torque";

% Link the Probe block to a target block.
simscape.probe.setBoundBlock(probe_block_path, target_block_path)

% Set up the Probe settings.
probe_settings = simscape.probe.getVariableTable(probe_block_path);
probe_settings("O").PortLabel = "Torque";
probe_settings("O").Probing = true;
probe_settings("O").Unit = "N*m";
simscape.probe.setVariableTable(probe_block_path, probe_settings)

probe_settings = simscape.probe.getVariableTable(probe_block_path);

end  % local function
%[text] *Copyright 2025-2026 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:7a4d6e79]
%   data: {"dataType":"text","outputData":{"text":"  VariableTable with 1 variable(s):\n\n            <strong>Unit<\/strong>      <strong>PortLabel<\/strong>    <strong>Probing<\/strong>\n           <strong>_______<\/strong>    <strong>_________<\/strong>    <strong>_______<\/strong>\n\n    <strong>O ⟼<\/strong>    {[N*m]}    \"Torque\"      true  \n\n","truncated":false}}
%---
%[output:327bcc7e]
%   data: {"dataType":"text","outputData":{"text":"  VariableTable with 1 variable(s):\n\n            <strong>Unit<\/strong>      <strong>PortLabel<\/strong>    <strong>Probing<\/strong>\n           <strong>_______<\/strong>    <strong>_________<\/strong>    <strong>_______<\/strong>\n\n    <strong>O ⟼<\/strong>    {[N*m]}    \"Torque\"      true  \n\n","truncated":false}}
%---
