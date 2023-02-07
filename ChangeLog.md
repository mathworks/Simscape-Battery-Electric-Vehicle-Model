# Change Log

## Version 1.3 (January, 2023)

- Component inteface is defined by two types of Connection Bus objects.
  One is for high voltage electrical connection,
  the other is for rotational connection.
  Connection bus definitons help separate architecture and implementation,
  making component connection robust and scalable in large system modeling.
  Definition files can be found at `Interface` folder.
- High Voltage Battery component has been revamped by
  refactoring the models and scripts.
  It now has a table-based battery model too.
  Tests have also been updated.
- A custom Simulink library of Signal Source Blocks
  has been added.
  It streamlines input signal design and use.
  Blocks are built with a custom Signal Designer class.
  These are included in `Utility` > `SignalDesigner`.
  In this version, the updated high voltage battery component
  uses this tool.
  This will be deployed to other components and BEV system model
  in future updates.
- Detailed battery model built with custom Simscape library
  has been removed.
  An alternative will be provided using Simscape Battery
  in another project.
  This BEV project will focus on the vehicle system-level simulation.

## Version 1.2.2 (December, 2022)

- Fixed a broken link in the main script.
- Minor change in the value of road-load parameter A
  for the main BEV model.

## Version 1.2 (May, 2022)

Highlight

- GitHub Actions continuous integration has been enabled
  to automatically run tests
  when the repository at github.com recieves a push.
- Unit tests and harness models for the tests have been added
  to the BEV system model (`BEV`),
  high-voltage battery (`BatteryHighVoltage`) component,
  longitudinal vehicle (`Vehicle1D`) component, and
  detailed high-voltage battery (`BatteryHighVoltageDetailed`) component.
  More tests will be added in the coming updates.

MATLAB Release

- This version requires MATLAB R2022a or newer.

Project

- Files and folders were reorganized.
  `BEV` and `Components` folders contain abstract models only.
  Detailed models have been moved under `DetailedModelApplications` folder.

Models

- DAESSC solver is used.
- Simulink model files are saved in `mdl` format.
  Starting from R2021b, MDL format is based the new text format
  which is feature parity with binary SLX format.
- Abstract high-voltage battery component has
  three different fidelity levels;
  **isothermal** (same as before),
  **simple thermal** (newly added using
  System-Level Battery block from Simscape Driveline),
  and **thermal** (newly added using
  Battery block from Simscape Electrical).
  They all run fast.
- Longitudinal Vehicle block from Simscape Driveline is
  added as a new (and default) referenced subsystem.
  The previous custom block is still included too.

## Version 1.1 (October, 2021)

- A detailed high-voltage battery pack component is added.
- The BEV model supports three different component configurations
  using Subsystem Reference:
  1) All basic comopnents (same as version 1.0).
  2) [New] With a detailed high-voltage battery as grouped-single module.
  3) [New] With a detailed high-voltage battery as multi-module.
- A live script evaluating the BEV model with
  high-voltage battery component at different fidelity levels
  is added.
- This project requires MATLAB R2020b or newer.

## Version 1.0 (November, 2020)

Initial release

_Copyright 2021-2022 The MathWorks, Inc._
