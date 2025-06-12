# Battery Electric Vehicle Model in Simscape&trade;

[![View Battery Electric Vehicle Model in Simscape on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/82250-battery-electric-vehicle-model-in-simscape)

Version 2.5

## Introduction

This is a MATLAB&reg; Project containing
a [Battery Electric Vehicle (BEV) model](BEV/README.md) and
its components such as
motor, high voltage battery, and longitudinal vehicle.
This project demonstrates Simscape's modular and
multi-fidelity modeling technology.

The abstract BEV model is built in a simple and modular fashion,
and it can run faster than real-time.
It is suitable as a baseline model for drive cycle simulation
to estimate vehicle's electrical efficiency and
other vehicle-level information.

This project also contains the model of a detailed
permanent magnet synchronous motor (PMSM) and controller.
It captures the detailed behaviors of the AC motor drive unit
and can estimate the electrical efficiency at the unit level.

A Live Script demonstrates how to obtain the electrical efficiency
from the slow but detailed motor drive unit and use the result
as the block parameter of the simple but fast motor drive block
in the BEV model.

<img src="BEV/Utility/Images/BEV_system_model_screenshot.png"
 alt="Screenshot of the battery electric vehicle model"
 width="700">

<img src="BEV/results/BEV_SimulationResultPlot.png"
 alt="Screenshot of the simulation result plots"
 width="700">

BEV Project navigator App

<img src="Utility/screenshot-BEV-project-navigator-app.png"
 alt="Screenshot of the longitudinal vehicle performance design app"
 width="450">

Vehicle1D Performance Design App

<img src="Components/Vehicle1D/Utility-Vehicle1D/screenshot-Vehicle1DPerformanceDesignApp.png"
 alt="Screenshot of the longitudinal vehicle performance design app"
 width="700">

Motor Drive Unit Efficiency App for System Thermal Model

<img src="Components/MotorDriveUnit/Model-SystemThermal/screenshot-MotorDriveUnitEfficiencyApp_SystemThermal.png"
 alt="Screenshot of the motor drive unit efficiency app for system thermal model"
 width="700">

Motor Drive Unit App

<img src="Components/MotorDriveUnit/Utility-MDU/screenshot-MotorDriveUnitApp.png"
 alt="Screenshot of the motor drive unit app"
 width="440">

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

## What's New in 2.4 (November, 2024)

- The project has been updated to MATLAB R2024b with some clean ups.
- Added brief entry-point descriptions about MATLAB project and Git
  to [Using MATLAB Project](docs/Using-MATLAB-Project.md).
  The page also provides links to product documentation for more information.

## What's New in 2.3 (June, 2024)

- The project has been updated to MATLAB R2024a.
- Vehicle1D performance design app is added.
- For veiwing Live Scripts in the GitHub web site in the browser,
  they are converted to Markdown files and collected in the Markdown folder.

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

## What's New in 2.1 (March, 2023)

- The project has been updated to MATLAB R2023a.
- A shortcut button to open **MATLAB Test Manager**
  is added in the Project Shortcuts tab of the toolstrip.
  MATLAB Test Manager requires the **MATLAB Test** license.

See [Change Log](ChangeLog.md) for more details.

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

See [Change Log](ChangeLog.md) for more details.

## Tool Requirements

Supported MATLAB Version:
R2024b or newer releases

Required:
[MATLAB](https://www.mathworks.com/products/matlab.html),
[Simulink&reg;](https://www.mathworks.com/products/simulink.html),
[Powertrain Blockset](https://www.mathworks.com/products/powertrain.html),
[Simscape](https://www.mathworks.com/products/simscape.html),
[Simscape Driveline&trade;](https://www.mathworks.com/products/simscape-driveline.html),
[Simscape Electrical&trade;](https://www.mathworks.com/products/simscape-electrical.html)

Optional:
[MATLAB Test](https://www.mathworks.com/products/matlab-test.html),
[Parallel Computing Toolbox&trade;](https://www.mathworks.com/products/parallel-computing.html)

## How to Use

Open `BatteryElectricVehicle.prj` in MATLAB, and
it will automatically open the project main page `BEV_main_script.html`.
The script contains the description of the model and
hyperlinks to models and scripts.

## How to Use in MATLAB Online

You can try this in [MATLAB Online][url_online].
In MATLAB Online, from the **HOME** tab in the toolstrip,
select **Add-Ons** &gt; **Get Add-Ons**
to open the Add-On Explorer.
Then search for the submission name,
navigate to the submission page,
click **Add** button, and select **Save to MATLAB Drive**.

[url_online]: https://www.mathworks.com/products/matlab-online.html

## Additional Notes

- [Using MATLAB Project](docs/Using-MATLAB-Project.md)

- [MATLAB Testing Framework](docs/MATLAB-Testing-Framework.md)

## See Also

[Hybrid Electric Vehicle Model in Simscape][url-hev-powersplit]
provides an abstract power-split HEV model.
The level of abstraction is similar to
this [BEV model in Simscape][url-bev] project.

[Electric Vehicle Design with Simscape][url-bev-design]
provides BEV design workflows using detailed models
for detailed analysis.
Note that the [BEV model in Simscape][url-bev] project
(the current project you are viewing) is focused on
vehicle system-level applications using abstract models.

[url-bev]: https://www.mathworks.com/matlabcentral/fileexchange/82250
[url-bev-design]: https://www.mathworks.com/matlabcentral/fileexchange/124795
[url-hev-powersplit]: https://www.mathworks.com/matlabcentral/fileexchange/92820

## License

See [`license.txt`](license.txt).

_Copyright 2020-2024 The MathWorks, Inc._
