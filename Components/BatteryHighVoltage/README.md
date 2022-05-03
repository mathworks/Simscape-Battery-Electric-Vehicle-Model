# Component / High Voltage Battery

Component to simulate the electrical
(and optionally thermal) dynamics
of a high voltage battery pack.

The most basic version `BatteryHV_refsub_Basic` computes
the voltage and current of the battery
with no temperature dependence.

To consider the battery temperature,
`BatteryHV_refsub_Driveline` uses
the [Battery block from Simscape Driveline][url-drv-batt].

[url-drv-batt]: https://www.mathworks.com/help/physmod/sdl/ref/batterysystemlevel.html

For more battery behaviors such aging,
`BatteryHV_refsub_Electrical` uses
the [Battery block from Simscape Electrical][url-elec-batt]

[url-elec-batt]: https://www.mathworks.com/help/physmod/sps/ref/battery.html

## Harness Model

<img src="images/image_BatteryHV_harness_model.png"
 width="700" alt="Harness Model for High Voltage Battery Component">

## Main Component Subsystem

Basic version

<img src="images/image_BatteryHV_refsub_Basic.png"
 width="600" alt="Vehicle 1D Component">

*Copyright 2022 The MathWorks, Inc.*
