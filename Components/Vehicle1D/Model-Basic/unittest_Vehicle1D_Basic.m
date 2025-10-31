classdef unittest_Vehicle1D_Basic < matlab.unittest.TestCase
  %% Class-based unit test

  % Author Class-Based Unit Tests in MATLAB
  % https://www.mathworks.com/help/matlab/matlab_prog/author-class-based-unit-tests-in-matlab.html
  %
  % matlab.unittest.TestCase Class
  % https://www.mathworks.com/help/matlab/ref/matlab.unittest.testcase-class.html
  %
  % Test Browser
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2021-2025 The MathWorks, Inc.

  methods (TestMethodSetup)
    % Functions in this section always run before each test defined in the Test section runs.

    function test_method_setup_1(testcase)
      function closeAll
        close all
        bdclose all
      end  % nested function
      closeAll
      % addTeardown adds a function which always runs after each test.
      % Even if the execution of a test ends with an error, the teardown function runs.
      addTeardown(testcase, @closeAll)
    end  % function

  end  % methods

  methods (Test)
    % Functions in this "Test" section are the tests.
    % Before each function in this section runs, functions defined in the TestMethodSetup section run.

    %% Minimum quality check
    % Check that models, scripts, functions, and classes run right out of the box.

    function PassingTest_1(~)
      Vehicle1D_Basic_params
    end

    function PassingTest_2(~)
      load_system("Vehicle1D_Basic_refsub")
    end  % function

    %% Test callbacks

    function CallbackButtonBlock_1(testcase)
      % Check that the callback in the Callback Button block works.
      % The callback opens an App.

      evalin("base", "Vehicle1D_Basic_params")
      load_system("Vehicle1D_Basic_refsub")
      callback_text = get_param("Vehicle1D_Basic_refsub/Open app", "ClickFcn");

      % This must open an app.
      eval(callback_text)

      figs = findall(groot, "Type", "figure");
      logical_index = string({figs(:).Name}) == "Vehicle1D Performance Design App";
      verifyEqual(testcase, nnz(logical_index), 1)

      % Delete the app from the memory. (Not just close the app window.)
      target_fig = figs(logical_index);
      delete(target_fig)
    end  % function

    %% Other tests

    function BlockParameters_1(testcase)
      %% Check that block parameters are properly set up

      mdl = "Vehicle1D_Basic_refsub";
      load_system(mdl)

      function verifyParameter(test_case, block_path, parameter_name, expected_variable, expected_unit)
        actual_entry = string(get_param(block_path, parameter_name));
        verifyEqual(test_case, actual_entry, expected_variable)

        actual_unit = string(get_param(block_path, parameter_name+"_unit"));
        One_in_actual_unit = simscape.Value(1, actual_unit);
        value_in_expected_unit = value(One_in_actual_unit, expected_unit);
        verifyEqual(test_case, value_in_expected_unit, 1)
      end  % nested function

      blkpath = mdl + "/Longitudinal Vehicle";

      actual = string(get_param(blkpath, "vehParamType"));
      verifyEqual(testcase, actual, "sdl.enum.VehicleParameterizationType.Regular")

      verifyParameter(testcase, blkpath, "M_vehicle", "vehicle.mass_kg", "kg")
      verifyParameter(testcase, blkpath, "R_tireroll", "vehicle.tireRollingRadius_m", "m")
      verifyParameter(testcase, blkpath, "C_tireroll", "vehicle.tireRollingCoeff", "1")
      verifyParameter(testcase, blkpath, "C_airdrag", "vehicle.airDragCoeff", "1")
      verifyParameter(testcase, blkpath, "A_front", "vehicle.frontalArea_m2", "m^2")
      verifyParameter(testcase, blkpath, "g", "vehicle.gravAccel_m_per_s2", "m/s^2")
      verifyParameter(testcase, blkpath, "V_1", "smoothing.vehicle_speedThreshold_kph", "km/hr")
      verifyParameter(testcase, blkpath, "w_1", "smoothing.vehicle_axleSpeedThreshold_rpm", "rpm")
      verifyParameter(testcase, blkpath, "V_x", "initial.vehicle_speed_kph", "km/hr")

    end  % function

  end  % methods

end  % classdef
