classdef MotorDriveUnit_test_Utility_MDU < matlab.unittest.TestCase
  %% Class implementation of unit test
  % You can run this test by opening in MATLAB Editor and clicking
  % Run Tests button or Run Current Test button.
  %
  % Use Test Browser (testBrowser) for navigating the tests.
  % https://www.mathworks.com/help/matlab/ref/testbrowser-app.html

  % Copyright 2021-2025 The MathWorks, Inc.

  methods (TestMethodSetup)
    % Functions/methods defined in this TestMethodSetup section run before
    % every test defined in the Test section starts.

    function setup_test_method(testcase)

      function close_all()
        close all
        bdclose all
      end  % nested function

      close_all()

      % Registering a clean up function to the testcase object here before
      % the test starts ensures that the clean up happens even when
      % a test terminates midway due to an error.
      addTeardown(testcase, @close_all)

    end % function

  end  % methods

  methods (Test)

    %% Minimum Quality Check (MQC)
    % Test that scripts, functions, classes, and models run out of the box.

    function MQC_EfficiencyPlot_1(~)
      MotorDriveUnit_EfficiencyPlot
    end  % function

    function MQC_setInitialConditions_1(~)
      MotorDriveUnit_setInitialConditions
    end  % function

    function MQC_setReferencedSubsystem_1(~)
      MotorDriveUnit_setReferencedSubsystem
    end  % function

    function MQC_setSimulationCase_1(~)
      MotorDriveUnit_setSimulationCase
    end  % function

    function MQC_setSimCase_Constant_1(~)
      MotorDriveUnit_setSimCase_Constant
    end  % function

    function MQC_setSimCase_Drive_1(~)
      MotorDriveUnit_setSimCase_Drive
    end  % function

    function MQC_setSimCase_Random_1(~)
      MotorDriveUnit_setSimCase_Random
    end  % function

    function MQC_setSimCase_RegenBrake_1(~)
      MotorDriveUnit_setSimCase_RegenBrake
    end  % function

  end  % methods
end  % classdef
