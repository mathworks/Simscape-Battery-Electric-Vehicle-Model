
<a id="T_1FFD3858"></a>

# <span style="color:rgb(213,80,0)">High Voltage Battery \- Main Script</span>

This is a component to simulate the abstract dynamics of a high voltage battery pack.

# Models

This component provides four models of a high voltage battery:

-  **Primitive** model ... is the simplest model and computes the voltage and current of the battery with no temperature dependence. 
-  **Basic** model ... is built with [Battery (System\-Level) block](https://www.mathworks.com/help/sdl/ref/batterysystemlevel.html) from Simscape Driveline. This model has a simple equation\-based terminal voltage model computed from the state of charge (SOC). This model also computes the battery temperature. 
-  **BasicThermal** model ... same as the Basic model except that battery temperature is computed. 
-  **SystemThermal** model ... is built with [Battery block](https://www.mathworks.com/help/sps/ref/battery.html) from Simscape Battery and Simscape Electrical. This model can simulate the terminal voltage more accurately than the Basic model but requires more parameters. Optionally, this model can also simulate charging dynamics, fade, and aging. 
-  **SystemTable** model ... is built with [Battery (Table\-Based) block](https://www.mathworks.com/help/sps/ref/batterytablebased.html) from Simscape Battery and Simscape Electrical. This model takes tabulated data for open\-circuit voltage and terminal resistance as a function of temperature and SOC. Battery temperature is computed. This model also needs the number of cells and their series\-parallel circuit configuration information. Similar to the SystemThermal model, this model can optionally simulate charging dynamics, fade, and aging. 
# Simulation cases

To validate the component, a test model is used to run some simulation cases for each model. See scripts in **SimulationCases** folder in each model.


*Copyright 2020\-2025 The Mathworks, Inc.*

