classdef BatteryHV_UnitTest < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2021-2022 The MathWorks, Inc.

properties (Constant)
  modelName = "BatteryHV_harness_model";
end

methods (Test)

function blockParameters_BatteryHV_Basic(testCase)
%% Check that block parameters are properly set up

  close all
  bdclose all

  mdl = "BatteryHV_refsub_Basic";
  load_system(mdl)

  blkpath = mdl + "/DC Voltage Source";
  verifyBlockParameter_custom(testCase, blkpath, 'v0', 'batteryHV.nominalVoltage_V', 'V')

  blkpath = mdl + "/Internal Resistance";
  verifyBlockParameter_custom(testCase, blkpath, 'R', 'batteryHV.internalResistance_Ohm', 'Ohm')
  verifyBlockCheckbox_custom(testCase, blkpath, 'i_specify', 'off')
  verifyBlockCheckbox_custom(testCase, blkpath, 'v_specify', 'off')

  blkpath = mdl + "/Battery Status/Charge";
  verifyBlockParameter_custom(testCase, blkpath, 'x0', 'initial.hvBattery_Charge_Ahr', 'A*hr')

  blkpath = mdl + "/Battery Status/PS Saturation";
  verifyBlockParameter_custom(testCase, blkpath, 'upper_limit', 'batteryHV.nominalCharge_Ahr', 'A*hr')
  verifyBlockParameter_custom(testCase, blkpath, 'lower_limit', '0', 'A*hr')

  blkpath = mdl + "/Battery Status/PS Constant";
  verifyBlockParameter_custom(testCase, blkpath, 'constant', 'batteryHV.nominalCharge_Ahr', 'A*hr')

  blkpath = mdl + "/Battery Status/R";
  verifyBlockParameter_custom(testCase, blkpath, 'gain', 'batteryHV.internalResistance_Ohm', 'Ohm')

end  % function

function blockParameters_BatteryHV_Driveline(testCase)
%% Check that block parameters are properly set up

  close all
  bdclose all

  mdl = "BatteryHV_refsub_Driveline";
  load_system(mdl)

  blkpath = mdl + sprintf("/Battery"+newline+"(System-Level)");
  % Main
  verifyBlockParameter_custom(testCase, blkpath, 'Vnom', 'batteryHV.nominalVoltage_V', 'V')
  verifyBlockParameter_custom(testCase, blkpath, 'R1', 'batteryHV.internalResistance_Ohm', 'Ohm')
  verifyBlockDropdown_custom(testCase, blkpath, 'prm_AH', 'sdl.enum.InfiniteFinite.Finite')
  verifyBlockParameter_custom(testCase, blkpath, 'AH', 'batteryHV.nominalCharge_Ahr', 'A*hr')
  verifyBlockParameter_custom(testCase, blkpath, 'V1', 'batteryHV.measuredVoltage_V', 'V')
  verifyBlockParameter_custom(testCase, blkpath, 'AH1', 'batteryHV.measuredCharge_Ahr', 'A*hr')
  verifyBlockDropdown_custom(testCase, blkpath, 'prm_R2', 'sdl.enum.DisabledEnabled.Disabled')
  % Thermal Port
  verifyBlockDropdown_custom(testCase, blkpath, 'thermal_port', 'simscape.enum.thermaleffects.model')
  verifyBlockParameter_custom(testCase, blkpath, 'thermal_mass', 'batteryHV.thermalMass_kJ_per_K', 'kJ/K')
  % Initial Targets
  verifyBlockCheckbox_custom(testCase, blkpath, 'i_specify', 'off')
  verifyBlockCheckbox_custom(testCase, blkpath, 'v_specify', 'off')
  verifyBlockCheckbox_custom(testCase, blkpath, 'charge_specify', 'on')
  verifyBlockInitialPriority_custom(testCase, blkpath, 'charge_priority', 'High')
  verifyBlockParameter_custom(testCase, blkpath, 'charge', 'initial.hvBattery_Charge_Ahr', 'A*hr')
  verifyBlockCheckbox_custom(testCase, blkpath, 'temperature_specify', 'on')
  verifyBlockInitialPriority_custom(testCase, blkpath, 'temperature_priority', 'High')
  verifyBlockParameter_custom(testCase, blkpath, 'temperature', 'initial.hvBattery_Temperature_K', 'K')

  blkpath = mdl + sprintf("/Radiative Heat"+newline+"Transfer");
  verifyBlockParameter_custom(testCase, blkpath, 'area', 'batteryHV.RadiationArea_m2', 'm^2')
  verifyBlockParameter_custom(testCase, blkpath, 'rad_tr_coeff', 'batteryHV.RadiationCoeff_W_per_K4m2', 'W/(m^2*K^4)')
  verifyBlockCheckbox_custom(testCase, blkpath, 'T_specify', 'off')
  verifyBlockCheckbox_custom(testCase, blkpath, 'Q_specify', 'off')

  blkpath = mdl + "/Ambient Thermal Mass";
  verifyBlockParameter_custom(testCase, blkpath, 'mass', 'ambient.mass_t', 't')
  verifyBlockParameter_custom(testCase, blkpath, 'sp_heat', 'ambient.SpecificHeat_J_per_Kkg', 'J/(K*kg)')
  verifyBlockCheckbox_custom(testCase, blkpath, 'T_specify', 'on')
  verifyBlockInitialPriority_custom(testCase, blkpath, 'T_priority', 'High')
  verifyBlockParameter_custom(testCase, blkpath, 'T', 'initial.ambientTemp_K', 'K')

  blkpath = mdl + "/Battery Status/Charge";
  verifyBlockParameter_custom(testCase, blkpath, 'x0', 'initial.hvBattery_Charge_Ahr', 'A*hr')

  blkpath = mdl + "/Battery Status/PS Saturation";
  verifyBlockParameter_custom(testCase, blkpath, 'upper_limit', 'batteryHV.nominalCharge_Ahr', 'A*hr')
  verifyBlockParameter_custom(testCase, blkpath, 'lower_limit', '0', 'A*hr')

  blkpath = mdl + "/Battery Status/PS Constant";
  verifyBlockParameter_custom(testCase, blkpath, 'constant', 'batteryHV.nominalCharge_Ahr', 'A*hr')

  blkpath = mdl + "/Battery Status/R";
  verifyBlockParameter_custom(testCase, blkpath, 'gain', 'batteryHV.internalResistance_Ohm', 'Ohm')

