# Motor Drive Unit Component

This is a model of motor drive unit (MDU),
which is a system consisting of an electric motor and a controller.
The MDU model included in this component is abstract
and simulates the high-level behavior of power conversion
between electric power and mechanical power
with considerations for power conversion efficiency.

The core system equations of the MDU model are
generally as follows.

```text
J*dw/dt = trq_rot + trq_cmd - k*w
power_mech = trq_cmd*w
power_elec = i*V
power_elec = power_mech + losses_elec
```

where

- `J` ... motor inertia (parameter)
- `t` ... time (independent variable)
- `w` ... rotor angular speed (state)
- `trq_rot` ... torque at motor rotor
- `trq_cmd` ... torque command input
- `k` ... rotor frictional damping coefficient (parameter)
- `power_mech` ... mechanical power (intermediate variable)
- `power_elec` ... electrical power (intermediate variable)
  The sign indicates if the system is
  generating or consuming electric power.
- `losses_elec` ... electrical losses (parameter)
  This  can be modelled as a scalar constant,
  a formula as a function of motor speed etc.,
  or a tabulated map.
- `i` ... electric current (connected to DC power supply)
- `V` ... voltage drop (connected to DC power supply)

This component provides the following models
based on the above formulation.
These models are all abstract and run fast
and yet they have different fidelity levels.

**Basic** model (`MotorDriveUnit_refsub_Basic`)
is the simplest model with the fewest parameters.
It uses [Motor & Drive block][url-motordrive-driveline] from Simscape Driveline.
This model takes torque command and computes motor speed
using a simple formula for power conversion between
electrical and mechanical powers.
This model does not simulate temperature dynamics.
See **Notes** folder for more details about motor efficiency.

[url-motordrive-driveline]: https://www.mathworks.com/help/sdl/ref/motordrive.html

**Basic thermal** model (`MotorDriveUnit_refsub_BasicThermal`)
uses [Motor & Drive block][url-motordrive-driveline],
which is the same block as the above "Basic" model uses,
but with thermal model enabled.

**Tabulated** model (`MotorDriveUnit_refsub_Tabulated`)
takes torque command and computes motor speed
which is the same as the other models,
but for power conversion efficiency/loss
it uses a tabulated map instead of a formula.
Thermal model is disabled, but you can enable it
if you have two data sets of efficiency
measured at two different temperatures.
This model uses [Motor & Drive (System-Level) block][url-motordrive-elec]
from Simscape Electrical.

[url-motordrive-elec]: https://www.mathworks.com/help/sps/ref/motordrivesystemlevel.html

## Harness model

To run simulation with the above models,
use a harness model in `Harness` folder.

- `MotorDriveUnit_harness_model.mdl`

You can select the model using buttons
in `Configuration` block.

## Test Cases

`TestCases` folder contains Live Scripts
that are used to visually inspect the simulation behaviors
of the models in various simulation scenarios as follows.

- Constant ...
  All inputs are constant.
  This is used to check that the harness model runs.

- Drive ...
  Motor drives axle by consuming electric power.

- Regenerative braking ...
  Axle drives motor, and motor generates electric power.

- Random ....
  Input signals for motor torque command and axle load torque
  are randomly generated.

_Copyright 2022-2023 The MathWorks, Inc._
