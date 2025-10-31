%[text] %[text:anchor:T_0F8BC05C] # Battery Electric Vehicle (BEV) System Level Model
%[text:tableOfContents]{"heading":"Table of Contents"}
%[text] %[text:anchor:H_A0C28D4F] ## Introduction
%[text] This is a simple, fast running BEV model which can estimate the electrical efficiency of the vehicle. It is also suitable for further customizations for more focused analysis of individual components at vehicle system level.
%[text] To open the model, navigate Toolstrip \> Project Shortcut tab, and click the "**BEV model**" button.
%[text] This script shows an example workflow to programmatically open model, run simulation, collect simulation data, visualize result, save data to text-format file, read saved data file, and analyze. Feel free to modify this script (probably saving as another file first) and experiment to get new results.
%[text] You can find more scripts demonstrating other simulation cases in the BEV \> Model-\* \> SimulationCases folders.
%%
%[text] %[text:anchor:H_EC484CEF] ## Run Simulation
%[text] This section sets up the model and runs simulation. To run this script at once, navigate Toolstrip \> Live Editor tab, and click the Run button. You can also run this section only by clicking the Run Section button.
model_name = "BEV_system_model";

% Load the model.
load_system(model_name)

% Setup the vehicle component models and load the parameters.
BEV_setup_Basic %[output:8090040d]

% Use the Simulation Input to adjust the simulation settings.
% https://www.mathworks.com/help/simulink/slref/simulink.simulationinput.html
sim_in = Simulink.SimulationInput(model_name);

% Select the vehicle speed reference, i.e., drive pattern/cycle.
sim_in = setBlockParameter(sim_in, ...
  model_name + "/Controller and Environment/Vehicle speed reference", ...
  ReferencedSubsystem = "VehSpdRef_Simple_refsub");

% Specify the stop time of simulation corresponding to the drive pattern.
sim_in = setModelParameter(sim_in, StopTime = "100");
%[text] If you want to change some parameter values or simulation settings, do it here:
% Your code goes here.
%[text] Run simulation, collect logged data, and visualize the result.
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
%[text] %[text:anchor:H_EF7BCF44] ## Save Result
%[text] Save logged signals to a CSV file for later analysis. CSV text format is used rather than binary format for saving the data. Text format works better when the data size is small and the file is version-managed with a source control tool such as git.
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
sim_data.Properties.VariableNames = var_names2;

% Save the data to a CSV file.
sim_result_filename  = "BEV_SimulationResult_1.csv";
sim_result_filefullpath = fullfile(currentProject().RootFolder, "BEV", "simulation-results", sim_result_filename);
writetimetable(sim_data, sim_result_filefullpath)
%[text] Open the saved CSV file in text editor and check that the variable names are saved at the first line as expected.
%%
%[text] %[text:anchor:H_81E3C32A] ## Analyse Result
%[text] This section reads a simulation result CSV file which was saved in the previous section, and do some analysis on the data. This section should work independently without running the previous section as long as the result file exists. At the end of this section, you get the electric efficiency of the vehicle according to the drive cycle for which the data was collected.
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
var_units = extractBetween(var_names_with_unit, "(", ")");
disp(var_units)
data.Properties.VariableNames = var_names;
data.Properties.VariableUnits = var_units;
%[text] Time
t = simscape.Value( seconds(data.Time), 's' );
dt = diff(t);
%[text] Travelled Distance
data_VehSpd = data.("Vehicle Speed kph");
unit_str = var_units(var_names == "Vehicle Speed kph");
vehicle_speed = simscape.Value(data_VehSpd, unit_str);
average_speed = sum(vehicle_speed)/numel(vehicle_speed);
disp("Average speed: " + value(average_speed) + " " + string(unit(average_speed)))
max_speed = max(vehicle_speed);
disp("Maximum speed: " + value(max_speed) + " " + string(unit(max_speed)))
travelled_distance = sum(vehicle_speed(2:end).*dt);
travelled_distance = convert( travelled_distance, "km" );
disp("Travelled distance: " + value(travelled_distance) + " " + string(unit(travelled_distance)))
%[text] G Force
G = data.("G-Force");
disp("Minimun G: " + min(G))
disp("Maximum G: " + max(G))
%[text] Battery Power
data_BattPwr = data.("HV Battery Power");
unit_str = var_units(var_names == "HV Battery Power");
battery_power = simscape.Value(data_BattPwr, unit_str);
battery_energy_used = sum(battery_power(2:end).*dt);
battery_energy_used = convert(battery_energy_used, "kWh");
disp("Battery energy used: " + value(battery_energy_used) + " " + string(unit(battery_energy_used)))
energy_efficiency_kWh_per_100km = 100 * value(battery_energy_used / travelled_distance, "kWh/km");
disp("Energy efficiency: " + energy_efficiency_kWh_per_100km + " kWh per 100 km")
energy_efficiency_km_per_kWh = convert(travelled_distance / battery_energy_used, "km/kWh");
disp("Energy efficiency: " + value(energy_efficiency_km_per_kWh) + " " + string(unit(energy_efficiency_km_per_kWh)))
energy_efficiency_mi_per_kWh = convert(travelled_distance / battery_energy_used, "mi/kWh");
disp("Energy efficiency: " + value(energy_efficiency_mi_per_kWh) + " " + string(unit(energy_efficiency_mi_per_kWh)))
%[text] *Copyright 2022-2025 The MathWorks, Inc.*

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:8090040d]
%   data: {"dataType":"text","outputData":{"text":"Use Basic models for all components.\nLoading in base workspace: <a href=\"matlab:edit('Vehicle1D_Basic_params.m')\">Vehicle1D_Basic_params<\/a>\nLoading in base workspace: <a href=\"matlab:edit('BatteryHV_Basic_params.m')\">BatteryHV_Basic_params<\/a>\nLoading in base workspace: <a href=\"matlab:edit('MotorDriveUnit_Basic_params.m')\">MotorDriveUnit_Basic_params<\/a>\nLoading in base workspace: <a href=\"matlab:edit('Reducer_Basic_params.m')\">Reducer_Basic_params<\/a>\nLoading in base workspace: <a href=\"matlab:edit('BEVController_Basic_params.m')\">BEVController_Basic_params<\/a>\n","truncated":false}}
%---
