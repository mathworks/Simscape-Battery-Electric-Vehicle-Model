
<a id="T_0F8BC05C"></a>

# <span style="color:rgb(213,80,0)">Battery Electric Vehicle (BEV) System Level Model</span>
<!-- Begin Toc -->

## Table of Contents
&emsp;[Introduction](#H_A0C28D4F)
 
&emsp;[Run Simulation](#H_EC484CEF)
 
&emsp;[Save Result](#H_EF7BCF44)
 
&emsp;[Analyse Result](#H_81E3C32A)
 
<!-- End Toc -->
<a id="H_A0C28D4F"></a>

# Introduction

This is a simple, fast running BEV model which can estimate the electrical efficiency of the vehicle. It is also suitable for further customizations for more focused analysis of individual components at vehicle system level.


To open the model, navigate Toolstrip > Project Shortcut tab, and click the "**BEV model**" button.


This script shows an example workflow to programmatically open model, run simulation, collect simulation data, visualize result, save data to text\-format file, read saved data file, and analyze. Feel free to modify this script (probably saving as another file first) and experiment to get new results.


You can find more scripts demonstrating other simulation cases in the BEV > Model\-\* > SimulationCases folders.

<a id="H_EC484CEF"></a>

# Run Simulation

This section sets up the model and runs simulation. To run this script at once, navigate Toolstrip > Live Editor tab, and click the Run button. You can also run this section only by clicking the Run Section button.

```matlab
model_name = "BEV_system_model";

% Load the model.
load_system(model_name)

% Setup the vehicle component models and load the parameters.
BEV_setup_Basic
```

```matlabTextOutput
Use Basic models for all components.
Loading in base workspace: Vehicle1D_Basic_params
Loading in base workspace: BatteryHV_Basic_params
Loading in base workspace: MotorDriveUnit_Basic_params
Loading in base workspace: Reducer_Basic_params
Loading in base workspace: BEVController_Basic_params
```

```matlab

% Use the Simulation Input to adjust the simulation settings.
% https://www.mathworks.com/help/simulink/slref/simulink.simulationinput.html
sim_in = Simulink.SimulationInput(model_name);

% Select the vehicle speed reference, i.e., drive pattern/cycle.
sim_in = setBlockParameter(sim_in, ...
  model_name + "/Controller and Environment/Vehicle speed reference", ...
  ReferencedSubsystem = "VehSpdRef_Simple_refsub");

% Specify the stop time of simulation corresponding to the drive pattern.
sim_in = setModelParameter(sim_in, StopTime = "100");
```

If you want to change some parameter values or simulation settings, do it here:

```matlab
% Your code goes here.
```

Run simulation, collect logged data, and visualize the result.

```matlab
% The applyToModel function updates the model file using the Simulation Input object.
% It is safe to skip calling the function in this script, but in that case,
% the changes made in the Simulation Input object are applied only to the model in the memory.
% For mroe information abuout applyToModel, see the documentation.
% https://www.mathworks.com/help/simulink/slref/simulink.simulationinput.applytomodel.html
applyToModel(sim_in)

sim_out = sim(sim_in);

% Extract logged signals at once with extractTimetable.
sim_data = extractTimetable(sim_out.logsout);

fig = BEV_plotResults(TimedData = sim_data, PlotTemperature = false);

% Save the plot to a PNG file.
imgFilename = "BEV_SimulationResultPlot.png";
exportgraphics(fig, fullfile(currentProject().RootFolder, "BEV", "simulation-results", imgFilename))
```

<center><img src="media/BEV_main_script_media/figure_0.png" width="702" alt="figure_0.png"></center>

<a id="H_EF7BCF44"></a>

# Save Result

Save logged signals to a CSV file for later analysis. CSV text format is used rather than binary format for saving the data. Text format works better when the data size is small and the file is version\-managed with a source control tool such as git.

```matlab
% Adjust the time format in the timetable object so as not to lose the subsecond information.
sim_data.Time.Format = "hh:mm:ss.SSSS";

% Signal names to save in file.
% These must be specified in the model as signal logging names.
% For example, in the BEV system model, see the Measurement subsystem.
data_columns = [ ...
  "HV Battery SOC", "HV Battery Power", "HV Battery Current", ...
  "G-Force", "Vehicle Speed kph" ];

% Select the logged signals to save.
sim_data = sim_data(:, data_columns);

% Add unit information to the signal names.
var_names = string(sim_data.Properties.VariableNames');
var_units = string(sim_data.Properties.VariableUnits');
var_names2 = var_names + " (" + var_units + ")";
disp(var_names2)
```

```matlabTextOutput
    "HV Battery SOC (%)"
    "HV Battery Power (kW)"
    "HV Battery Current (A)"
    "G-Force (1)"
    "Vehicle Speed kph (km/hr)"
```

```matlab
sim_data.Properties.VariableNames = var_names2;

% Save the data to a CSV file.
sim_result_filename  = "BEV_SimulationResult_1.csv";
sim_result_filefullpath = fullfile(currentProject().RootFolder, "BEV", "simulation-results", sim_result_filename);
writetimetable(sim_data, sim_result_filefullpath)
```

Open the saved CSV file in text editor and check that the variable names are saved at the first line as expected.

<a id="H_81E3C32A"></a>

# Analyse Result

This section reads a simulation result CSV file which was saved in the previous section, and do some analysis on the data. This section should work independently without running the previous section as long as the result file exists. At the end of this section, you get the electric efficiency of the vehicle according to the drive cycle for which the data was collected.

```matlab
sim_result_filename  = "BEV_SimulationResult_1.csv";
sim_result_filefullpath = fullfile(currentProject().RootFolder, "BEV", "simulation-results", sim_result_filename);

% Read a CSV file containing simulation result and store it to a timetable.
data = readtimetable(sim_result_filefullpath, VariableNamingRule="preserve");

% Adjust time format.
data.Time.Format = "s";

% Separate variable names and unit strings.
var_names_with_unit = string(data.Properties.VariableNames');
var_names = extractBefore(var_names_with_unit, " (");
disp(var_names)
```

```matlabTextOutput
    "HV Battery SOC"
    "HV Battery Power"
    "HV Battery Current"
    "G-Force"
    "Vehicle Speed kph"
```

```matlab
var_units = extractBetween(var_names_with_unit, "(", ")");
disp(var_units)
```

```matlabTextOutput
    "%"
    "kW"
    "A"
    "1"
    "km/hr"
```

```matlab
data.Properties.VariableNames = var_names;
data.Properties.VariableUnits = var_units;
```

Time

```matlab
t = simscape.Value( seconds(data.Time), 's' );
dt = diff(t);
```

Travelled Distance

```matlab
data_VehSpd = data.("Vehicle Speed kph");
unit_str = var_units(var_names == "Vehicle Speed kph");
vehicle_speed = simscape.Value(data_VehSpd, unit_str);
average_speed = sum(vehicle_speed)/numel(vehicle_speed);
disp("Average speed: " + value(average_speed) + " " + string(unit(average_speed)))
```

```matlabTextOutput
Average speed: 31.914 km/hr
```

```matlab
max_speed = max(vehicle_speed);
disp("Maximum speed: " + value(max_speed) + " " + string(unit(max_speed)))
```

```matlabTextOutput
Maximum speed: 70.0069 km/hr
```

```matlab
travelled_distance = sum(vehicle_speed(2:end).*dt);
travelled_distance = convert( travelled_distance, "km" );
disp("Travelled distance: " + value(travelled_distance) + " " + string(unit(travelled_distance)))
```

```matlabTextOutput
Travelled distance: 0.96264 km
```


G Force

```matlab
G = data.("G-Force");
disp("Minimun G: " + min(G))
```

```matlabTextOutput
Minimun G: -0.077077
```

```matlab
disp("Maximum G: " + max(G))
```

```matlabTextOutput
Maximum G: 0.19673
```


Battery Power

```matlab
data_BattPwr = data.("HV Battery Power");
unit_str = var_units(var_names == "HV Battery Power");
battery_power = simscape.Value(data_BattPwr, unit_str);
battery_energy_used = sum(battery_power(2:end).*dt);
battery_energy_used = convert(battery_energy_used, "kWh");
disp("Battery energy used: " + value(battery_energy_used) + " " + string(unit(battery_energy_used)))
```

```matlabTextOutput
Battery energy used: 0.14366 kWh
```

```matlab
energy_efficiency_kWh_per_100km = 100 * value(battery_energy_used / travelled_distance, "kWh/km");
disp("Energy efficiency: " + energy_efficiency_kWh_per_100km + " kWh per 100 km")
```

```matlabTextOutput
Energy efficiency: 14.9234 kWh per 100 km
```

```matlab
energy_efficiency_km_per_kWh = convert(travelled_distance / battery_energy_used, "km/kWh");
disp("Energy efficiency: " + value(energy_efficiency_km_per_kWh) + " " + string(unit(energy_efficiency_km_per_kWh)))
```

```matlabTextOutput
Energy efficiency: 6.7009 km/kWh
```

```matlab
energy_efficiency_mi_per_kWh = convert(travelled_distance / battery_energy_used, "mi/kWh");
disp("Energy efficiency: " + value(energy_efficiency_mi_per_kWh) + " " + string(unit(energy_efficiency_mi_per_kWh)))
```

```matlabTextOutput
Energy efficiency: 4.1637 mi/kWh
```


*Copyright 2022\-2025 The MathWorks, Inc.*

