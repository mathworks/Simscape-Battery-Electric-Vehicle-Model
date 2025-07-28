# Vehicle speed reference

This is a vehicle speed reference component for
BEV system level simulation
and provides 4 different speed reference patterns by default:

1. Simple drive pattern
2. High speed driving
3. FTP-75 drive cycle
4. Constant

This component is used in the **Controller and Environment** component.

The harness model (`VehSpdRef_harness_model`)
in the `Harness` folder is used to test that
all the cases can be loaded and run.

You can use other drive cycles, such as WLTP, provided by Drive Cycle Source block
if you install the [support package][url-pkg].

_Copyright 2023-2024 The MathWorks, Inc._

[url-pkg]: https://www.mathworks.com/help/autoblks/ug/install-drive-cycle-data.html
