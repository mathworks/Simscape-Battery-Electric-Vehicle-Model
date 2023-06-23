# Change Log

## Version 2.1.2 (June, 2023)

- Added hyperlinks in HTML files to open scripts or models in MATLAB.
- Models that were saved in previous release have been saved in R2023a.
- Electric ground block in the top layer of BEV system model has been
  moved into battery component so that
  the top layer of a system model represents system architecture only.

## Version 2.1 (March, 2023)

- The project has been updated to MATLAB R2023a.
- A shortcut button to open **MATLAB Test Manager**
  is added in the Project Shortcuts tab of the toolstrip.
  MATLAB Test Manager requires the **MATLAB Test** license.
- Callback Button blocks for configuring simulation cases were removed
  from all models.

## Version 2.0.1 (March, 2023)

- Updated screenshots of some models.
- Fixed a broken link to the license file in README.

## Version 2.0 (February, 2023)

Architecture

- BEV system model uses updated components and
  has simpler and easier configurability
  for selecting vehicle speed reference input.
- Components have been updated with cleaner architectures.
- Component inteface is defined by two types
  of [**Connection Bus**][url-cbus] objects.
  One is for high voltage electrical connection,
  the other is for rotational connection.
  Connection bus definitons help separate architecture and implementation,
  making component connection robust and scalable in large system modeling.
  Definition files can be found in the `Interface` folder.

[url-cbus]: https://www.mathworks.com/help/simulink/slref/simulink.connectionbus.html

Testing

- Components have individual harness models and tests.
- Tests for each component can be run by a test runner script
  which runs all tests in one go in each component
  and reports pass/fail summary.
- Test runner also measures MATLAB code coverage
  and generates a report.
  This allows us to perform test driven development.

Components

- High voltage battery component provides
  four different models:
  **Basic**, **System simple**, **System**, and **System tabulated**.
  They are all system level models and abstract,
  but they prodive different fidelity levels of the model.
  See [README](./Components/BatteryHighVoltage/README.md) in
  **Components > BatteryHighVoltage** for more details.
- Motor drive unit component provides
  four different models:
  **Basic**, **Basic thermal**, **System**, and **System tabulated**.
  They are all system level models and abstract,
  but they prodive different fidelity levels of the model.
  See [README](./Components/MotorDriveUnit/README.md) in
  **Components > MotorDriveUnit** for more details.

Input signal design

- A custom Simulink library providing Signal Source Blocks
  has been added.
  It streamlines the design, use, and modification of
  input signal patterns, both continuous and discrete ones.
  Blocks are built with a custom **Signal Designer** class.
  These are included in the `Utility` > `SignalDesigner` folder.

Detailed model applications

- A detailed battery model built with a custom Simscape library
  has been removed.
- [This project][url-bev] will focus on the vehicle system-level applications
  in future updates.
- A recently released new project
  [Electric Vehicle Design with Simscape][url-bev-design]
  serves as an alternative to explore detailed model applications.
  It provides BEV design workflows using detailed models
  for detailed analysis.

[url-bev]: https://www.mathworks.com/matlabcentral/fileexchange/82250
[url-bev-design]: https://www.mathworks.com/matlabcentral/fileexchange/124795

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

<hr>

Go to [README](../README.md) at the project top folder.

_Copyright 2021-2023 The MathWorks, Inc._
