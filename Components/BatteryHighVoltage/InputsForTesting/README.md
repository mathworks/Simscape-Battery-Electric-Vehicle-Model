# High Voltage Battery - Inputs for Testing

The `LoadInputs_BatteryHV_*.m` scripts in this folder
load data to the `batteryHV` struct in the base workspace.
The struct is used by lookup table blocks
in the `Inputs_BatteryHV_refsub` Inputs subsystem as input signals.

<img src="media/screenshot-Inputs_BatteryHV_refsub.png"
 alt="screenshot of the inputs referenced subsystem"
 width="800">

For example, the Random case (`LoadInputs_BatteryHV_Random`) sets up
the load currnet as follows.

<img src="media/plot-Inputs_BatteryHV_Random-LoadCurrent.png"
 alt="plot image of the random load current"
 width="800"> 

In the `HarnessModel_BatteryHV_Inputs` harness model,
the Inputs subsystem is used to test the high voltage battery component,
such as `BatteryHV_Basic_refsub.m` (in the `Model-Basic` folder).

## Test resources

This folder also contains resources to validate
the `LoadInputs_BatteryHV_*.m` scripts and the Inputs subsystem.
The `HarnessModel_BatteryHV_Inputs` model in this folder validates
the Input subsystem for different input signal cases.

<img src="media/screenshot-HarnessModel_BatteryHV_Inputs.png"
 alt="screenshot of the inputs referenced subsystem"
 width="800">

_Copyright 2026 The MathWorks, Inc._
