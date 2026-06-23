
# <span style="color:rgb(213,80,0)">Set up Probe block's output port label</span>
```matlab
model_name = "Inputs_Reducer_AxleSide_Constant_refsub";
% model_name = "Inputs_Reducer_MotorSide_Constant_refsub";

load_system(model_name)

probe_block_path = model_name + "/Input torque probe";

target_block_path = model_name + "/Input torque";

% Link the Probe block to a target block.
simscape.probe.setBoundBlock(probe_block_path, target_block_path)

% simscape.probe.setVariables(probe_block_path, "O");

% Set up the Probe settings.
probe_settings = simscape.probe.getVariableTable(probe_block_path);
probe_settings("O").PortLabel = "Torque";
probe_settings("O").Probing = true;
probe_settings("O").Unit = "N*m";
simscape.probe.setVariableTable(probe_block_path, probe_settings)

probe_settings = simscape.probe.getVariableTable(probe_block_path);
disp(probe_settings)
```

```matlabTextOutput
  VariableTable with 1 variable(s):

             Unit      PortLabel    Probing
            _______    _________    _______

    O ⟼    {[N*m]}    "Torque"      true  
```

*Copyright 2025\-2026 The MathWorks, Inc.*

