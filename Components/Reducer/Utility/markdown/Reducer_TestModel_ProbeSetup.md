
# <span style="color:rgb(213,80,0)">Set up Probe blocks for the test model</span>
```matlab
model_name = "Reducer_TestModel";
load_system(model_name)
```
# Probe block on the axle side
```matlab
target_block_path = model_name + "/Input/Axle side input torque";
probe_block_path = model_name + "/Input/Axle Input Probe";
probe_default_setting = simscape.probe.defaultVariableTable(target_block_path);
disp(probe_default_setting)
```

```matlabTextOutput
  VariableTable with 2 variable(s):

            Unit     PortLabel    Probing
           ______    _________    _______

    I ⟼    {[""]}       "I"        false 
    O ⟼    {[""]}       "O"        false 
```


Bind the Probe block to the target block.

```matlab
simscape.probe.setBoundBlock(probe_block_path, target_block_path)
simscape.probe.setVariables(probe_block_path, "O");
```

Set up the Probe.

```matlab
probe_setting = simscape.probe.getVariableTable(probe_block_path);
probe_setting("O").PortLabel = "Axle input";
probe_setting("O").Probing = true;
probe_setting("O").Unit = "N*m";
simscape.probe.setVariableTable(probe_block_path, probe_setting)
probe_setting = simscape.probe.getVariableTable(probe_block_path);
disp(probe_setting)
```

```matlabTextOutput
  VariableTable with 1 variable(s):

            Unit       PortLabel      Probing
           _______    ____________    _______

    O ⟼    {[N*m]}    "Axle input"     true  
```

# Probe block on the motor side
```matlab
target_block_path = model_name + "/Input/Motor side input torque";
probe_block_path = model_name + "/Input/Motor Input Probe";
probe_default_setting = simscape.probe.defaultVariableTable(target_block_path);
disp(probe_default_setting)
```

```matlabTextOutput
  VariableTable with 2 variable(s):

            Unit     PortLabel    Probing
           ______    _________    _______

    I ⟼    {[""]}       "I"        false 
    O ⟼    {[""]}       "O"        false 
```


Bind the Probe block to the target block.

```matlab
simscape.probe.setBoundBlock(probe_block_path, target_block_path)
simscape.probe.setVariables(probe_block_path, "O");
```

Set up the Probe.

```matlab
probe_setting = simscape.probe.getVariableTable(probe_block_path);
probe_setting("O").PortLabel = "Motor input";
probe_setting("O").Probing = true;
probe_setting("O").Unit = "N*m";
simscape.probe.setVariableTable(probe_block_path, probe_setting)
probe_setting = simscape.probe.getVariableTable(probe_block_path);
disp(probe_setting)
```

```matlabTextOutput
  VariableTable with 1 variable(s):

            Unit        PortLabel      Probing
           _______    _____________    _______

    O ⟼    {[N*m]}    "Motor input"     true  
```


*Copyright 2025 The MathWorks, Inc.*

