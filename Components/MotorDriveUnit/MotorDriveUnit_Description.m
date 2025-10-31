%[text] %[text:anchor:T_1FFD3858] # Motor Drive Unit
%[text] This is a model of motor drive unit (MDU), which is a system consisting of an electric motor and a controller. This MDU model is abstract and simulates the high-level behavior of power conversion between electric and mechanical powers by considering power conversion efficiency or losses. This model uses the following blocks. See the respective documentation for more details.
%[text] - [Motor & Drive block](https://www.mathworks.com/help/sdl/ref/motordrive.html) (Simscape Driveline)
%[text] - [Motor & Drive (System-Level) block](https://www.mathworks.com/help/sps/ref/motordrivesystemlevel.html) (Simscape Electrical) \
%[text:tableOfContents]{"heading":"In this page"}
%[text] %[text:anchor:H_9924] ## MDU model
%[text] The core system equations of the MDU model are generally as follows.
%[text]{"align":"center"} $J\\;\\frac{d\\omega \\;}{\\textrm{dt}}=\\tau {\\;}\_{\\textrm{rot}} +\\tau\_{\\textrm{cmd}} -k\_f \\;\\omega \\;${"editStyle":"visual"}
%[text]{"align":"center"} $P\_{\\textrm{mech}} =\\tau {\\;}\_{\\textrm{cmd}} \\cdot \\omega \\;${"editStyle":"visual"}
%[text]{"align":"center"} $P\_{\\textrm{elec}} =i\\cdot V${"editStyle":"visual"}
%[text]{"align":"center"} $P\_{\\textrm{elec}} =P\_{\\textrm{mech}} +P\_{\\textrm{elecloss}}${"editStyle":"visual"}
%[text]{"align":"center"} $P\_{\\textrm{elecloss}} =P\_{\\textrm{copper}} +P\_{\\textrm{iron}} +P\_{\\textrm{fixed}}${"editStyle":"visual"}
%[text]{"align":"center"} $P\_{\\textrm{copper}} =k\_{\\textrm{copper}} \\cdot {\\left(\\tau {\\;}\_{\\textrm{rot}} \\right)}^2${"editStyle":"visual"}
%[text]{"align":"center"} $P\_{\\textrm{iron}} =k\_{\\textrm{iron}} \\cdot \\omega {\\;}^2${"editStyle":"visual"}
%[text]{"align":"center"} $M\_{\\textrm{therm}} \\;\\frac{d\\;T\_m }{\\textrm{dt}}=P\_{\\textrm{elecloss}} +Q${"editStyle":"visual"}
%[text]{"align":"center"} $\\eta\_{\\textrm{nom}} =\\left(\\frac{1}{\\eta\_{\\textrm{meas}} }-1\\right)P\_{\\textrm{mech}}${"editStyle":"visual"}
%[text] where $J${"editStyle":"visual"}is motor inertia. $t${"editStyle":"visual"} time. $\\omega \\;${"editStyle":"visual"}rotor angular speed. $\\tau\_{\\textrm{rot}}${"editStyle":"visual"} torque at motor rotor. $\\tau\_{\\textrm{cmd}}${"editStyle":"visual"} torque command input to MDU. $k\_f${"editStyle":"visual"} rotor frictional damping coefficient. $P\_{\\textrm{mech}}${"editStyle":"visual"} mechanical power. $P\_{\\textrm{elec}}${"editStyle":"visual"} electrical power whose sign indicates if the system is generating or consuming electric power. $P\_{\\textrm{elecloss}}${"editStyle":"visual"} electrical losses which can be modelled as a scalar constant, a formula as a function of motor speed etc., or a tabulated map. $i${"editStyle":"visual"} and $V${"editStyle":"visual"} electric current and voltage drop, respectively, connected to DC power supply. $P\_{\\textrm{copper}}${"editStyle":"visual"} copper loss. $P\_{\\textrm{iron}}${"editStyle":"visual"} iron loss. $P\_{\\textrm{fixed}}${"editStyle":"visual"} fixed loss which is constant across the whole operating region. $\\eta\_{\\textrm{nom}}${"editStyle":"visual"} nominal loss (total loss). Front factors $k\_{\\textrm{copper}}${"editStyle":"visual"} and $k\_{\\textrm{iron}}${"editStyle":"visual"} are explained for each model below. $M\_{\\textrm{therm}}${"editStyle":"visual"} thermall mass of MDU. $T\_m${"editStyle":"visual"} MDU temperature. $Q${"editStyle":"visual"} heat flow rate input to MDU.
%[text] In the models below (except for System-level model with tabulated losses), copper loss coefficient $k\_{\\textrm{copper}}${"editStyle":"visual"} is deteremined using the **single efficiency measurement model**
%[text]{"align":"center"} $k\_{\\textrm{copper}} =\\frac{\\omega {\\;}\_{\\textrm{meas}} \\;\\left(1-\\eta {\\;}\_{\\textrm{meas}} \\right)}{\\tau\_{\\textrm{meas}} \\;\\eta {\\;}\_{\\textrm{meas}} }${"editStyle":"visual"}
%[text] where
%[text] - ${\\eta \\;}\_{\\textrm{meas}}${"editStyle":"visual"} ... measured efficiency (normalized between 0 and 1, or in percent which needs to be normalized before used in the formula)
%[text] - $\\omega {\\;}\_{\\textrm{meas}}${"editStyle":"visual"} ... motor speed at which efficiency is measured
%[text] - $\\tau\_{\\textrm{meas}}${"editStyle":"visual"} ... torque at which efficiecy is measured \
%[text] Iron loss coefficient $k\_{\\textrm{iron}}${"editStyle":"visual"} depends on the characteristics of motor drive unit, but it could be typically about 10% of $k\_{\\textrm{copper}}${"editStyle":"visual"}.
%[text] %[text:anchor:H_7ce5] ## MDU blocks
%[text] This component provides the following four models based on the above formulation. These models are highly abstract and run fast.
%[text] - **Basic model** (`MotorDriveUnit_Basic_refsub`) is the simplest model with the fewest parameters among the four models. It uses [Motor & Drive block](https://www.mathworks.com/help/sdl/ref/motordrive.html) from Simscape Driveline. This model takes torque command and computes power conversion between electrical and mechanical powers using the **single efficiency measurement model** to compute copper loss coefficient $k\_c${"editStyle":"visual"}. Irons loss $P\_{\\textrm{iron}}${"editStyle":"visual"} and fixed loss $P\_{\\textrm{fixed}}${"editStyle":"visual"} are not modeled. This model does not simulate temperature dynamics. See a [note](matlab:openInProject('MotorDriveUnit_BasicModelEfficiencyDoc')) for more information about efficiency.
%[text] - **Basic thermal model** (`MotorDriveUnit_BasicThermal_refsub`) uses [Motor & Drive block](https://www.mathworks.com/help/sdl/ref/motordrive.html), which is the same block as the above Basic model uses, but with thermal model enabled to simulate motor temperature dynamics.
%[text] - **System thermal model** (`MotorDriveUnit_refsub_System`) uses [Motor & Drive (System-Level) block](https://www.mathworks.com/help/sps/ref/motordrivesystemlevel.html) from Simscape Electrical to compute power conversion between electrical and mechanical powers. Thermal model is enabled too. Power conversion model is the same as the one in Basic and Basic thermal models above, i.e., the **single efficiency measurement model**, but irons loss $P\_{\\textrm{iron}}${"editStyle":"visual"} and fixed loss $P\_{\\textrm{fixed}}${"editStyle":"visual"} are also considered in this model. See a [note](matlab:openInProject('MotorDriveUnit_SystemThermalModelEfficiencyDoc')) for more information about efficiency.
%[text] - **System with tabulated losses model** (`MotorDriveUnit_refsub_SystemTable`) uses [Motor & Drive (System-Level) block](https://www.mathworks.com/help/sps/ref/motordrivesystemlevel.html) from Simscape Electrical. It takes torque command and computes motor speed which is the same as the other models above, but for power conversion efficiency or losses, this model uses tabulated parameter data as a function of motor speed and torque $P\\left(\\tau\_{\\textrm{rot}} ,\\omega \\;\\right)${"editStyle":"visual"} instead of the single efficiency measurement model. Thermal model is disabled, but you can enable it if you have two data sets of efficiency or losses measured at two different temperatures. \
%[text] %[text:anchor:H_4e26] ### Motor Efficiency Apps
%[text] Use the following apps to see the motor efficiency map and how the parameters affect it. The link below works to open the app if you are viewing this document in MATLAB Web Browser or editing in MATLAB Editor.
%[text] - [MotorDriveUnit\_BasicModelEfficiencyApp](matlab:MotorDriveUnit_BasicModelEfficiencyApp)
%[text] - [MotorDriveUnit\_SystemThermalModelEfficiencyApp](matlab:MotorDriveUnit_SystemThermalModelEfficiencyApp) \
%[text] %[text:anchor:H_92e3] ## Simulation cases
%[text] To validate the MDU component, a harness model is used to run some simulation cases. Click the links below to see the simulation results. You can also use [Motor Drive Unit Simulation App](matlab:MotorDriveUnitSimulationApp) to select a model and run a simulation case.
%[text] %[text:anchor:H_446d] ### Basic model
%[text] - [Drive](matlab:openInProject('MotorDriveUnit_Basic_Drive')) ... MDU drives axle by consuming electric power.
%[text] - [Regenerative braking](matlab:openInProject('MotorDriveUnit_Basic_RegenBrake')) ... Axle drives motor, and MDU generates electric power.
%[text] - [Random](matlab:openInProject('MotorDriveUnit_Basic_Random')) .... Input signals for motor torque command and axle load torque are randomly generated.
%[text] - [Constant](matlab:openInProject('MotorDriveUnit_Basic_Constant')) ... All inputs are constant. This is used to check that the harness model runs. \
%[text] For other MDU models, see MotorDriveUnit \> Model-\* \> SimulationCases folders.
%[text] *Copyright 2020-2025 The Mathworks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