end  % function

function blockParameters_BatteryHV_Electrical(testCase)
%% Check that block parameters are properly set up

%   close all
%   bdclose all

  mdl = "BatteryHV_refsub_Electrical";
  load_system(mdl)

  blkpath = mdl + "/Battery";
  % Main
  verifyBlockParameter_custom(testCase, blkpath, 'Vnom', 'batteryHV.nominalVoltage_V', 'V')
  verifyBlockDropdown_custom(testCase, blkpath, 'prm_dir', '1')  % 1 for Disabled
  verifyBlockParameter_custom(testCase, blkpath, 'R1', 'batteryHV.internalResistance_Ohm', 'Ohm')
  verifyBlockDropdown_custom(testCase, blkpath, 'prm_AH', '2')  % 2 for Finite
  verifyBlockParameter_custom(testCase, blkpath, 'AH', 'batteryHV.nominalCharge_Ahr', 'A*hr')
  verifyBlockParameter_custom(testCase, blkpath, 'V1', 'batteryHV.measuredVoltage_V', 'V')
  verifyBlockParameter_custom(testCase, blkpath, 'AH1', 'batteryHV.measuredCharge_Ahr', 'A*hr')
  verifyBlockDropdown_custom(testCase, blkpath, 'prm_R2', '1')  % 1 for Disabled
  verifyBlockParameter_custom(testCase, blkpath, 'Tmeas', 'batteryHV.measurementTemperature_K', 'K')
  % Dynamics
  verifyBlockDropdown_custom(testCase, blkpath, 'prm_dyn', '1')  % 1 for No dynamics
  % Fade
  verifyBlockDropdown_custom(testCase, blkpath, 'prm_fade', '1')  % 1 for Disabled
  % Calendar Aging
  verifyBlockDropdown_custom(testCase, blkpath, 'prm_age', '1')  % 1 for Disabled
  % Temperature Dependence
  verifyBlockParameter_custom(testCase, blkpath, 'Vnom_T2', 'batteryHV.secondNominalVoltage_V', 'V')
  verifyBlockParameter_custom(testCase, blkpath, 'R1_T2', 'batteryHV.secondInternalResistance_Ohm', 'Ohm')
  verifyBlockParameter_custom(testCase, blkpath, 'V1_T2', 'batteryHV.secondMeasuredVoltage_V', 'V')
  verifyBlockParameter_custom(testCase, blkpath, 'Tmeas2', 'batteryHV.secondMeasurementTemperature_K', 'K')
  % Temperature Dependence
  verifyBlockParameter_custom(testCase, blkpath, 'thermal_mass', 'batteryHV.thermalMass_kJ_per_K', 'kJ/K')
  % Initial Targets
  verifyBlockCheckbox_custom(testCase, blkpath, 'i_specify', 'off')
  verifyBlockCheckbox_custom(testCase, blkpath, 'v_specify', 'off')
  verifyBlockCheckbox_custom(testCase, blkpath, 'charge_specify', 'on')
  verifyBlockInitialPriority_custom(testCase, blkpath, 'charge_priority', 'High')
  verifyBlockParameter_custom(testCase, blkpath, 'charge', 'initial.hvBattery_Charge_Ahr', 'A*hr')
  verifyBlockCheckbox_custom(testCase, blkpath, 'num_cycles_specify', 'off')
  verifyBlockCheckbox_custom(testCase, blkpath, 'temperature_specify', 'on')
  verifyBlockInitialPriority_custom(testCase, blkpath, 'temperature_priority', 'High')
  verifyBlockParameter_custom(testCase, blkpath, 'temperature', 'initial.hvBattery_Temperature_K', 'K')

  blkpath = mdl + sprintf("/Radiative Heat"+newline+"Transfer");
  verifyBlockParameter_custom(testCase, blkpath, 'area', 'batteryHV.RadiationArea_m2', 'm^2')
  verifyBlockParameter_custom(testCase, blkpath, 'rad_tr_coeff', 'batteryHV.RadiationCoeff_W_per_K4m2', 'W/(m^2*K^4)')
  verifyBlockCheckbox_custom(testCase, blkpath, 'T_specify', 'off')
  verifyBlockCheckbox_custom(testCase, blkpath, 'Q_specify', 'off')

  blkpath = mdl + "/Ambient Thermal Mass";
  verifyBlockParameter_custom(testCase, blkpath, 'mass', 'ambient.mass_t', 't')
  verifyBlockParameter_custom(testCase, blkpath, 'sp_heat', 'ambient.SpecificHeat_J_per_Kkg', 'J/(K*kg)')
  verifyBlockCheckbox_custom(testCase, blkpath, 'T_specify', 'on')
  verifyBlockInitialPriority_custom(testCase, blkpath, 'T_priority', 'High')
  verifyBlockParameter_custom(testCase, blkpath, 'T', 'initial.ambientTemp_K', 'K')

  blkpath = mdl + "/Battery Status/Charge";
  verifyBlockParameter_custom(testCase, blkpath, 'x0', 'initial.hvBattery_Charge_Ahr', 'A*hr')

  blkpath = mdl + "/Battery Status/PS Saturation";
  verifyBlockParameter_custom(testCase, blkpath, 'upper_limit', 'batteryHV.nominalCharge_Ahr', 'A*hr')
  verifyBlockParameter_custom(testCase, blkpath, 'lower_limit', '0', 'A*hr')

  blkpath = mdl + "/Battery Status/PS Constant";
  verifyBlockParameter_custom(testCase, blkpath, 'constant', 'batteryHV.nominalCharge_Ahr', 'A*hr')

  blkpath = mdl + "/Battery Status/R";
  verifyBlockParameter_custom(testCase, blkpath, 'gain', 'batteryHV.internalResistance_Ohm', 'Ohm')

