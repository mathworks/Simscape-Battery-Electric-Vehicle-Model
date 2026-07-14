# Change Log and What's New

## What's New in 3.3 (November 2025)

- The project is upgraded to R2025b.

## What's New in 3.2 (August 2025)

Improved Reducer component resources

- Updated the test inputs for the harness model to use Referenced Subsystems.

Improved testing

- More unit tests and the `buildfile.m` files for the Build Tool are added.
  In particular, tests for Button blocks' callbacks are added to check
  that the callbacks work as expected.

Improved code quality

- Custom rules for MATLAB code are added for MATLAB Code Analyzer.
  The rules are to remind developers to follow best practices and coding standards.
  See the `codeAnalyzerConfiguration.json` file in the Project root > resources folder.
  Custom rules are also used by the Editor and by the build tool's CodeIssues task.

## What's New in 3.1 (August 2025)

Improved signal design for lookup table blocks

- Smooth signals (a.k.a. Akima spline) and piece-wise linear signals
  for lookup table blocks are now designed with the Signal Tool,
  which is stored in the Project root > Utility > SignalTool.
- The Signal Tool provides MATLAB functions and Apps for designing signal traces.
  The tool works with Simscape PS Lookup Table (1D) blocks and
  Simulink 1-D Lookup Table blocks.
- The Signal Tool has replaced the Signal Designer.
  The Signal Designer provided Simulink custom block library for designing and using
  smooth or linear signals.
  With the Signal Tool, signal design process is isolated from signal usage process.
  Models containing lookup tables do not depend on the Signal Tool.
- Timed Trace Builder App is added to the project.
  The app is a uifigure-based app built with the Signal Tool.
  The app is used to design timed signal traces with high-level properties.
  Generated data are used in some lookup tables as simulation inputs.

Streamlined model set up

- Selecting a referenced subsystem is done by clicking a button
  placed right next to the Subsystem Reference block.
- Custom functions to change a referenced subsystem have been removed.
- The Inputs blocks in harness models are now Referenced Subsystems.
  Some smooth signal traces in the Inputs are now designed by the Signal Tool.

Improved isolation of simulation case scripts

- Simulation case scripts directly use the product API as much as possible.
  The simulation case scripts for the same model do very similar operations
  that were used to be managed by custom functions to avoid writing similar code
  in multiple places.
  However, the use of custom functions was making the comprehension
  and modifications of the scripts hard.
  The scripts are now more isolated from each other and easier to figure out
  how to modify individually.

Improved discoverability and organization of test files

- Test files are stored in the same folder with their targets.
- Test files are named as `unittest_*`, `uitest_*`, `uptodatetest_*`, or
  `uiuptodatetest_*` so that the purpose of each test file is clear from its file name.
- Separating test files by their purpose makes it easy to run related tests only.

Better organization of utility tools

- Utility tools are now organized into separate name spaces based on their functionality.
  See the folders in the Project root > Utility.

## Whats' New in 3.0 (July 2025)

### Plain-text Live Scripts

From R2025a, you can save Live Scripts as plain-text files.

- MATLAB: [Live Code File Format (.m)][doc-m-live-script]

All Live Scripts in the project are now plain-text with `.m` extensions.
The use of plain-text files improves the compatibility with source control systems.
Text-based search and replace work with not only conventional MATLAB code files but
also all Live Script files in the project.

[doc-m-live-script]: https://www.mathworks.com/help/matlab/matlab_prog/plain-text-file-format-for-live-scripts.html

### Revamped Component Folders

A model for testing a component is now placed in the component top folder.
This improves the discoverability of models for component testing.

Component models that are built as Referenced Subsystems such as Basic model or System model
are stored in separate subfolders, such as Model-Basic or Model-System, respectively.
Related resources for a referenced subsystem including simulation case scripts and
test code files are saved in the same folder, improving the isolation of each component model.

### Unit testing with Build Tool and `buildfile.m`

For running unit tests,
the project now uses the Build Tool with `buildfile.m`.

- MATLAB: [Overview of MATLAB Build Tool][doc-buildtool]

From R2025a, you can run Build Tool tasks using the Run Build button in the Toolstrips
in addition to using the `buildtool` command on the Command Window.

- MATLAB: [Run Build from Toolstrip][doc-buildtool-toolstrip]

This project has several `buildfile.m` files.
The Editor recognizes the `buildfile.m` file as a Build Tool file
and shows the Run Build button in the Editor Toolstrip.
The project finds the `buildfile.m` file in the project root folder
and shows the Run Build button in the Project Toolstrip.

[doc-buildtool]: https://www.mathworks.com/help/matlab/matlab_prog/overview-of-matlab-build-tool.html
[doc-buildtool-toolstrip]: https://www.mathworks.com/help/matlab/matlab_prog/run-build-from-toolstrip.html

### Updated Reducer Component

Reducer component now has a test model and supporting files.

Also, the Reducer component uses Simscape selective data logging, which
simplifies the way data in Simscape blocks is logged during simulation.
Other components will use the same approach in the future.

- Simscape: [Log Selected Block Variables][doc-simscape-logging-graphical]
- Simscape: [Log Selected Variables Programmatically][doc-simscape-logging-programmatic]

[doc-simscape-logging-graphical]: https://www.mathworks.com/help/simscape/ug/log-individual-block-variables.html
[doc-simscape-logging-programmatic]: https://www.mathworks.com/help/simscape/ug/manage-selective-logging-instrumentation-programmatically.html

#### Signal Design App

To edit physical input signals using PS Lookup Table (1D) blocks
in the Reducer component, Signal Tool is used.

- For graphically editing signals, you can use `SignalDesignApp`
  which is included in the project and you can find in Project root > Utility > SignalTool folder.

