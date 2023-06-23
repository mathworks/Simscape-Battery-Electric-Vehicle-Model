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

  mdl = "Vehicle1D_refsub_Basic";
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
  verifyEqual(testCase, actual, 'sdl.enum.VehicleParameterizationType.Regular')
%   verifyEqual(testCase, actual, 'sdl.enum.VehicleParameterizationType.RoadLoad')

  verifyParameter(testCase, blkpath, 'M_vehicle', 'vehicle.mass_kg', 'kg')

  verifyParameter(testCase, blkpath, 'R_tireroll', 'vehicle.tireRollingRadius_m', 'm')

  verifyParameter(testCase, blkpath, 'C_tireroll', 'vehicle.tireRollingCoeff', '1')
  verifyParameter(testCase, blkpath, 'C_airdrag', 'vehicle.airDragCoeff', '1')
  verifyParameter(testCase, blkpath, 'A_front', 'vehicle.frontalArea_m2', 'm^2')
%   verifyParameter(testCase, blkpath, 'A_rl', 'vehicle.roadLoadA_N', 'N')
%   verifyParameter(testCase, blkpath, 'B_rl', 'vehicle.roadLoadB_N_per_kph', 'N/(km/hr)')
%   verifyParameter(testCase, blkpath, 'C_rl', 'vehicle.roadLoadC_N_per_kph2', 'N/(km/hr)^2')

  verifyParameter(testCase, blkpath, 'g', 'vehicle.gravAccel_m_per_s2', 'm/s^2')

  verifyParameter(testCase, blkpath, 'V_1', 'smoothing.vehicle_speedThreshold_kph', 'km/hr')

  verifyParameter(testCase, blkpath, 'w_1', 'smoothing.vehicle_axleSpeedThreshold_rpm', 'rpm')

  verifyParameter(testCase, blkpath, 'V_x', 'initial.vehicle_speed_kph', 'km/hr')

end  % function

end  % methods (Test)
end  % classdef
