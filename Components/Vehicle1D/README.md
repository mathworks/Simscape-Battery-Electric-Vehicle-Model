# Vehicle1D component

This is a component to compute the longitudinal speed of a road vehicle.
The main block of this component is
[Longitudinal Vehicle block][url-veh] from Simscape Driveline
which is an abstract model parameterized with commonly available
vehicle specifications such as vehicle weight, tire rolling radius, etc.

[url-veh]:https://www.mathworks.com/help/physmod/sdl/ref/longitudinalvehicle.html

A vehicle is characterized by longitudinal force and power as shown below.
These properties are the key information to design
overall vehicle performance.

<img src="AppFiles-PerformanceDesign/screenshot-Vehicle1D-performance-plot.png"
 width="500" alt="Longitudinal vehicle forces and constant power curves">

## Vehicle1D Performance Design App

Use the Vehicle1D Performance Design App to compute
the vehicle's longitudinal force and power curves.

<img src="screenshot-Vehicle1DPerformanceDesignApp.png"
 width="800" alt="Screenshot of the Vehicle1D performance design app">

## Harness model

Use the harness model for performing component-level tests.

- `HarnessModel_Reducer.mdl`

<img src="screenshot-HarnessModel_Vehicle1D.png"
 alt="Harness model for Vehicle1D component"
 width="800"/>

*Copyright 2022-2025 The MathWorks, Inc.*
