# Vehicle speed reference

This folder contains a vehicle speed reference component.
The component acts as an external speed input representing a drive cycle.
A vehicle speed controller can use it as a speed reference together with
an actual vehicle speed to determine the command to control the longitudinal vehicle speed.

The component provides the following cases:
**Constant**, **Simple**, **High speed**, and **FTP-75**.

The Constant case outputs 0.

The Simple case provides a simple speed profile.

<img src="media/plot-VehSpdRef_Simple.png"
 width="700"
 alt="The Simple speed reference" />

The High speed case provides a speed profile at high-speed region.

<img src="media/plot-VehSpdRef_HighSpeed.png"
 width="700"
 alt="The High-speed speed reference" />

The Constant, Simple, and High speed cases are available
as `VehSpdRef_LookupTable_refsub`.

<img src="media/screenshot-VehSpdRef_LookupTable_refsub.png"
 width="700"
 alt="Subsystem with a Lookup Table block for vehicle speed reference" />

The FTP-75 case requires the license of the Powertrain Blockset or the Vehicle Dynamics Blockset.

<img src="media/screenshot-VehSpdRef_FTP75_refsub.png"
 width="450"
 alt="Subsystem with the Drive Cycle Source block for vehicle speed reference" />

To use additional drive cycles such as WLTP as a speed reference,
install the [Add-On][url-pkg] for the Drive Cycle Source block.

[url-pkg]: https://www.mathworks.com/help/autoblks/ug/install-drive-cycle-data.html

## Harness model

Use the harness model (`HarnessModel_VehSpdRef`) for testing the component.

<img src="media/screenshot-HarnessModel_VehSpdRef.png"
 width="800"
 alt="Harness model for the vehicle speed reference component" />

_Copyright 2023-2026 The MathWorks, Inc._
