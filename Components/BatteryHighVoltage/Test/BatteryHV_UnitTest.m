classdef BatteryHV_UnitTest < BEVTestCase

% Class implementation of unit test

% Copyright 2021-2022 The MathWorks, Inc.

properties (Constant)
  modelName = "BatteryHV_harness_model";
end

methods (Test)

function blockParameters_BatteryHV_Basic(testCase)
%% Check that block parameters are properly set up

  mdl = "BatteryHV_refsub_Basic";
  BatteryHV_refsub_Basic_params
  load_system(mdl)

  blkpath = mdl + "/DC Voltage Source";
  verifyBlockParameter_custom(testCase, blkpath, 'v0', 'batteryHV.nominalVoltage_V', 'V')

  blkpath = mdl + "/Internal Resistance";
  verifyBlockParameter_custom(testCase, blkpath, 'R', 'batteryHV.internalResistance_Ohm', 'Ohm')
  verifyBlockCheckbox_custom(testCase, blkpath, 'i_specify', 'off')
  verifyBlockCheckbox_custom(testCase, blkpath, 'v_specify', 'off')

  blkpath = mdl + "/Battery Status/IV Status/Charge";
  verifyBlockParameter_custom(testCase, blkpath, 'x0', 'initial.hvBattery_Charge_Ahr', 'A*hr')

  blkpath = mdl + "/Battery Status/IV Status/PS Saturation";
  verifyBlockParameter_custom(testCase, blkpath, 'upper_limit', 'batteryHV.nominalCharge_Ahr', 'A*hr')
  verifyBlockParameter_custom(testCase, blkpath, 'lower_limit', '0', 'A*hr')

  blkpath = mdl + "/Battery Status/IV Status/PS Constant";
  verifyBlockParameter_custom(testCase, blkpath, 'constant', 'batteryHV.nominalCharge_Ahr', 'A*hr')

  blkpath = mdl + "/Battery Status/IV Status/R";
  verifyBlockParameter_custom(testCase, blkpath, 'gain', 'batteryHV.internalResistance_Ohm', 'Ohm')

end  % function

function blockParameters_BatteryHV_Driveline(testCase)
%% Check that block parameters are properly set up

  mdl = "BatteryHV_refsub_SystemSimple";
  BatteryHV_refsub_SystemSimple_params
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
  verifyBlockParameter_custom(testCase, blkpath, 'thermal_mass', 'batteryHV.ThermalMass_J_per_K', 'J/K')
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
  verifyBlockParameter_custom(testCase, blkpath, 'mass', 'batteryHV.ambientMass_t', 't')
  verifyBlockParameter_custom(testCase, blkpath, 'sp_heat', 'batteryHV.ambientSpecificHeat_J_per_Kkg', 'J/(K*kg)')
  verifyBlockCheckbox_custom(testCase, blkpath, 'T_specify', 'on')
  verifyBlockInitialPriority_custom(testCase, blkpath, 'T_priority', 'High')
  verifyBlockParameter_custom(testCase, blkpath, 'T', 'initial.ambientTemp_K', 'K')

  blkpath = mdl + "/Battery Status/IV Status/Charge";
  verifyBlockParameter_custom(testCase, blkpath, 'x0', 'initial.hvBattery_Charge_Ahr', 'A*hr')

  blkpath = mdl + "/Battery Status/IV Status/PS Saturation";
  verifyBlockParameter_custom(testCase, blkpath, 'upper_limit', 'batteryHV.nominalCharge_Ahr', 'A*hr')
  verifyBlockParameter_custom(testCase, blkpath, 'lower_limit', '0', 'A*hr')

  blkpath = mdl + "/Battery Status/IV Status/PS Constant";
  verifyBlockParameter_custom(testCase, blkpath, 'constant', 'batteryHV.nominalCharge_Ahr', 'A*hr')

  blkpath = mdl + "/Battery Status/IV Status/R";
  verifyBlockParameter_custom(testCase, blkpath, 'gain', 'batteryHV.internalResistance_Ohm', 'Ohm')

end  % function

function blockParameters_BatteryHV_Electrical(testCase)
%% Check that block parameters are properly set up

  mdl = "BatteryHV_refsub_System";
  BatteryHV_refsub_System_params
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
  verifyBlockDropdown_custom(testCase, blkpath, 'prm_fade', 'simscape.enum.battery.prm_fade.disabled')
  % Calendar Aging
  verifyBlockDropdown_custom(testCase, blkpath, 'prm_age', 'simscape.enum.battery.prm_age.disabled')
  % Temperature Dependence
  verifyBlockParameter_custom(testCase, blkpath, 'Vnom_T2', 'batteryHV.secondNominalVoltage_V', 'V')
  verifyBlockParameter_custom(testCase, blkpath, 'R1_T2', 'batteryHV.secondInternalResistance_Ohm', 'Ohm')
  verifyBlockParameter_custom(testCase, blkpath, 'V1_T2', 'batteryHV.secondMeasuredVoltage_V', 'V')
  verifyBlockParameter_custom(testCase, blkpath, 'Tmeas2', 'batteryHV.secondMeasurementTemperature_K', 'K')
  % Temperature Dependence
  verifyBlockParameter_custom(testCase, blkpath, 'thermal_mass', 'batteryHV.ThermalMass_J_per_K', 'J/K')
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
  verifyBlockParameter_custom(testCase, blkpath, 'mass', 'batteryHV.ambientMass_t', 't')
  verifyBlockParameter_custom(testCase, blkpath, 'sp_heat', 'batteryHV.ambientSpecificHeat_J_per_Kkg', 'J/(K*kg)')
  verifyBlockCheckbox_custom(testCase, blkpath, 'T_specify', 'on')
  verifyBlockInitialPriority_custom(testCase, blkpath, 'T_priority', 'High')
  verifyBlockParameter_custom(testCase, blkpath, 'T', 'initial.ambientTemp_K', 'K')

  blkpath = mdl + "/Battery Status/IV Status/Charge";
  verifyBlockParameter_custom(testCase, blkpath, 'x0', 'initial.hvBattery_Charge_Ahr', 'A*hr')

  blkpath = mdl + "/Battery Status/IV Status/PS Saturation";
  verifyBlockParameter_custom(testCase, blkpath, 'upper_limit', 'batteryHV.nominalCharge_Ahr', 'A*hr')
  verifyBlockParameter_custom(testCase, blkpath, 'lower_limit', '0', 'A*hr')

  blkpath = mdl + "/Battery Status/IV Status/PS Constant";
  verifyBlockParameter_custom(testCase, blkpath, 'constant', 'batteryHV.nominalCharge_Ahr', 'A*hr')

  blkpath = mdl + "/Battery Status/IV Status/R";
  verifyBlockParameter_custom(testCase, blkpath, 'gain', 'batteryHV.internalResistance_Ohm', 'Ohm')

end  % function

end  % methods (Test)
end  % classdef
