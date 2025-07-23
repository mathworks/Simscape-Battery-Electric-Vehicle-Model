classdef test_Vehicle1D_Utility < matlab.unittest.TestCase
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

    %% Minimum quality check
    % Check that scripts, functions, classes, and models run right out of the box.

    function PassingTest_1(~)
      Vehicle1D_plotInputs;
    end  % function

    function PassingTest_2(~)
      Vehicle1D_resetHarnessModel
    end  % function

    function PassingTest_3(~)
      % This creates the variable called initial in base workspace.
      Vehicle1D_setInitialConditions
    end  % function

    function PassingTest_4(~)
      Vehicle1D_setSimCase
    end  % function

    function PassingTest_5(~)
      Vehicle1D_setSimCase_Constant
    end  % function

    function PassingTest_6(~)
      Vehicle1D_setSimCase_Accelerate
    end  % function

    function PassingTest_7(~)
      Vehicle1D_setSimCase_Braking
    end  % function

    function PassingTest_8(~)
      Vehicle1D_setSimCase_Coastdown
    end  % function

  end  % methods
end  % classdef
