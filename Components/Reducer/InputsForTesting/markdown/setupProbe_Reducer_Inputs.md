
# <span style="color:rgb(213,80,0)">Set up Probe block's output port label</span>
```matlab
model_name = "Inputs_Reducer_AxleSide_Constant_refsub";
% model_name = "Inputs_Reducer_MotorSide_Constant_refsub";
```

```matlab
load_system(model_name)
probe_block_path = model_name + "/Input torque probe";
target_block_path = model_name + "/Input torque";
% probe_default_setting = simscape.probe.defaultVariableTable(target_block_path);
% disp(probe_default_setting)
```

Bind the Probe block to the target block.

```matlab
simscape.probe.setBoundBlock(probe_block_path, target_block_path)
simscape.probe.setVariables(probe_block_path, "O");
```

Configure the Probe's port label.

```matlab
probe_setting = simscape.probe.getVariableTable(probe_block_path);
probe_setting("O").PortLabel = "Torque";
probe_setting("O").Probing = true;
probe_setting("O").Unit = "N*m";
simscape.probe.setVariableTable(probe_block_path, probe_setting)
probe_setting = simscape.probe.getVariableTable(probe_block_path);
disp(probe_setting)
```

```matlabTextOutput
  VariableTable with 1 variable(s):

            Unit      PortLabel    Probing
           _______    _________    _______

    O ⟼    {[N*m]}    "Torque"      true  
```


*Copyright 2025 The MathWorks, Inc.*

