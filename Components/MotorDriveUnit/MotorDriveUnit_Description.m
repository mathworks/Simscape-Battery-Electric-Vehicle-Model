%[text] %[text:anchor:T_1FFD3858] # Motor Drive Unit component
%[text] This is a model of motor drive unit (MDU), which is a system consisting of an electric motor and a controller. The MDU model abstracts the dynamic behavior of power conversion between electric and mechanical powers by considering electric power losses within the MDU. The model uses the following block. See the documentation for details.
%[text] - [Motor & Drive (System Level) block](https://www.mathworks.com/help/sps/ref/motordrivesystemlevel.html) (Simscape Electrical) \
%[text] %[text:anchor:H_9924] ## Abstract motor efficiency model
%[text] The core of the MDU component is the abstract motor efficiency model in the Motor & Drive block. The efficiency model estimates the electrical power losses within an MDU. For more details about the efficiency model, see the [description](file:AbstractMotorEfficiencyApp_Description_bevutil1.html) about [the abstract motor efficiency app](matlab:bevutil1.FileUtil.openApp("bevutil1_AbstractMotorEfficiencyApp")) in the Modeling Utility for Simscape.
%[text] %[text:anchor:H_7ce5] ## MDU blocks
%[text] The MDU component provides the following four models. These models are highly abstract and run fast.
%[text] - **Basic model** (`MotorDriveUnit_Basic_refsub`) is a model with high-level parameters without thermal model. It uses **Motor & Drive** block from Simscape Electrical. The block takes torque command and computes power conversion within an MDU using the **single efficiency measurement model** to compute torque-dependent copper-winding losses, speed-dependent iron (eddy current) losses, and constant losses. This model is not configured to simulate temperature dynamics, but the block does support the simulation of temperature dynamics and it is available as **Basic thermal model** below.
%[text] - **Basic thermal model** (`MotorDriveUnit_BasicThermal_refsub`) uses **Motor & Drive** block, which is the same block as the above **Basic model** uses, but with thermal model enabled to simulate motor temperature dynamics. \
%[text] %[text:anchor:H_92e3] ## Simulation cases
%[text] To validate the MDU component, a harness model is used to run some simulation cases. Click the links below to see the simulation results.
%[text] %[text:anchor:H_446d] ### Basic model
%[text] - [Drive](matlab:bevutil1.FileUtil.openScriptInEditor("MotorDriveUnit_Basic_Drive")) ... MDU drives axle by consuming electric power.
%[text] - [Regenerative braking](matlab:bevutil1.FileUtil.openScriptInEditor("MotorDriveUnit_Basic_RegenBrake")) ... Axle drives motor, and MDU generates electric power.
%[text] - [Random](matlab:bevutil1.FileUtil.openScriptInEditor("MotorDriveUnit_Basic_Random")) .... Input signals for motor torque command and axle load torque are randomly generated.
%[text] - [Constant](matlab:bevutil1.FileUtil.openScriptInEditor("MotorDriveUnit_Basic_Constant")) ... All inputs are constant. This is used to check that the harness model runs. \
%[text] For other MDU models, see `MotorDriveUnit` \> `Model-*` \> `SimulationCases` folders.
%[text] *Copyright 2020-2026 The Mathworks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
