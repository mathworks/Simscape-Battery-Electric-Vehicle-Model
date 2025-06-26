# Battery Electric Vehicle Model in Simscape&trade;

[![View Battery Electric Vehicle Model in Simscape on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/82250-battery-electric-vehicle-model-in-simscape)

Version 2.6

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

<img src="BEV/Utility/screenshot-BEV_system_model.png"
 alt="Screenshot of the battery electric vehicle model"
 width="700">

<img src="BEV/Model-Basic/SimulationCases/markdown/media/BEV_Basic_FTP75_media/figure_0.png"
 alt="Screenshot of the simulation result plots"
 width="700">

Use **BEV Project Navigator App** to quickly access some key files and tools.

<img src="Utility/screenshot-BEV-project-navigator-app.png"
 alt="Screenshot of the longitudinal vehicle performance design app"
 width="450">

Use **Vehicle1D Performance Design App** to design the basic performance parameters
of a road vehicle.

<img src="Components/Vehicle1D/Utility-Vehicle1D/screenshot-Vehicle1DPerformanceDesignApp.png"
 alt="Screenshot of the longitudinal vehicle performance design app"
 width="700">

Use **Motor Drive Unit Efficiency App for System Thermal Model** to understand
how the model parameters are affecting the motor efficiency.

<img src="Components/MotorDriveUnit/Model-SystemThermal/screenshot-MotorDriveUnitEfficiencyApp_SystemThermal.png"
 alt="Screenshot of the motor drive unit efficiency app for system thermal model"
 width="700">

Use **Motor Drive Unit App** to select model and run simulation for the Motor Drive Unit.

<img src="Components/MotorDriveUnit/Utility-MDU/screenshot-MotorDriveUnitApp.png"
 alt="Screenshot of the motor drive unit app"
 width="440">

## What's New in 2.6 (June, 2025)

- The project has been updated to MATLAB R2025a with some clean ups.
- Some Live Scripts have been converted to
  the new [plain text Live Code file format][doc-text-live-script] (`.m`)
  which works well with source control.
- Past What's New contents up to version 2.4 have been moved to `ChangeLog.md`.

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

See [Change Log](ChangeLog.md) for more details.

## Tool Requirements

Supported MATLAB Version:
R2025a or newer releases

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

_Copyright 2020-2025 The MathWorks, Inc._
