# Vehicle speed reference

This is a vehicle speed reference component for
BEV system level simulation
and provides 5 different speed reference patterns by default:

1. Simple drive pattern (100 s)
2. High speed driving (200 s)
3. FTP-75 drive cycle (2474 s)
4. WLTP Class 3  drive cycle(1800 s)
5. Constant (1000 s)

You can use other drive cycles provided by
Drive Cycle Source block too.

This component is used in the **Controller and Environment** component.

The harness model (`VehSpdRef_harness_model`)
in the `Harness` folder is used to test that
all the cases load and run.

_Copyright 2023 The MathWorks, Inc._
