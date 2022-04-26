classdef Vehicle1D_UnitTest < matlab.unittest.TestCase
% Class implementation of unit test

% Copyright 2021-2022 The MathWorks, Inc.

properties (Constant)
  modelName = "Vehicle1D_harness_model";
end

methods (Test)

function blockParameters_Vehicle1D_Driveline(testCase)
%% Check that block parameters are properly set up
% Default referenced subsystem

  close all
  bdclose all

  mdl = "Vehicle1D_refsub_Driveline";
  load_system(mdl)

  function verifyParameter(test_case, block_path, parameter_name, expected_variable, expected_unit)
    actual_entry = get_param(block_path, parameter_name);
    verifyEqual(test_case, actual_entry, expected_variable)

    actual_unit = get_param(block_path, parameter_name+"_unit");
    One_in_actual_unit = simscape.Value(1, actual_unit);
    value_in_expected_unit = value(One_in_actual_unit, expected_unit);
    verifyEqual(test_case, value_in_expected_unit, 1)
  end

  blkpath = mdl + "/Longitudinal Vehicle";

  actual = get_param(blkpath, 'vehParamType');
  verifyEqual(testCase, actual, 'sdl.enum.VehicleParameterizationType.RoadLoad')

  verifyParameter(testCase, blkpath, 'M_vehicle', 'vehicle.mass_kg', 'kg')

  verifyParameter(testCase, blkpath, 'R_tireroll', 'vehicle.tireRollingRadius_m', 'm')

  verifyParameter(testCase, blkpath, 'A_rl', 'vehicle.roadLoadA_N', 'N')

  verifyParameter(testCase, blkpath, 'B_rl', 'vehicle.roadLoadB_N_per_kph', 'N/(km/hr)')

  verifyParameter(testCase, blkpath, 'C_rl', 'vehicle.roadLoadC_N_per_kph2', 'N/(km/hr)^2')

  verifyParameter(testCase, blkpath, 'g', 'vehicle.roadLoad_gravAccel_m_per_s2', 'm/s^2')

  verifyParameter(testCase, blkpath, 'V_1', 'smoothing.vehicle_speedThreshold_kph', 'km/hr')

  verifyParameter(testCase, blkpath, 'w_1', 'smoothing.vehicle_axleSpeedThreshold_rpm', 'rpm')

  verifyParameter(testCase, blkpath, 'V_x', 'initial.vehicle_speed_kph', 'km/hr')

end  % function

function blockParameters_Vehicle1D_Custom(testCase)
%% Check that block parameters are properly set
% Optional referenced subsystem

  close all
  bdclose all

  mdl = "Vehicle1D_refsub_Custom";
  load_system(mdl)

  function verifyParameter(test_case, block_path, parameter_name, expected_variable, expected_unit)
    actual_entry = get_param(block_path, parameter_name);
    verifyEqual(test_case, actual_entry, expected_variable)

    actual_unit = get_param(block_path, parameter_name+"_unit");
    One_in_actual_unit = simscape.Value(1, actual_unit);
    value_in_expected_unit = value(One_in_actual_unit, expected_unit);
    verifyEqual(test_case, value_in_expected_unit, 1)
  end

  blkpath = mdl + "/Longitudinal Vehicle";

  verifyParameter(testCase, blkpath, 'grav', 'vehicle.roadLoad_gravAccel_m_per_s2', 'm/s^2')

  verifyParameter(testCase, blkpath, 'M_e', 'vehicle.mass_kg', 'kg')

  verifyParameter(testCase, blkpath, 'R_tire', 'vehicle.tireRollingRadius_m', 'm')

  verifyParameter(testCase, blkpath, 'A_rl', 'vehicle.roadLoadA_N', 'N')

  verifyParameter(testCase, blkpath, 'B_rl', 'vehicle.roadLoadB_N_per_kph', 'N/(km/hr)')

  verifyParameter(testCase, blkpath, 'C_rl', 'vehicle.roadLoadC_N_per_kph2', 'N/(km/hr)^2')

  verifyParameter(testCase, blkpath, 'V_1', 'smoothing.vehicle_speedThreshold_kph', 'km/hr')

  verifyParameter(testCase, blkpath, 'w_1', 'smoothing.vehicle_axleSpeedThreshold_rpm', 'rpm')

  verifyParameter(testCase, blkpath, 'V_x', 'initial.vehicle_speed_kph', 'km/hr')

end  % function

function run_harness_model_1(testCase)
%% The most basic test - just open the model and run simulation.
% Check that the model runs without any warnings or errors.

  close all
  bdclose all

  mdl = testCase.modelName;

  t_end = 10;  % Simulation stop time in seconds

  load_system(mdl)

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(t_end));

  sim(simIn);

  close all
  bdclose all
end  % function

