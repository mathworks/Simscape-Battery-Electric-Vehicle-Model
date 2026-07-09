# Controller and Environment Component

This is a controller and environment component for
BEV system level simulation.
This component provides an abstract speed tracking controller
and environment such as road grade.
Currently this component provides a basic controller (`CtrlEnv_Basic_refsub`) in
the `Model-Basic` folder.

The component uses two other components:

- [Vehicle Speed Reference](../VehicleSpeedReference/README.md)
- [BEV Controller](../BEVController/README.md)

A harness model (`HarnessModel_CtrlEnv`) is used to test that
the Controller and Environment component loads and runs
in a closed loop model with a simple vehicle plant.
(The vehicle plant used in the test model is
only for basic testing purpose and not suitable for other purposes.)

_Copyright 2023-2026 The MathWorks, Inc._
