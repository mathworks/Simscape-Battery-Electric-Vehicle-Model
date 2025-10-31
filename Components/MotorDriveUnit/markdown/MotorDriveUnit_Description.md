
<a id="T_1FFD3858"></a>

# <span style="color:rgb(213,80,0)">Motor Drive Unit</span>

This is a model of motor drive unit (MDU), which is a system consisting of an electric motor and a controller. This MDU model is abstract and simulates the high\-level behavior of power conversion between electric and mechanical powers by considering power conversion efficiency or losses. This model uses the following blocks. See the respective documentation for more details.

-  [Motor & Drive block](https://www.mathworks.com/help/sdl/ref/motordrive.html) (Simscape Driveline) 
-  [Motor & Drive (System\-Level) block](https://www.mathworks.com/help/sps/ref/motordrivesystemlevel.html) (Simscape Electrical) 
<!-- Begin Toc -->

## In this page
&emsp;[MDU model](#H_9924)
 
&emsp;[MDU blocks](#H_7ce5)
 
&emsp;&emsp;[Motor Efficiency Apps](#H_4e26)
 
&emsp;[Simulation cases](#H_92e3)
 
&emsp;&emsp;[Basic model](#H_446d)
 
<!-- End Toc -->
<a id="H_9924"></a>

# MDU model

The core system equations of the MDU model are generally as follows.

 $$ J\;\frac{d\omega \;}{\textrm{dt}}=\tau {\;}_{\textrm{rot}} +\tau_{\textrm{cmd}} -k_f \;\omega \; $$ 

 $$ P_{\textrm{mech}} =\tau {\;}_{\textrm{cmd}} \cdot \omega \; $$ 

 $$ P_{\textrm{elec}} =i\cdot V $$ 

 $$ P_{\textrm{elec}} =P_{\textrm{mech}} +P_{\textrm{elecloss}} $$ 

 $$ P_{\textrm{elecloss}} =P_{\textrm{copper}} +P_{\textrm{iron}} +P_{\textrm{fixed}} $$ 

 $$ P_{\textrm{copper}} =k_{\textrm{copper}} \cdot {\left(\tau {\;}_{\textrm{rot}} \right)}^2 $$ 

 $$ P_{\textrm{iron}} =k_{\textrm{iron}} \cdot \omega {\;}^2 $$ 

 $$ M_{\textrm{therm}} \;\frac{d\;T_m }{\textrm{dt}}=P_{\textrm{elecloss}} +Q $$ 

 $$ \eta_{\textrm{nom}} =\left(\frac{1}{\eta_{\textrm{meas}} }-1\right)P_{\textrm{mech}} $$ 

where $J$ is motor inertia. $t$ time. $\omega \;$ rotor angular speed. $\tau_{\textrm{rot}}$ torque at motor rotor. $\tau_{\textrm{cmd}}$ torque command input to MDU. $k_f$ rotor frictional damping coefficient. $P_{\textrm{mech}}$ mechanical power. $P_{\textrm{elec}}$ electrical power whose sign indicates if the system is generating or consuming electric power. $P_{\textrm{elecloss}}$ electrical losses which can be modelled as a scalar constant, a formula as a function of motor speed etc., or a tabulated map. $i$ and $V$ electric current and voltage drop, respectively, connected to DC power supply. $P_{\textrm{copper}}$ copper loss. $P_{\textrm{iron}}$ iron loss. $P_{\textrm{fixed}}$ fixed loss which is constant across the whole operating region. $\eta_{\textrm{nom}}$ nominal loss (total loss). Front factors $k_{\textrm{copper}}$ and $k_{\textrm{iron}}$ are explained for each model below. $M_{\textrm{therm}}$ thermall mass of MDU. $T_m$ MDU temperature. $Q$ heat flow rate input to MDU.


In the models below (except for System\-level model with tabulated losses), copper loss coefficient $k_{\textrm{copper}}$ is deteremined using the **single efficiency measurement model**

 $$ k_{\textrm{copper}} =\frac{\omega {\;}_{\textrm{meas}} \;\left(1-\eta {\;}_{\textrm{meas}} \right)}{\tau_{\textrm{meas}} \;\eta {\;}_{\textrm{meas}} } $$ 

where

-  ${\eta \;}_{\textrm{meas}}$ ... measured efficiency (normalized between 0 and 1, or in percent which needs to be normalized before used in the formula) 
-  $\omega {\;}_{\textrm{meas}}$ ... motor speed at which efficiency is measured 
-  $\tau_{\textrm{meas}}$ ... torque at which efficiecy is measured 

Iron loss coefficient $k_{\textrm{iron}}$ depends on the characteristics of motor drive unit, but it could be typically about 10% of $k_{\textrm{copper}}$.

<a id="H_7ce5"></a>

# MDU blocks

This component provides the following four models based on the above formulation. These models are highly abstract and run fast.

-  **Basic model** (`MotorDriveUnit_Basic_refsub`) is the simplest model with the fewest parameters among the four models. It uses [Motor & Drive block](https://www.mathworks.com/help/sdl/ref/motordrive.html) from Simscape Driveline. This model takes torque command and computes power conversion between electrical and mechanical powers using the **single efficiency measurement model** to compute copper loss coefficient $k_c$. Irons loss $P_{\textrm{iron}}$ and fixed loss $P_{\textrm{fixed}}$ are not modeled. This model does not simulate temperature dynamics. See a [note](matlab:openInProject('MotorDriveUnit_BasicModelEfficiencyDoc')) for more information about efficiency. 
-  **Basic thermal model** (`MotorDriveUnit_BasicThermal_refsub`) uses [Motor & Drive block](https://www.mathworks.com/help/sdl/ref/motordrive.html), which is the same block as the above Basic model uses, but with thermal model enabled to simulate motor temperature dynamics. 
-  **System thermal model** (`MotorDriveUnit_refsub_System`) uses [Motor & Drive (System\-Level) block](https://www.mathworks.com/help/sps/ref/motordrivesystemlevel.html) from Simscape Electrical to compute power conversion between electrical and mechanical powers. Thermal model is enabled too. Power conversion model is the same as the one in Basic and Basic thermal models above, i.e., the **single efficiency measurement model**, but irons loss $P_{\textrm{iron}}$ and fixed loss $P_{\textrm{fixed}}$ are also considered in this model. See a [note](matlab:openInProject('MotorDriveUnit_SystemThermalModelEfficiencyDoc')) for more information about efficiency. 
-  **System with tabulated losses model** (`MotorDriveUnit_refsub_SystemTable`) uses [Motor & Drive (System\-Level) block](https://www.mathworks.com/help/sps/ref/motordrivesystemlevel.html) from Simscape Electrical. It takes torque command and computes motor speed which is the same as the other models above, but for power conversion efficiency or losses, this model uses tabulated parameter data as a function of motor speed and torque $P\left(\tau_{\textrm{rot}} ,\omega \;\right)$ instead of the single efficiency measurement model. Thermal model is disabled, but you can enable it if you have two data sets of efficiency or losses measured at two different temperatures. 
<a id="H_4e26"></a>

## Motor Efficiency Apps

Use the following apps to see the motor efficiency map and how the parameters affect it. The link below works to open the app if you are viewing this document in MATLAB Web Browser or editing in MATLAB Editor.

-  [MotorDriveUnit\_BasicModelEfficiencyApp](matlab:MotorDriveUnit_BasicModelEfficiencyApp) 
-  [MotorDriveUnit\_SystemThermalModelEfficiencyApp](matlab:MotorDriveUnit_SystemThermalModelEfficiencyApp) 
<a id="H_92e3"></a>

# Simulation cases

To validate the MDU component, a harness model is used to run some simulation cases. Click the links below to see the simulation results. You can also use [Motor Drive Unit Simulation App](matlab:MotorDriveUnitSimulationApp) to select a model and run a simulation case.

<a id="H_446d"></a>

## Basic model
-  [Drive](matlab:openInProject('MotorDriveUnit_Basic_Drive')) ... MDU drives axle by consuming electric power. 
-  [Regenerative braking](matlab:openInProject('MotorDriveUnit_Basic_RegenBrake')) ... Axle drives motor, and MDU generates electric power. 
-  [Random](matlab:openInProject('MotorDriveUnit_Basic_Random')) .... Input signals for motor torque command and axle load torque are randomly generated. 
-  [Constant](matlab:openInProject('MotorDriveUnit_Basic_Constant')) ... All inputs are constant. This is used to check that the harness model runs. 

For other MDU models, see MotorDriveUnit > Model\-\* > SimulationCases folders.


*Copyright 2020\-2025 The Mathworks, Inc.*