function block_info_script_1(testCase)
%% Check that the block info script works.
% This check is only for the custom Vehicle-1D case.

  close all
  bdclose all

  mdl = testCase.modelName;
  load_system(mdl)

  % Set the non-default referenced subsystem.
  set_param(mdl+"/Longitudinal Vehicle", ...
    ReferencedSubsystem = "Vehicle1D_refsub_Custom")

  % Select subsystem.
  set_param(0, CurrentSystem = mdl+"/Longitudinal Vehicle")

  % Select block.
  set_param(gcs, CurrentBlock = "Longitudinal Vehicle")

  % A proper block must be selected for this script to work.
  Vehicle1DUtility.reportVehicle1DCustomBlock

  close all
  bdclose all
end  % function

%% Test for Inputs
% Check that the Input Signal Builder class works.

function input_Constant(~)
% All default
  close all
  builder = Vehicle1D_InputSignalBuilder;
  data = Constant(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_Brake3(~)
% Make a plot.
  close all
  builder = Vehicle1D_InputSignalBuilder('Plot_tf',true);
  data = Brake3(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_RoadGrade3(~)
% Make a plot.
  close all
  builder = Vehicle1D_InputSignalBuilder('Plot_tf',true);
  data = RoadGrade3(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
end  % function

function input_DriveAxle(~)
% Make a plot and save it as PNG file.
  close all
  builder = Vehicle1D_InputSignalBuilder('Plot_tf',true);
  builder.VisiblePlot_tf = false;
  builder.SavePlot_tf = true;  % Save
  data = DriveAxle(builder);
  data.Signals;
  data.Bus;
  data.Options.StopTime_s;
  close all
  assert(isfile("image_input_signals.png"))
  delete("image_input_signals.png")
end  % function

%% Test for Scripts
% Check that scripts run without any warnings or errors.

function run_testcase_2(~)
  close all
  bdclose all
  Vehicle1D_testcase_Coastdown
  close all
  bdclose all
end

function run_testcase_3(~)
  close all
  bdclose all
  Vehicle1D_testcase_RoadGrade3
  close all
  bdclose all
end

function run_testcase_4(~)
  close all
  bdclose all
  Vehicle1D_testcase_Brake3
  close all
  bdclose all
end

function run_testcase_5(~)
  close all
  bdclose all
  Vehicle1D_testcase_DriveAxle
  close all
  bdclose all
end

function run_main_script_1(~)
  close all
  bdclose all
  Vehicle1D_main_script
  close all
  bdclose all
end

%% Test for harness model with non-default referenced subsystems

function harness_with_non_default_refsub_1(testCase)
%% Check that the harness model works with non-default referenced subsystems.

  close all
  bdclose all

  mdl = testCase.modelName;
  load_system(mdl)

  % Set the non-default referenced subsystem.
  set_param(mdl+"/Longitudinal Vehicle", ...
    ReferencedSubsystem = "Vehicle1D_refsub_Custom")

  % === Test API

  % Select subsystem.
  set_param(0, CurrentSystem = mdl+"/Longitudinal Vehicle")

  % Select block.
  set_param(gcs, CurrentBlock = "Longitudinal Vehicle")

  block_info = Vehicle1DUtility.getVehicle1DCustomBlockInfo(gcbh);

  Vehicle1DUtility.plotRoadLoad( ...
        VehicleMass_kg = block_info.M_e_kg, ...
        RoadLoadA_N = block_info.A_rl_N, ...
        RoadLoadB_N_per_kph = block_info.B_rl_N_per_kph, ...
        RoadLoadC_N_per_kph2 = block_info.C_rl_N_per_kph2, ...
        GravitationalAcceleration_m_per_s2 = block_info.grav_m_per_s2, ...
        VehicleSpeedVector_kph = linspace(0, 160, 200), ...
        RoadGradeVector_pct = [30, 15, 0] );

  % === Test basic simulation

  vehSigBuilder = Vehicle1D_InputSignalBuilder;

  inpData = Constant(vehSigBuilder);

  simIn = Simulink.SimulationInput(mdl);
  simIn = setModelParameter(simIn, "StopTime",num2str(inpData.Options.StopTime_s));
  simIn = setVariable(simIn, "vehicle_InputSignals", inpData.Signals);
  simIn = setVariable(simIn, "vehicle_InputBus", inpData.Bus);
  simIn = setVariable(simIn, "initial.vehicle_speed_kph", ...
            inpData.Options.InitialVehicleSpeed_kph);

  v0 = inpData.Options.InitialVehicleSpeed_kph;

  simIn = setBlockParameter(simIn, ...
    mdl+"/Longitudinal Vehicle/Longitudinal Vehicle", "V_x", num2str(v0), ...
    mdl+"/Longitudinal Vehicle/Longitudinal Vehicle", "V_x_unit", "km/hr", ...
    mdl+"/Longitudinal Vehicle/Longitudinal Vehicle", "V_x_priority", "high");

  % Run simulation
  simOut = sim(simIn);

  Vehicle1D_plotResults(simOut.logsout)

  % === Test otehr simulations

  Vehicle1D_testcase_Coastdown
  Vehicle1D_testcase_DriveAxle
  Vehicle1D_testcase_Brake3
  Vehicle1D_testcase_RoadGrade3

  close all
  bdclose all
end  % function

end  % methods (Test)
end  % classdef