- For programmatically editing signals, you can use functions in the `SignalTool1` name space.
  See the Live Scripts in Project root > Components > Reducer > Model-Basic > SimulationCases
  folder for example usages.

## What's New in 2.6 (June, 2025)

- The project has been updated to MATLAB R2025a with some clean ups.
- Some Live Scripts have been converted to
  the new [plain text Live Code file format][doc-text-live-script] (`.m`)
  which works well with source control.

[doc-text-live-script]: https://www.mathworks.com/help/matlab/matlab_prog/plain-text-file-format-for-live-scripts.html

## What's New in 2.5 (June, 2025)

BEV Project

- The BEV Project Navigator app has been updated.

Motor Drive Unit component

- The folder organization of the component has been updated.
  Different models are stored in different folders.
  Related files for a model such as test scripts and apps are put in the same folder.
- Motor Drive Unit Efficiency apps have been added to the Basic model and
  the System Thermal model.
- Motor Drive Unit App has been added to help select MDU model and simulation case.
- The Build Tool is used to check code and run tests.

Vehicle1D component

- The folder organization of the component has been updated.
- Vehicle1D Performance Design app has been updated.
- The Build Tool is used to check code and run tests.

## Version 2.4.2 (March 2025)

- Motor PMSM FEM: Update the link to the shipping example.

## Version 2.4.1 (January 2025)

- GitHub Actions workflow has been updated to run tests on Windows
  in addition to Linux.

## Version 2.4.0 (November, 2024)

- The project has been updated to MATLAB R2024b with some clean ups.
- Added brief entry-point descriptions about MATLAB project and Git
  to [Using MATLAB Project](docs/Using-MATLAB-Project.md).
  The page also provides links to product documentation for more information.
- Vehicle1D copmonent has been updated to check that all Live Scripts
  in SimulaitonCases folder are exported to Markdown files.

## What's New in 2.4 (November, 2024)

- The project has been updated to MATLAB R2024b with some clean ups.
- Added brief entry-point descriptions about MATLAB project and Git
  to [Using MATLAB Project](docs/Using-MATLAB-Project.md).
  The page also provides links to product documentation for more information.


## Version 2.3.2 (August, 2024)

- Make sure buildtool-based tests all pass.
- Update live script to markdown.
- Add the project navigator app. Clean up project shortcuts.

## Version 2.3.1 (June, 2024)

- Use easy-to-find locations to store markdowns generated from live scripts.
- Add a project shortcut to Vehicle1D performance design app.

## Version 2.3.0 (June, 2024)

App

- Vehicle1D performance design app is added.

Files and folders organization

- **Simplified filenames**:
  Use shorter file names for the models and scripts.
  For example, "Case" is used instead of "simulationCase"
  in filenames for some Live Scripts.

GitHub repository UX

- Sinced 2.2.0, Live Scripts were converted to Jupiter Notebooks
  so that they could be viewed directly in GitHub web site in the browser.
  Now Markdown files are used instead of Jupyter Notebooks.
  Markdown files are stored under the "Markdowns" folder
  for the corresponding Live Scripts.
  This also cleanups the folders with Live Scripts and
  improves the navigation in the folder tree.

GitHub Actions

- Use matlab-actions/setup-matlab@v2 in GitHub Actions workflow.

## What's New in 2.3 (June, 2024)

- The project has been updated to MATLAB R2024a.
- Vehicle1D performance design app is added.
- For veiwing Live Scripts in the GitHub web site in the browser,
  they are converted to Markdown files and collected in the Markdown folder.

## Version 2.2.2 (December, 2023)

- `buildfile.m` for MATLAB Build Tool to run tests has been updated.
- Build Tool is now used to run tests in Battery High Voltage component.

## Version 2.2.1 (October, 2023)

- Detailed PMSM application now uses a new parameterization for
  FEM parameterized PMSM block.

## Version 2.2.0 (September, 2023)

- The project has been updated to use MATLAB R2023b.
- [MATLAB Build Tool][url-buildtool] is used to automatically generate
  HTML files and Jupyter notebooks from all Live Scripts in the project.
  Jyputer notebooks corresponding to Live Scripts are rendered in
  the repository web site in the browser.
- GitHub Actions generates test report and coverage report.

[url-buildtool]: https://www.mathworks.com/help/matlab/matlab_prog/overview-of-matlab-build-tool.html

## What's New in 2.2 (September, 2023)

- The project has been updated to MATLAB R2023b.
- [MATLAB Build Tool][url-buildtool] is used to automate tasks
  to generate HTML files and Jupyter notebooks from all Live Scripts
  in the project.
- GitHub Actions has been updated to generate and upload
  test report and coverage report.
- GitHub Actions also generates Jupyter notebooks from Live Scripts.
  Jupyter notebooks can be viewed in the repo in the browser.

[url-buildtool]: https://www.mathworks.com/help/matlab/matlab_prog/overview-of-matlab-build-tool.html

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

## What's New in 2.1 (March, 2023)

- The project has been updated to MATLAB R2023a.
- A shortcut button to open **MATLAB Test Manager**
  is added in the Project Shortcuts tab of the toolstrip.
  MATLAB Test Manager requires the **MATLAB Test** license.

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

## What's New in 2.0 (February, 2023)

- BEV system model uses updated components and
  has simpler and easier configurability
  for selecting vehicle speed reference input.
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
- A detailed battery model built with a custom Simscape library
  has been removed.
  [This project][url-bev] will remain focused
  on vehicle system-level applications using abstract models
  in future updates.
  A new project [Electric Vehicle Design with Simscape][url-bev-design]
  serves as an alternative for detailed model applications.

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

_Copyright 2021-2026 The MathWorks, Inc._
