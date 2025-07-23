# Controller and Environment Component

This is a controller and environment component for
BEV system level simulation.
This component provides an abstract speed tracking controller
and environment such as road grade.

This component uses two subcomponents:

- [Vehicle Speed Reference][readme-vehspdref]
- [BEV Controller][readme-bevctrl]

[readme-vehspdref]: ../VehicleSpeedReference/README.md
[readme-bevctrl]: ../BEVController/README.md

The test model (`CtrlEnv_TestModel`) is used to test that
the Controller and Environment component loads and runs
in a closed loop model with a very simplistic vehicle plant.
Note that the vehicle plant used in the test model is
only for basic testing purpose,
and it is not designed for other purposes.

_Copyright 2023-2025 The MathWorks, Inc._