end  % function

function run_harness_model_with_Basic_refsub(testCase)
%% Just open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;
  load_system(mdl)

  set_param(mdl+"/High Voltage Battery", ...
    ReferencedSubsystem = "BatteryHV_refsub_Basic")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, StopTime="1");

  sim(simIn);

  close all
  bdclose all
end  % function

function run_harness_model_with_Driveline_refsub(testCase)
%% Just open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;
  load_system(mdl)

  set_param(mdl+"/High Voltage Battery", ...
    ReferencedSubsystem = "BatteryHV_refsub_Driveline")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, StopTime="1");

  sim(simIn);

  close all
  bdclose all
end  % function

function run_harness_model_with_Electrical_refsub(testCase)
%% Just open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;
  load_system(mdl)

  set_param(mdl+"/High Voltage Battery", ...
    ReferencedSubsystem = "BatteryHV_refsub_Electrical")

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, StopTime="1");

  sim(simIn);

  close all
  bdclose all
end  % function

%% Test for Inputs
% Check that the Input Signal Builder class works.

function input_Constant(~)
% All default
  close all
  builder = BatteryHV_InputSignalBuilder;
  data = Constant(builder);
  % Access fields.
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_Charge(~)
% Make a plot.
  close all
  builder = BatteryHV_InputSignalBuilder(Plot_tf=true);
  data = Charge(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_Discharge(~)
% Make a plot.
  close all
  builder = BatteryHV_InputSignalBuilder(Plot_tf=true);
  data = Discharge(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_LoadCurrentStep3(~)
% Make a plot and save it as PNG file.
  close all
  builder = BatteryHV_InputSignalBuilder(Plot_tf=true);
  builder.VisiblePlot_tf = false;
  builder.SavePlot_tf = true;  % Save
  data = LoadCurrentStep3(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
  assert(isfile("image_input_signals.png"))
  delete("image_input_signals.png")
end  % function

%% Test for Scripts
% Check that scripts run without any warnings or errors.

function run_testcase_Charge(~)
  close all
  bdclose all
  BatteryHV_testcase_Charge
  close all
  bdclose all
end

function run_testcase_Discharge(~)
  close all
  bdclose all
  BatteryHV_testcase_Discharge
  close all
  bdclose all
end

function run_testcase_LoadCurrentStep3(~)
  close all
  bdclose all
  BatteryHV_testcase_LoadCurrentStep3
  close all
  bdclose all
end

function run_main_script_1(~)
  close all
  bdclose all
  BatteryHV_main_script
  close all
  bdclose all
end

%% Test for harness model with non-default referenced subsystems





end  % methods (Test)
end  % classdef
