# Introduction to the BEV project

The Battery Electric Vehicle (BEV) project contains the models of BEVs including
a BEV system model for simulating longitudinal dynamics and its components such as
a longitudinal vehicle, a reduction gear, a motor drive unit, and a high-voltage battery.
The models in this project are abstract, run fast, and are suitable for
the system level design of a BEV.

The main model is `BEV_system_model` in the `BEV` folder.

The parameters of the model are defined as variables in scripts and loaded in the base workspace,
and the blocks in the model use the base workspace variables.
To modify block parameters, edit variables in a script and run the script to
update the variables in the base workspace.

You can view the base workspace variables in the Workspace panel of the MATLAB Desktop window.
You can programmatically get and manipulate information about the base workspace variables
with commands such as [`matlab.lang.Workspace.baseworkspace`][baseworkspace],
[`variables`][variables], and [`evaluateAndCapture`][evaluateAndCapture].

[baseworkspace]: https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.baseworkspace.html
[variables]: https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.variables.html
[evaluateAndCapture]: https://www.mathworks.com/help/matlab/ref/matlab.lang.workspace.evaluateandcapture.html

_Copyright 2026 The MathWorks, Inc._
