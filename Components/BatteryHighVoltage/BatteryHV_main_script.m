%[text] %[text:anchor:T_1FFD3858] # High Voltage Battery - Main Script
%[text] This is a component to simulate the abstract dynamics of a high voltage battery pack.
%[text] ## Models
%[text] This component provides four models of a high voltage battery:
%[text] - **Basic** model ... is the simplest model and computes the voltage and current of the battery with no temperature dependence.
%[text] - **Simple system** model ... is the second simplest model, built with [Battery (System-Level) block](https://www.mathworks.com/help/sdl/ref/batterysystemlevel.html) from Simscape Driveline. This model has a simple equation-based terminal voltage model computed from the state of charge (SOC). This model also computes the battery temperature from dissipated energy.
%[text] - **System** model ... is a model built with [Battery block](https://www.mathworks.com/help/sps/ref/battery.html) from Simscape Battery and Simscape Electrical. This model can simulate the terminal voltage more accurately than the simple system model above, but it requires more parameters. Optionally, this model can also simulate charging dynamics, fade, and aging.
%[text] - **Table-based system** model ... is a model built with [Battery (Table-Based) block](https://www.mathworks.com/help/sps/ref/batterytablebased.html) from Simscape Battery and Simscape Electrical. This model takes tabulated data for open-circuit voltage and terminal resistance as a function of temperature and SOC. This model also needs the number of cells and their series-parallel circuit configuration information. Similar to the system model above, this model can optionally simulate charging dynamics, fade, and aging. \
%[text] ## Simulation cases
%[text] To validate the component, a harness model is used to run some simulation cases. Click the links below to see the simulation results.
%[text] - [Charging](matlab:openFile('BatteryHV_simulationCase_Charge'))
%[text] - [Discharging](matlab:openFile('BatteryHV_simulationCase_Discharge'))
%[text] - [Random load current](matlab:openFile('BatteryHV_simulationCase_Random'))
%[text] - [Constant load current](matlab:openFile('BatteryHV_simulationCase_Constant')) \
%[text] *Copyright 2020-2025 The Mathworks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
