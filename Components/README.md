# Components for BEV system model

This folder contains reusable components for
constructing BEV system model.
All components are abstract and
designed for vehicle system-level simulaiton.

Each component has reusable model(s) (`*_refsub_*.mdl`)
which can be used as a [Referenced Subsystem][url-refsub].
They are used separately in individual harness models
(`*_harness_model.mdl`) in each component folder
as well as together in BEV system model (`BEV_system_model.mdl`)
to build an integrated system model.

[url-refsub]: https://www.mathworks.com/help/simulink/ug/referenced-subsystem-1.html

Each component also has tests (`*_runtests.m`)
that can be run locally in your machine or
remotely as part of Continuous Integration (CI) process.
You can run tests locally by running the `*_runtests.m` script.
When running tests locally,
not only test results are reported,
but also MATLAB code coverage is measured and reported for
MATLAB code files at the end of the test.

## Components

- [Longitudinal vehicle][readme-veh] (`Vehicle1D`)
  computes longitudinal vehicle speed.

- [Reducder][readme-reducer] (`Reducer`) computes the behavior of
  torque and speed in the geartrain system
  between motor rotor and wheel hub.

- [Motor drive unit][readme-mdu] (`MotorDriveUnit`)
  computes the behavior of
  current and voltage of electrical system
  as well as torque and speed of motor rotor.
  This component optionally computes temperature dynamics.

- [High voltage battery][readme-hvbatt] (`BatteryHV`)
  computes the behavior of current, voltage,
  and optionally temperature of high voltage battery.

- [Controller and environment][readme-ctrlenv] (`CtrlEnv`)
  is a component containing a BEV Controller and driving environment
  for BEV system model.

<hr/>

Go to [BEV Project](../README.md).

_Copyright 2023 the MathWorks, Inc._

[readme-veh]: ../Components/Vehicle1D/README.md
[readme-reducer]: ../Components/Reducer/README.md
[readme-mdu]: ../Components/MotorDriveUnit/README.md
[readme-hvbatt]: ../Components/BatteryHighVoltage/README.md
[readme-ctrlenv]: ../Components/ControllerAndEnvironment/README.md
