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

The harness model (`CtrlEnv_harness_model`)
in the `Harness` folder is used to test that
the Controller and Environment component loads and runs
in a closed loop model with a very simplistic vehicle plant.
Note that the vehicle plant used in the harness is
only for basic testing purpose,
and it should not be used for other purposes.

_Copyright 2023 The MathWorks, Inc._
