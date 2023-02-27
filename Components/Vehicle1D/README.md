# Vehicle1D component

This is a component to compute the longitudinal speed of a road vehicle.
The main block of this component is
[Longitudinal Vehicle block][url-veh] from Simscape Driveline
which is an abstract model parameterized with commonly available
vehicle specifications such as vehicle weight, tire rolling radius, etc.

[url-veh]:https://www.mathworks.com/help/physmod/sdl/ref/longitudinalvehicle.html

A vehicle is characterized by resisting force and power as shown below.
These properties are the key information to design
overall vehicle performance.

<img src="Utility/Images/Vehicle1D_refsub_Basic_ResistingForcePower.png"
 width="500" alt="Vehicle resisting force and power">

*Copyright 2022-2023 The MathWorks, Inc.*
