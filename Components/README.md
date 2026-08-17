# Components for BEV system model

This folder contains reusable components for
constructing a system model of battery electric vehicles (BEVs).
All components are abstract and
designed for vehicle system-level simulation.

- [Longitudinal vehicle][readme-veh] (`Vehicle1D`)
  computes longitudinal vehicle speed.

- [Reducder][readme-reducer] (`Reducer`) computes
  the torque and speed of the geartrain system
  between motor rotor and wheel hub.

- [Motor drive unit][readme-mdu] (`MotorDriveUnit`)
  computes the current and voltage of the electrical system
  as well as the torque and speed of the motor.
  This component optionally computes temperature dynamics.

- [High voltage battery][readme-hvbatt] (`BatteryHV`)
  computes the current, voltage,
  and optionally temperature of the high voltage battery.

- [Controller and environment][readme-ctrlenv] (`CtrlEnv`)
  is a component containing a BEV Controller and driving environment
  for the BEV system model.

[readme-hvbatt]: ../Components/BatteryHighVoltage/README.md
[readme-ctrlenv]: ../Components/ControllerAndEnvironment/README.md
[readme-mdu]: ../Components/MotorDriveUnit/README.md
[readme-reducer]: ../Components/Reducer/README.md
[readme-veh]: ../Components/Vehicle1D/README.md

Each component provides models
as reusable [Referenced Subsystems][url-refsub] (`*_refsub.mdl`).
In each component folder, different models are separately saved in
different `Model-*` folders, such as `Model-Basic` or `Model-SystemThermal`.
Component models are built and stress-tested individually or
used with other components to build an integrated BEV system model
(`BEV_system_model.mdl`).

[url-refsub]: https://www.mathworks.com/help/simulink/ug/referenced-subsystem-1.html

Components are tested with the `*_TestModel.mdl` test models.
Each component has MATLAB unit tests
that can run locally in your machine or
remotely as part of Continuous Integration (CI) process.
You can run tests locally by running either the test code `test_*.m` or
the `buildfile.m`.
When running tests locally,
not only test results are reported,
but also MATLAB code coverage is measured and a coverage report
is created at the end of the test.

_Copyright 2023-2025 the MathWorks, Inc._
