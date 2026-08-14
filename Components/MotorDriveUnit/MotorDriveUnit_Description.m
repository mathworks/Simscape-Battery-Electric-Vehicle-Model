%[text] %[text:anchor:T_1FFD3858] # Motor Drive Unit component
%[text] This is a model of motor drive unit (MDU), which is a system consisting of an electric motor and a controller. The MDU model abstracts the dynamic behavior of power conversion between electric and mechanical powers by considering electric power losses within the MDU. The model uses the following blocks. See the respective documentation for more individual details.
%[text] - [Motor & Drive block](https://www.mathworks.com/help/sdl/ref/motordrive.html) (Simscape Driveline)
%[text] - [Motor & Drive (System-Level) block](https://www.mathworks.com/help/sps/ref/motordrivesystemlevel.html) (Simscape Electrical) \
%[text:tableOfContents]{"heading":"In this page"}
%[text] %[text:anchor:H_9924] ## Abstract motor efficiency model
%[text] The core of the MDU component is the abstract motor efficiency model in the Motor & Drive blocks. The efficiency model estimates the electrical power losses within an MDU. For more details about the efficiency model, see the descriptions about [the abstract motor efficiency app](file:AbstractMotorEfficiencyApp_Description_bevutil1.html) in the Modeling Utility for Simscape.
%[text] %[text:anchor:H_7ce5] ## MDU blocks
%[text] The MDU component provides the following four models. These models are highly abstract and run fast.
%[text] - **Basic model** (`MotorDriveUnit_Basic_refsub`) is the simplest model with the fewest parameters among the four models. It uses [Motor & Drive block](https://www.mathworks.com/help/sdl/ref/motordrive.html) from Simscape Driveline. The block takes torque command and computes power conversion within an MDU using the **single efficiency measurement model** to compute torque-dependent copper-winding losses while ignoring speed-dependent iron (eddy current) losses and constant losses. This model is not configured to simulate temperature dynamics, but the block does support the simulation of temperature dynamics and it is available as **Basic thermal model** below. See the [description](file:AbstractMotorEfficiencyApp_Description_bevutil1.html) for more information about the motor efficiency.
%[text] - **Basic thermal model** (`MotorDriveUnit_BasicThermal_refsub`) uses [Motor & Drive block](https://www.mathworks.com/help/sdl/ref/motordrive.html), which is the same block as the above **Basic model** uses, but with thermal model enabled to simulate motor temperature dynamics.
%[text] - **System thermal model** (`MotorDriveUnit_SystemThermal_refsub`) uses [Motor & Drive (System-Level) block](https://www.mathworks.com/help/sps/ref/motordrivesystemlevel.html) from Simscape Electrical to compute power conversion within an MDU using the **single efficiency measurement model** to compute torque-dependent copper-winding losses, speed-dependent iron (eddy current) losses, and constant losses. See the [description](file:AbstractMotorEfficiencyApp_Description_bevutil1.html) for more information about the motor efficiency.
%[text] - **System with tabulated losses model** (`MotorDriveUnit_SystemTable_refsub`) uses [Motor & Drive (System-Level) block](https://www.mathworks.com/help/sps/ref/motordrivesystemlevel.html) from Simscape Electrical. It takes torque command and computes motor speed which is the same as the other models above, but for electrical power conversion losses, this model uses tabulated parameter data as a function of motor speed and torque $P\\left(\\tau\_{\\textrm{rot}} ,\\omega \\;\\right)${"editStyle":"visual"} instead of the single efficiency measurement model. Thermal model is disabled, but you can enable it if you have two data sets of efficiency or losses measured at two different temperatures. \
%[text] %[text:anchor:H_92e3] ## Simulation cases
%[text] To validate the MDU component, a harness model is used to run some simulation cases. Click the links below to see the simulation results.
%[text] %[text:anchor:H_446d] ### Basic model
%[text] - [Drive](matlab:bevutil1.ProjectUtil.openInProject('MotorDriveUnit_Basic_Drive')) ... MDU drives axle by consuming electric power.
%[text] - [Regenerative braking](matlab:bevutil1.ProjectUtil.openInProject('MotorDriveUnit_Basic_RegenBrake')) ... Axle drives motor, and MDU generates electric power.
%[text] - [Random](matlab:bevutil1.ProjectUtil.openInProject('MotorDriveUnit_Basic_Random')) .... Input signals for motor torque command and axle load torque are randomly generated.
%[text] - [Constant](matlab:bevutil1.ProjectUtil.openInProject('MotorDriveUnit_Basic_Constant')) ... All inputs are constant. This is used to check that the harness model runs. \
%[text] For other MDU models, see MotorDriveUnit \> Model-\* \> SimulationCases folders.
%[text] *Copyright 2020-2026 The Mathworks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
