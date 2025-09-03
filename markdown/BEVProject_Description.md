
# <span style="color:rgb(213,80,0)">Battery Electric Vehicle Model in Simscape</span>

Open the Project by double\-clicking **`BatteryElectricVehicle.prj`** file if you have not opened the project yet. Use an app **`BEVProjectNavigator`** to explore models and scripts in the project. If you are viewing this page in MATLAB's web browser or its original Live Script file in Editor, you can open the project navigator app from the link below.

-  [BEV Project Navigation App](matlab:BEVProjectNavigationApp) 
# Battery Electric Vehicle (BEV) Model for System Level Simulation

This is a simple, fast running BEV model which can estimate the electrical efficiency of the vehicle. It is also suitable for further customizations for more focused analysis of individual components at vehicle system level.


Open the [BEV system model](matlab:openInProject('BEV_system_model')). You can also use the shortcut button **BEV model** in the **Project Shortcuts** toolstrip.


Files related to the BEV system model can be found at **BEV** folder.

```matlab
imshow("screenshot-BEV_system_model.png")
```

<center><img src="media/BEVProject_Description_media/figure_0.png" width="834" alt="figure_0.png"></center>

# Vehicle Components
## Longitudinal Vehicle

Longitudinal abstract vehicle model can be used to find required powertrain performance (such as motor torque and power etc.) given basic vehicle performance specifications.


Open the [Vehicle 1D harness model](matlab:openInProject('HarnessModel_Vehicle1D')). You can simulate and analyse basic vehicle performance with the Vehicle1D harness model.


See **README.md** in the **Components > Vehicle1D** folder for more informaton.

```matlab
imshow("screenshot-Vehicle1D-performance-plot.png")
```

<center><img src="media/BEVProject_Description_media/figure_1.png" width="735" alt="figure_1.png"></center>

## High Voltage Battery Pack

Four different abstract models are available as a high voltage battery pack component.

-  **Basic** model simulates voltage and current. 
-  **Simple system** model simulates voltage, current, and temperature using equation\-based model. 
-  **System** model simulates voltage, current, temperature as well as charing dynamics, fading, and aging using equation\-based model. 
-  **Table\-based system** model simulates the same quantities as System model, but uses table data for terminal voltage and resistance. 

Open the [High voltage battery harness model](matlab:openInProject('HarnessModel_BatteryHV')).


See **README.md** in the **Components > BatteryHighVoltage** folder for more informaton.

## Motor Drive Unit

Four different abstract models are available as a motor drive unit component.

-  **Basic** model simulates the high level behavior of power conversion between electrical and mechanical powers. 
-  **Basic thermal** model is similar to Basic model, but this model considers temperature dynamics too. 
-  **System\-level thermal** model is similar to the above models, but this model considers irons loss and constant/fixed loss too. 
-  **System\-level model with tabulated losses** is similar to the above models, but this model uses tabulated data for power conversion efficiency or losses. 

Open the [Motor drive unit harness model](matlab:openInProject('HarnessModel_MotorDriveUnit')).


See **README.md** in the **Components > MotorDriveUnit** folder for more informaton including **single efficiency measurement model** used in Basic, Basic thermal, and System\-level models for electro\-mechanical power conversion.

## Other components

In addition to the above components, other components such as **Vehicle Speed Reference** component are stored in the **Components** folder too.


*Copyright 2020\-2025 The MathWorks, Inc.*

